#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "DRY-RUN MODE: No changes will be made"
  echo ""
fi

echo "=== Updating CodeXen ==="
echo ""

# Function: update or skip with conflict resolution
update_or_skip() {
  local source="$1"
  local dest="$2"
  local name="$3"

  if [ ! -f "$dest" ]; then
    [ "$DRY_RUN" = true ] && echo "[DRY-RUN] Would add: $name" || { cp "$source" "$dest" && echo "Added: $name"; }
  elif ! diff -q "$source" "$dest" > /dev/null 2>&1; then
    if [ "$DRY_RUN" = true ]; then
      echo "[DRY-RUN] Would update: $name (CONFLICT)"
    else
      echo ""
      echo "CONFLICT: $name differs from CodeXen version"
      echo "  [1] Keep mine (custom) - skip"
      echo "  [2] Use CodeXen version - overwrite"
      echo "  [3] Show diff"
      read -p "Choice [1]: " choice
      case "$choice" in
        2) cp "$source" "$dest" && echo "Updated: $name" ;;
        3)
          echo "--- Your version ---"
          head -20 "$dest"
          echo "--- CodeXen version ---"
          head -20 "$source"
          echo ""
          read -p "Choose [1=keep, 2=use codexen]: " choice2
          case "$choice2" in
            2) cp "$source" "$dest" && echo "Updated: $name" ;;
            *) echo "Keeping your version" ;;
          esac
          ;;
        *) echo "Keeping your version" ;;
      esac
    fi
  else
    echo "Skipping: $name (unchanged)"
  fi
}

echo "=== Agents ==="
mkdir -p ~/.config/opencode/agents
for f in core/agents/*.md; do
  agent_name=$(basename "$f")
  dest=~/.config/opencode/agents/"$agent_name"
  update_or_skip "$f" "$dest" "agent/$agent_name"
done

echo ""
echo "=== Skills ==="
for f in core/skills/*/*.md; do
  skill_name=$(basename "$f")
  skill_dir=$(basename "$(dirname "$f")")
  dest=~/.config/opencode/skills/"$skill_dir"/"$skill_name"
  mkdir -p ~/.config/opencode/skills/"$skill_dir"
  update_or_skip "$f" "$dest" "skill/$skill_dir/$skill_name"
done

echo ""
echo "=== Plugins (.opencode) ==="
mkdir -p ~/.config/opencode/plugin ~/.config/opencode/command

for f in core/.opencode/plugin/*.ts; do
  if [ -f "$f" ]; then
    fname=$(basename "$f")
    dest=~/.config/opencode/plugin/"$fname"
    update_or_skip "$f" "$dest" "plugin/$fname"
  fi
done

for f in core/.opencode/command/*.md; do
  if [ -f "$f" ]; then
    fname=$(basename "$f")
    dest=~/.config/opencode/command/"$fname"
    update_or_skip "$f" "$dest" "command/$fname"
  fi
done

# package.json
if [ -f core/.opencode/package.json ]; then
  dest_pkg=~/.config/opencode/package.json
  update_or_skip core/.opencode/package.json "$dest_pkg" "package.json"
fi

echo ""
echo "=== Config (opencode.json) ==="
if [ -f core/opencode.json ]; then
  dest_json=~/.config/opencode/opencode.json
  if [ ! -f "$dest_json" ]; then
    [ "$DRY_RUN" = true ] && echo "[DRY-RUN] Would add: opencode.json" || { cp core/opencode.json "$dest_json" && echo "Added: opencode.json"; }
  elif ! diff -q core/opencode.json "$dest_json" > /dev/null 2>&1; then
    if [ "$DRY_RUN" = true ]; then
      echo "[DRY-RUN] Would update: opencode.json (CONFLICT)"
    else
      echo ""
      echo "CONFLICT: opencode.json differs from CodeXen version"
      echo "  [1] Keep mine (custom) - skip"
      echo "  [2] Use CodeXen version - overwrite"
      echo "  [3] Merge (add new settings, keep yours)"
      echo "  [4] Show diff"
      read -p "Choice [1]: " choice
      case "$choice" in
        2) cp core/opencode.json "$dest_json" && echo "Updated: opencode.json" ;;
        3)
          if command -v jq >/dev/null 2>&1; then
            jq -s '.[0] * .[1]' "$dest_json" core/opencode.json > "$dest_json.tmp" && \
            mv "$dest_json.tmp" "$dest_json" && \
            echo "Merged: opencode.json"
          else
            echo "jq not found - keeping your config"
          fi
          ;;
        4)
          echo "--- Your version ---"
          cat "$dest_json"
          echo "--- CodeXen version ---"
          cat core/opencode.json
          echo ""
          read -p "Choose [1=keep, 2=overwrite, 3=merge]: " choice2
          case "$choice2" in
            2) cp core/opencode.json "$dest_json" && echo "Updated: opencode.json" ;;
            3)
              if command -v jq >/dev/null 2>&1; then
                jq -s '.[0] * .[1]' "$dest_json" core/opencode.json > "$dest_json.tmp" && \
                mv "$dest_json.tmp" "$dest_json" && \
                echo "Merged: opencode.json"
              else
                echo "jq not found - keeping your config"
              fi
              ;;
            *) echo "Keeping your config" ;;
          esac
          ;;
        *) echo "Keeping your config" ;;
      esac
    fi
  else
    echo "Skipping: opencode.json (unchanged)"
  fi
fi

echo ""
echo "=== Global Memory Templates ==="
mkdir -p ~/.config/opencode/global-memory/work-diary/archive

for f in templates/global-memory/*.md; do
  if [ -f "$f" ]; then
    fname=$(basename "$f")
    dest=~/.config/opencode/global-memory/"$fname"
    update_or_skip "$f" "$dest" "global-memory/$fname"
  fi
done

# work-diary template
if [ ! -d ~/.config/opencode/global-memory/work-diary ]; then
  mkdir -p ~/.config/opencode/global-memory/work-diary
fi
if [ ! -f ~/.config/opencode/global-memory/work-diary/diary-YYYY-MM.md ]; then
  if [ -f templates/global-memory/work-diary/diary-YYYY-MM.md ]; then
    cp templates/global-memory/work-diary/diary-YYYY-MM.md ~/.config/opencode/global-memory/work-diary/ && echo "Added: work-diary/diary-YYYY-MM.md"
  fi
fi

echo ""
echo "=== Validation Script ==="
mkdir -p ~/.config/opencode/scripts
update_or_skip scripts/validate.sh ~/.config/opencode/scripts/validate.sh "validate.sh"

echo ""
echo "=== Summary ==="
echo ""
echo "Files in ~/.config/opencode/:"
echo "  Agents: $(ls ~/.config/opencode/agents/*.md 2>/dev/null | wc -l) files"
echo "  Skills: $(ls -d ~/.config/opencode/skills/*/ 2>/dev/null | wc -l) directories"
echo "  Plugins: $(ls ~/.config/opencode/plugin/*.ts 2>/dev/null | wc -l) files"
echo "  Commands: $(ls ~/.config/opencode/command/*.md 2>/dev/null | wc -l) files"
echo ""
[ "$DRY_RUN" = true ] && echo "DRY-RUN complete. Run without --dry-run to apply." || echo "Update complete!"
