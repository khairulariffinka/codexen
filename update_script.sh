#!/bin/bash
set -euo pipefail

# Update script for CodeXen v0.9.1
# Usage: bash update_script.sh [--dry-run]
#
# Conflict defaults:
#   agents/skills/commands/plugins : ask — Enter or no input = keep yours
#   opencode.json / package.json   : Enter = merge (your values win), no input = keep yours
#   global-memory templates        : never overwritten (your profile/memory is yours)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "DRY-RUN MODE: No changes will be made"
  echo ""
fi

# shellcheck source=scripts/common.sh
source "$SCRIPT_DIR/scripts/common.sh"

echo "=== Updating CodeXen ==="
backup_config
echo ""

echo "=== Agents ==="
for f in core/agents/*.md; do
  copy_file "$f" "$OC_DIR/agents/$(basename "$f")" "agent/$(basename "$f")" prompt
done

echo ""
echo "=== Skills ==="
for f in core/skills/*/*.md; do
  skill_dir=$(basename "$(dirname "$f")")
  copy_file "$f" "$OC_DIR/skills/$skill_dir/$(basename "$f")" "skill/$skill_dir/$(basename "$f")" prompt
done

echo ""
echo "=== Commands ==="
for f in core/commands/*.md; do
  [ -f "$f" ] || continue
  copy_file "$f" "$OC_DIR/commands/$(basename "$f")" "commands/$(basename "$f")" prompt
done

echo ""
echo "=== Plugins (.opencode) ==="
for f in core/.opencode/plugin/*.ts; do
  [ -f "$f" ] || continue
  copy_file "$f" "$OC_DIR/plugin/$(basename "$f")" "plugin/$(basename "$f")" prompt
done
for f in core/.opencode/command/*.md; do
  [ -f "$f" ] || continue
  copy_file "$f" "$OC_DIR/command/$(basename "$f")" "command/$(basename "$f")" prompt
done
if [ -f core/.opencode/package.json ]; then
  merge_json_file core/.opencode/package.json "$OC_DIR/package.json" "package.json"
fi

echo ""
echo "=== Config (opencode.json) ==="
if [ -f core/opencode.json ]; then
  merge_json_file core/opencode.json "$OC_DIR/opencode.json" "opencode.json"
fi

echo ""
echo "=== Global Memory Templates ==="
ensure_dir "$OC_DIR/global-memory/work-diary/archive"
for f in templates/global-memory/*.md; do
  [ -f "$f" ] || continue
  copy_file "$f" "$OC_DIR/global-memory/$(basename "$f")" "global-memory/$(basename "$f")" keep
done
if [ -f templates/global-memory/work-diary/diary-YYYY-MM.md ]; then
  copy_file templates/global-memory/work-diary/diary-YYYY-MM.md \
    "$OC_DIR/global-memory/work-diary/diary-YYYY-MM.md" "work-diary/diary-YYYY-MM.md" keep
fi

echo ""
echo "=== Validation Script ==="
copy_file scripts/validate.sh "$OC_DIR/scripts/validate.sh" "validate.sh" prompt

count() { find "$1" -maxdepth "$2" -name "$3" 2>/dev/null | wc -l; }
echo ""
echo "=== Summary ==="
echo "Files in $OC_DIR/:"
echo "  Agents:   $(count "$OC_DIR/agents" 1 '*.md') files"
echo "  Skills:   $(count "$OC_DIR/skills" 2 'SKILL.md') skills"
echo "  Commands: $(count "$OC_DIR/commands" 1 '*.md') files"
echo "  Plugins:  $(count "$OC_DIR/plugin" 1 '*.ts') files"
echo ""
if [ "$DRY_RUN" = true ]; then
  echo "DRY-RUN complete. Run without --dry-run to apply."
else
  echo "Update complete! Restart OpenCode to load changes."
fi
