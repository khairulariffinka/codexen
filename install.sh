#!/bin/bash
set -euo pipefail

# Install script for CodeXen v0.9.1
# Usage: bash install.sh [--dry-run]
#
# Conflict defaults:
#   agents/skills/commands/plugins : overwritten (a full backup is made first)
#   opencode.json / package.json   : Enter = merge (your values win), no input = keep yours
#   global-memory templates        : never overwritten

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "DRY-RUN MODE: No changes will be made"
  echo ""
fi

# shellcheck source=scripts/common.sh
source "$SCRIPT_DIR/scripts/common.sh"

# Backup before touching anything
backup_config

ensure_dir "$OC_DIR"

echo ""
echo "=== Installing Agents ==="
for f in "$SCRIPT_DIR"/core/agents/*.md; do
  copy_file "$f" "$OC_DIR/agents/$(basename "$f")" "$(basename "$f")" overwrite
done

echo ""
echo "=== Installing Skills ==="
for f in "$SCRIPT_DIR"/core/skills/*/SKILL.md; do
  skill_dir=$(basename "$(dirname "$f")")
  copy_file "$f" "$OC_DIR/skills/$skill_dir/SKILL.md" "$skill_dir" overwrite
done

echo ""
echo "=== Installing Commands ==="
for f in "$SCRIPT_DIR"/core/commands/*.md; do
  [ -f "$f" ] || continue
  copy_file "$f" "$OC_DIR/commands/$(basename "$f")" "commands/$(basename "$f")" overwrite
done

echo ""
echo "=== Installing Config ==="
merge_json_file "$SCRIPT_DIR/core/opencode.json" "$OC_DIR/opencode.json" "opencode.json"

echo ""
echo "=== Installing Plugins ==="
if [ -d "$SCRIPT_DIR/core/.opencode" ]; then
  for f in "$SCRIPT_DIR"/core/.opencode/plugin/*.ts; do
    [ -f "$f" ] || continue
    copy_file "$f" "$OC_DIR/plugin/$(basename "$f")" "plugin/$(basename "$f")" overwrite
  done
  for f in "$SCRIPT_DIR"/core/.opencode/command/*.md; do
    [ -f "$f" ] || continue
    copy_file "$f" "$OC_DIR/command/$(basename "$f")" "command/$(basename "$f")" overwrite
  done
  if [ -f "$SCRIPT_DIR/core/.opencode/package.json" ]; then
    merge_json_file "$SCRIPT_DIR/core/.opencode/package.json" "$OC_DIR/package.json" "package.json"
  fi
else
  echo "No plugins directory found (skipping)"
fi

echo ""
echo "=== Installing Global Memory Templates ==="
ensure_dir "$OC_DIR/global-memory/work-diary/archive"
for f in "$SCRIPT_DIR"/templates/global-memory/*; do
  [ -f "$f" ] || continue
  copy_file "$f" "$OC_DIR/global-memory/$(basename "$f")" "global-memory/$(basename "$f")" keep
done
copy_file "$SCRIPT_DIR/templates/global-memory/work-diary/diary-YYYY-MM.md" \
  "$OC_DIR/global-memory/work-diary/diary-YYYY-MM.md" "work-diary/diary-YYYY-MM.md" keep

echo ""
echo "=== Installing Validation Script ==="
copy_file "$SCRIPT_DIR/scripts/validate.sh" "$OC_DIR/scripts/validate.sh" "validate.sh" overwrite

echo ""
if [ "$DRY_RUN" = true ]; then
  echo "DRY-RUN complete. Run without --dry-run to apply."
else
  echo "Install complete! Restart OpenCode to load the plugin and new commands."
fi
