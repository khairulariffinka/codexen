#!/bin/bash
set -euo pipefail

# Install script for CodeXen v0.8.0
# Usage: bash install.sh [--dry-run]

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "DRY-RUN MODE: No changes will be made"
  echo ""
fi

# Create directories
mkdir -p ~/.config/opencode/agents
mkdir -p ~/.config/opencode/skills
mkdir -p ~/.config/opencode/global-memory/work-diary/archive
mkdir -p ~/.config/opencode/scripts

# Determine script directory (repo root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Backup before install
if [ "$DRY_RUN" = false ]; then
  if [ -d ~/.config/opencode ]; then
    BACKUP_DIR="$HOME/.config/opencode.backup-$(date +%Y-%m-%d-%H%M)"
    cp -r ~/.config/opencode "$BACKUP_DIR" && echo "Backup created: $BACKUP_DIR"
  fi
fi

# Function: update or skip file
update_or_skip() {
  local source="$1"
  local dest="$2"
  local name="$3"

  if [ ! -f "$dest" ]; then
    [ "$DRY_RUN" = true ] && echo "[DRY-RUN] Would add: $name" || { cp "$source" "$dest" && echo "Added: $name"; }
  elif ! diff -q "$source" "$dest" > /dev/null 2>&1; then
    [ "$DRY_RUN" = true ] && echo "[DRY-RUN] Would update: $name" || { cp "$source" "$dest" && echo "Updated: $name"; }
  else
    echo "Skipping: $name (unchanged)"
  fi
}

echo ""
echo "=== Installing Agents ==="
for f in "$SCRIPT_DIR"/core/agents/*.md; do
  agent_name=$(basename "$f")
  dest="$HOME/.config/opencode/agents/$agent_name"
  update_or_skip "$f" "$dest" "$agent_name"
done

echo ""
echo "=== Installing Skills ==="
for f in "$SCRIPT_DIR"/core/skills/*/SKILL.md; do
  skill_dir=$(basename "$(dirname "$f")")
  mkdir -p "$HOME/.config/opencode/skills/$skill_dir"
  dest="$HOME/.config/opencode/skills/$skill_dir/SKILL.md"
  update_or_skip "$f" "$dest" "$skill_dir"
done

echo ""
echo "=== Installing Config ==="
if [ -f ~/.config/opencode/opencode.json ]; then
  if ! diff -q "$SCRIPT_DIR/core/opencode.json" ~/.config/opencode/opencode.json > /dev/null 2>&1; then
    if [ "$DRY_RUN" = true ]; then
      echo "[DRY-RUN] Would update: opencode.json (CONFLICT - user has custom config)"
    else
      echo ""
      echo "WARNING: opencode.json differs from CodeXen version"
      echo "  [1] Keep mine - skip (RECOMMENDED)"
      echo "  [2] Overwrite with CodeXen version"
      echo "  [3] Merge (requires jq)"
      read -p "Choice [1]: " choice
      case "$choice" in
        2) cp "$SCRIPT_DIR/core/opencode.json" ~/.config/opencode/opencode.json && echo "Updated: opencode.json" ;;
        3)
          if command -v jq >/dev/null 2>&1; then
            TMPFILE=$(mktemp ~/.config/opencode/opencode.json.XXXXXX)
            trap 'rm -f "$TMPFILE"' EXIT
            jq -s '.[0] * .[1]' ~/.config/opencode/opencode.json "$SCRIPT_DIR/core/opencode.json" > "$TMPFILE" && \
            mv "$TMPFILE" ~/.config/opencode/opencode.json && \
            echo "Merged: opencode.json"
          else
            echo "jq not found - keeping your config. Install jq for merge."
          fi
          ;;
        *) echo "Keeping your config" ;;
      esac
    fi
  else
    echo "Skipping: opencode.json (unchanged)"
  fi
else
  [ "$DRY_RUN" = true ] && echo "[DRY-RUN] Would add: opencode.json" || { cp "$SCRIPT_DIR/core/opencode.json" ~/.config/opencode/opencode.json && echo "Added: opencode.json"; }
fi

echo ""
echo "=== Installing Global Memory Templates ==="
gm_dir="$HOME/.config/opencode/global-memory"
mkdir -p "$gm_dir/work-diary/archive"
for f in "$SCRIPT_DIR"/templates/global-memory/*; do
  fname=$(basename "$f")
  dest="$gm_dir/$fname"
  if [ -f "$f" ]; then
    if [ ! -f "$dest" ]; then
      [ "$DRY_RUN" = true ] && echo "[DRY-RUN] Would add: $fname" || { cp "$f" "$dest" && echo "Added: $fname"; }
    else
      echo "Skipping: $fname (already exists)"
    fi
  fi
done
# Also copy work-diary template if missing
if [ ! -f "$gm_dir/work-diary/diary-YYYY-MM.md" ]; then
  [ "$DRY_RUN" = true ] && echo "[DRY-RUN] Would add: work-diary/diary-YYYY-MM.md" || { cp "$SCRIPT_DIR/templates/global-memory/work-diary/diary-YYYY-MM.md" "$gm_dir/work-diary/" && echo "Added: work-diary/diary-YYYY-MM.md"; }
fi

echo ""
echo "=== Installing Validation Script ==="
update_or_skip "$SCRIPT_DIR/scripts/validate.sh" "$HOME/.config/opencode/scripts/validate.sh" "validate.sh"

echo ""
[ "$DRY_RUN" = true ] && echo "DRY-RUN complete. Run without --dry-run to apply." || echo "Install complete!"