#!/bin/bash
# Shared helpers for install.sh and update_script.sh
# Sourced, not executed. Expects: DRY_RUN (true|false)

OC_DIR="${OC_DIR:-$HOME/.config/opencode}"

# ask <prompt> <default-on-enter> <default-on-eof>
# Prints the chosen value. Enter -> default; no stdin (EOF/non-interactive) -> safe default.
ask() {
  local prompt="$1" on_enter="$2" on_eof="$3" reply
  if read -r -p "$prompt" reply; then
    echo "${reply:-$on_enter}"
  else
    echo "" >&2
    echo "  (no input — using safe default)" >&2
    echo "$on_eof"
  fi
}

ensure_dir() {
  [ "$DRY_RUN" = true ] && return 0
  mkdir -p "$1"
}

# json_merge <codexen.json> <user.json>
# Deep merge: user values win, new CodeXen keys are added. Arrays are not merged
# (user's array wins). Top-level CodeXen keys starting with "_" (comments) are
# not copied. Tries jq -> node -> python3. Returns 1 if none available
# or if either file is not valid JSON (e.g. JSONC with comments).
json_merge() {
  local src="$1" dest="$2" tmp
  tmp=$(mktemp "${dest}.XXXXXX") || return 1
  if command -v jq >/dev/null 2>&1 && jq -s '(.[0] | with_entries(select(.key | startswith("_") | not))) * .[1]' "$src" "$dest" >"$tmp" 2>/dev/null; then
    :
  elif command -v node >/dev/null 2>&1 && node -e '
      const fs = require("fs");
      const [a, b, out] = process.argv.slice(1);
      const isObj = (v) => v && typeof v === "object" && !Array.isArray(v);
      const merge = (base, over) => {
        if (!isObj(base) || !isObj(over)) return over;
        const r = { ...base };
        for (const k of Object.keys(over)) r[k] = k in base ? merge(base[k], over[k]) : over[k];
        return r;
      };
      const base = JSON.parse(fs.readFileSync(a, "utf8"));
      if (isObj(base)) for (const k of Object.keys(base)) if (k.startsWith("_")) delete base[k];
      const res = merge(base, JSON.parse(fs.readFileSync(b, "utf8")));
      fs.writeFileSync(out, JSON.stringify(res, null, 2) + "\n");
    ' "$src" "$dest" "$tmp" 2>/dev/null; then
    :
  elif command -v python3 >/dev/null 2>&1 && python3 - "$src" "$dest" "$tmp" 2>/dev/null <<'PY'
import json, sys
a, b, out = sys.argv[1:4]
def merge(base, over):
    if not (isinstance(base, dict) and isinstance(over, dict)):
        return over
    r = dict(base)
    for k, v in over.items():
        r[k] = merge(base[k], v) if k in base else v
    return r
with open(a) as fa, open(b) as fb:
    base = json.load(fa)
    if isinstance(base, dict):
        base = {k: v for k, v in base.items() if not k.startswith("_")}
    res = merge(base, json.load(fb))
with open(out, "w") as fo:
    json.dump(res, fo, indent=2)
    fo.write("\n")
PY
  then
    :
  else
    rm -f "$tmp"
    return 1
  fi
  mv "$tmp" "$dest"
}

# copy_file <src> <dest> <label> <mode>
#   mode=overwrite : add if missing, overwrite if different (install; backup exists)
#   mode=prompt    : add if missing, ask keep/overwrite/diff if different (default keep)
#   mode=keep      : add if missing, never touch existing (user data)
copy_file() {
  local src="$1" dest="$2" name="$3" mode="$4" choice
  if [ ! -f "$dest" ]; then
    if [ "$DRY_RUN" = true ]; then echo "[DRY-RUN] Would add: $name"; return 0; fi
    mkdir -p "$(dirname "$dest")" && cp "$src" "$dest" && echo "Added: $name"
    return 0
  fi
  if diff -q "$src" "$dest" >/dev/null 2>&1; then
    echo "Skipping: $name (unchanged)"
    return 0
  fi
  case "$mode" in
    keep)
      echo "Skipping: $name (already exists — your copy kept)"
      ;;
    overwrite)
      if [ "$DRY_RUN" = true ]; then echo "[DRY-RUN] Would update: $name"; return 0; fi
      cp "$src" "$dest" && echo "Updated: $name"
      ;;
    prompt)
      if [ "$DRY_RUN" = true ]; then echo "[DRY-RUN] Would update: $name (CONFLICT)"; return 0; fi
      echo ""
      echo "CONFLICT: $name differs from CodeXen version"
      echo "  [1] Keep mine (custom) - skip (default)"
      echo "  [2] Use CodeXen version - overwrite"
      echo "  [3] Show diff"
      choice=$(ask "Choice [1]: " 1 1)
      if [ "$choice" = "3" ]; then
        diff -u "$dest" "$src" | head -60 || true
        choice=$(ask "Choose [1=keep, 2=use CodeXen] [1]: " 1 1)
      fi
      if [ "$choice" = "2" ]; then
        cp "$src" "$dest" && echo "Updated: $name"
      else
        echo "Keeping your version: $name"
      fi
      ;;
  esac
}

# merge_json_file <src> <dest> <label>
# For opencode.json / package.json: default (Enter) = merge, no input = keep.
merge_json_file() {
  local src="$1" dest="$2" name="$3" choice
  if [ ! -f "$dest" ]; then
    if [ "$DRY_RUN" = true ]; then echo "[DRY-RUN] Would add: $name"; return 0; fi
    mkdir -p "$(dirname "$dest")" && cp "$src" "$dest" && echo "Added: $name"
    return 0
  fi
  if diff -q "$src" "$dest" >/dev/null 2>&1; then
    echo "Skipping: $name (unchanged)"
    return 0
  fi
  if [ "$DRY_RUN" = true ]; then echo "[DRY-RUN] Would merge: $name (CONFLICT - you have custom config)"; return 0; fi
  echo ""
  echo "CONFLICT: $name differs from CodeXen version"
  echo "  [1] Merge - keep your settings + add new CodeXen keys (RECOMMENDED, default)"
  echo "  [2] Keep mine - skip (no changes)"
  echo "  [3] Overwrite with CodeXen version"
  echo "  [4] Show diff"
  choice=$(ask "Choice [1]: " 1 2)
  if [ "$choice" = "4" ]; then
    diff -u "$dest" "$src" | head -80 || true
    choice=$(ask "Choose [1=merge, 2=keep mine, 3=overwrite] [1]: " 1 2)
  fi
  case "$choice" in
    1)
      if json_merge "$src" "$dest"; then
        echo "Merged: $name (your settings kept + new CodeXen keys added)"
      else
        echo "Could not merge $name (need jq, node or python3, and valid JSON) — keeping your config"
      fi
      ;;
    3) cp "$src" "$dest" && echo "Updated: $name (overwritten)" ;;
    *) echo "Keeping your config: $name" ;;
  esac
}

# backup_config: copy ~/.config/opencode to a unique timestamped folder
backup_config() {
  [ "$DRY_RUN" = true ] && return 0
  [ -d "$OC_DIR" ] || return 0
  [ -n "$(ls -A "$OC_DIR" 2>/dev/null)" ] || return 0
  local base="${OC_DIR}.backup-$(date +%Y-%m-%d-%H%M%S)" n=1
  local dest="$base"
  while [ -e "$dest" ]; do dest="$base-$n"; n=$((n + 1)); done
  cp -r "$OC_DIR" "$dest" && echo "Backup created: $dest"
}
