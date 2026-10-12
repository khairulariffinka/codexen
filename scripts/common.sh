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

# is_pristine <src> <dest>
# True if <dest> is byte-identical to some earlier CodeXen release of <src>
# (its blob hash appears in the repo's git history for that path). Such a file
# was never customised by the user, so updating it loses nothing.
# Needs git + a clone with history; otherwise returns false (caller prompts).
is_pristine() {
  local src="$1" dest="$2" repo rel h
  command -v git >/dev/null 2>&1 || return 1
  repo="${SCRIPT_DIR:-$(pwd)}"
  git -C "$repo" rev-parse --git-dir >/dev/null 2>&1 || return 1
  case "$src" in
    "$repo"/*) rel="${src#"$repo"/}" ;;
    /*) return 1 ;;
    *) rel="$src" ;;
  esac
  h=$(git hash-object "$dest" 2>/dev/null) || return 1
  # grep must read all input: with pipefail, grep -q exiting early SIGPIPEs git → false negative
  git -C "$repo" log --all --format= --raw --no-abbrev -- "$rel" 2>/dev/null | grep " $h " >/dev/null
}

# json_refresh_defaults <codexen.json> <user.json>
# Before a user-wins merge: any value in the user's file that equals the value an
# earlier CodeXen release had at the same path (git history of <codexen.json>) was
# never customised, so it is replaced by the current CodeXen value. Keys CodeXen
# dropped are removed ONLY if listed in CODEXEN_RETIRED_KEYS (e.g. user choices like
# small_model once shipped as a default must never be deleted). Customised values
# are untouched. Prints changed paths.
# Needs git history + node; otherwise does nothing (plain merge still runs).
CODEXEN_RETIRED_KEYS="${CODEXEN_RETIRED_KEYS:-instructions}"
json_refresh_defaults() {
  local src="$1" dest="$2" repo rel hist commit n=0
  command -v git >/dev/null 2>&1 && command -v node >/dev/null 2>&1 || return 0
  repo="${SCRIPT_DIR:-$(pwd)}"
  git -C "$repo" rev-parse --git-dir >/dev/null 2>&1 || return 0
  case "$src" in
    "$repo"/*) rel="${src#"$repo"/}" ;;
    /*) return 0 ;;
    *) rel="$src" ;;
  esac
  hist=$(mktemp -d) || return 0
  while read -r commit; do
    [ -n "$commit" ] || continue
    git -C "$repo" show "$commit:$rel" >"$hist/$n.json" 2>/dev/null || rm -f "$hist/$n.json"
    n=$((n + 1))
  done < <(git -C "$repo" log --all --format=%H -- "$rel" 2>/dev/null)
  RETIRED="$CODEXEN_RETIRED_KEYS" node - "$src" "$dest" "$hist" <<'NODE' || true
const fs = require("fs"), path = require("path")
const [src, dest, dir] = process.argv.slice(2)
const isObj = (v) => v && typeof v === "object" && !Array.isArray(v)
const canon = (v) => isObj(v) ? Object.fromEntries(Object.keys(v).sort().map((k) => [k, canon(v[k])])) : Array.isArray(v) ? v.map(canon) : v
const eq = (a, b) => JSON.stringify(canon(a)) === JSON.stringify(canon(b))
let user, cur
try { user = JSON.parse(fs.readFileSync(dest, "utf8")); cur = JSON.parse(fs.readFileSync(src, "utf8")) } catch { process.exit(0) }
const olds = []
for (const f of fs.readdirSync(dir)) { try { olds.push(JSON.parse(fs.readFileSync(path.join(dir, f), "utf8"))) } catch {} }
const DROP = Symbol("drop"), changed = []
const retired = new Set((process.env.RETIRED || "").split(/[\s,]+/).filter(Boolean))
function refresh(u, now, prev, at) {
  if (at && prev.some((o) => eq(o, u)) && !eq(u, now)) {
    if (now !== undefined) { changed.push(at); return now }
    if (retired.has(at)) { changed.push(at + " (removed)"); return DROP }
  }
  if (!isObj(u)) return u
  for (const k of Object.keys(u)) {
    const r = refresh(u[k], isObj(now) ? now[k] : undefined, prev.filter(isObj).map((o) => o[k]).filter((v) => v !== undefined), at ? `${at}.${k}` : k)
    if (r === DROP) delete u[k]; else u[k] = r
  }
  return u
}
const out = refresh(user, cur, olds, "")
if (changed.length && out !== DROP) {
  fs.writeFileSync(dest, JSON.stringify(out, null, 2) + "\n")
  console.log(changed.join(", "))
}
NODE
  rm -rf "$hist"
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
      # Unmodified older CodeXen file → safe to update without asking
      if is_pristine "$src" "$dest"; then
        if [ "$DRY_RUN" = true ]; then echo "[DRY-RUN] Would update: $name (unmodified CodeXen file)"; return 0; fi
        cp "$src" "$dest" && echo "Updated: $name (unmodified CodeXen file)"
        return 0
      fi
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
      local refreshed
      refreshed=$(json_refresh_defaults "$src" "$dest")
      [ -n "$refreshed" ] && echo "Refreshed old CodeXen defaults in $name: $refreshed"
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

# remove_legacy <path> <marker> <label>
# Removes a file left by an older CodeXen layout (e.g. singular plugin/ or command/
# dirs that would load twice). Only removes it if it contains <marker>, so user
# files with the same name are never deleted. Empty parent dir is removed too.
remove_legacy() {
  local path="$1" marker="$2" name="$3"
  [ -f "$path" ] || return 0
  if ! grep -q -- "$marker" "$path" 2>/dev/null; then
    echo "Skipping legacy cleanup: $name (not a CodeXen file — left as-is)"
    return 0
  fi
  if [ "$DRY_RUN" = true ]; then echo "[DRY-RUN] Would remove legacy: $name"; return 0; fi
  rm -f "$path" && echo "Removed legacy: $name"
  rmdir "$(dirname "$path")" 2>/dev/null || true
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
