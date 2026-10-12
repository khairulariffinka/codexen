#!/bin/bash
# Sandbox tests for install.sh, update_script.sh and scripts/common.sh
# Run: bash tests/test-install.sh   (never touches your real ~/.config)
set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
PASS=0
FAIL=0

ok() {
  if [ "$1" = 0 ]; then echo "  PASS $2"; PASS=$((PASS + 1)); else echo "  FAIL $2"; FAIL=$((FAIL + 1)); fi
}
t() { "$@" >/dev/null 2>&1; echo $?; }
newhome() { local h="$WORK/$1"; mkdir -p "$h"; echo "$h"; }
oc() { echo "$1/.config/opencode"; }
cnt() { find "$1" -maxdepth "$2" -name "$3" 2>/dev/null | wc -l | tr -d ' '; }
jget() { node -e 'const o=JSON.parse(require("fs").readFileSync(process.argv[1]));console.log(process.argv[2].split(".").reduce((a,k)=>a&&a[k],o))' "$1" "$2"; }

N_AGENTS=$(cnt "$REPO/core/agents" 1 '*.md')
N_SKILLS=$(ls "$REPO"/core/skills/*/SKILL.md | wc -l | tr -d ' ')
N_CMDS=$(cnt "$REPO/core/commands" 1 '*.md')

echo "== Syntax =="
ok "$(t bash -n "$REPO/install.sh")" "install.sh syntax"
ok "$(t bash -n "$REPO/update_script.sh")" "update_script.sh syntax"
ok "$(t bash -n "$REPO/scripts/common.sh")" "common.sh syntax"

echo "== Fresh install (no stdin) =="
H=$(newhome fresh)
HOME=$H bash "$REPO/install.sh" </dev/null >"$WORK/fresh.log" 2>&1
ok $? "exit 0"
ok "$([ "$(cnt "$(oc "$H")/agents" 1 '*.md')" = "$N_AGENTS" ] && echo 0 || echo 1)" "all $N_AGENTS agents"
ok "$([ "$(cnt "$(oc "$H")/skills" 2 SKILL.md)" = "$N_SKILLS" ] && echo 0 || echo 1)" "all $N_SKILLS skills"
ok "$([ "$(cnt "$(oc "$H")/commands" 1 '*.md')" = "$N_CMDS" ] && echo 0 || echo 1)" "all $N_CMDS commands"
ok "$([ -f "$(oc "$H")/plugins/context-monitor.ts" ] && echo 0 || echo 1)" "plugin installed"
ok "$([ -f "$(oc "$H")/commands/context.md" ] && echo 0 || echo 1)" "/context command installed"
ok "$([ -f "$(oc "$H")/scripts/validate.sh" ] && echo 0 || echo 1)" "validate.sh installed"
ok "$(ls -d "$H"/.config/opencode.backup-* >/dev/null 2>&1 && echo 1 || echo 0)" "no backup of empty/missing config"

echo "== Re-run is idempotent =="
HOME=$H bash "$REPO/install.sh" </dev/null >"$WORK/rerun.log" 2>&1
ok $? "exit 0"
ok "$(grep -qE '^(Added|Updated|Merged)' "$WORK/rerun.log" && echo 1 || echo 0)" "nothing changed"
HOME=$H bash "$REPO/install.sh" </dev/null >/dev/null 2>&1
ok "$([ "$(ls -d "$H"/.config/opencode.backup-* | wc -l)" -eq 2 ] && echo 0 || echo 1)" "same-minute backups are separate folders"
ok "$(ls -d "$H"/.config/opencode.backup-*/opencode >/dev/null 2>&1 && echo 1 || echo 0)" "no nested backup folder"

echo "== Dry-run writes nothing =="
H=$(newhome dry)
HOME=$H bash "$REPO/install.sh" --dry-run </dev/null >/dev/null 2>&1
ok $? "install --dry-run exit 0"
ok "$([ -z "$(find "$H" -mindepth 1 2>/dev/null)" ] && echo 0 || echo 1)" "install --dry-run created nothing"
HOME=$H bash "$REPO/update_script.sh" --dry-run </dev/null >/dev/null 2>&1
ok $? "update --dry-run exit 0"
ok "$([ -z "$(find "$H" -mindepth 1 2>/dev/null)" ] && echo 0 || echo 1)" "update --dry-run created nothing"

USER_JSON='{"model":"user/model","theme":"mine","agent":{"coder":{"model":"user/x"}}}'

echo "== opencode.json conflict: Enter = merge, user wins =="
H=$(newhome enter); mkdir -p "$(oc "$H")"; echo "$USER_JSON" >"$(oc "$H")/opencode.json"
printf '\n\n\n\n' | HOME=$H bash "$REPO/install.sh" >"$WORK/enter.log" 2>&1
ok $? "exit 0"
ok "$(grep -q '^Merged: opencode.json' "$WORK/enter.log" && echo 0 || echo 1)" "merged by default"
ok "$([ "$(jget "$(oc "$H")/opencode.json" model)" = user/model ] && echo 0 || echo 1)" "user model kept"
ok "$([ "$(jget "$(oc "$H")/opencode.json" agent.coder.model)" = user/x ] && echo 0 || echo 1)" "user nested value kept"
ok "$([ "$(jget "$(oc "$H")/opencode.json" agent.checkpoint-writer.mode)" != undefined ] && echo 0 || echo 1)" "new CodeXen agent added"
ok "$([ -f "$(oc "$H")/plugins/context-monitor.ts" ] && echo 0 || echo 1)" "install continued after prompt"

echo "== opencode.json conflict: no stdin = keep, script completes =="
H=$(newhome eof); mkdir -p "$(oc "$H")"; echo "$USER_JSON" >"$(oc "$H")/opencode.json"
HOME=$H bash "$REPO/install.sh" </dev/null >"$WORK/eof.log" 2>&1
ok $? "exit 0"
ok "$([ "$(cat "$(oc "$H")/opencode.json")" = "$USER_JSON" ] && echo 0 || echo 1)" "user file untouched"
ok "$([ -f "$(oc "$H")/scripts/validate.sh" ] && echo 0 || echo 1)" "reached the end"

echo "== Invalid JSON (JSONC) is never clobbered by merge =="
H=$(newhome jsonc); mkdir -p "$(oc "$H")"; printf '{\n  // comment\n  "theme": "mine"\n}\n' >"$(oc "$H")/opencode.json"
cp "$(oc "$H")/opencode.json" "$WORK/jsonc.orig"
printf '1\n' | HOME=$H bash "$REPO/install.sh" >"$WORK/jsonc.log" 2>&1
ok $? "exit 0"
ok "$(cmp -s "$WORK/jsonc.orig" "$(oc "$H")/opencode.json" && echo 0 || echo 1)" "JSONC kept as-is"
ok "$([ -z "$(find "$(oc "$H")" -maxdepth 1 -name 'opencode.json.*')" ] && echo 0 || echo 1)" "no temp files left"

echo "== json_merge backends (jq / node / python3) =="
cat >"$WORK/src.json" <<'EOF'
{"_comment":"drop me","a":1,"nested":{"x":1,"y":2},"arr":[1,2],"new":true}
EOF
for backend in jq node python3; do
  command -v "$backend" >/dev/null 2>&1 || { echo "  SKIP $backend (not installed)"; continue; }
  echo '{"a":9,"nested":{"x":9},"arr":[7]}' >"$WORK/dst-$backend.json"
  (
    DRY_RUN=false
    source "$REPO/scripts/common.sh"
    # Disable the backends tried before this one
    case "$backend" in
      node) jq() { return 1; } ;;
      python3) jq() { return 1; }; node() { return 1; } ;;
    esac
    json_merge "$WORK/src.json" "$WORK/dst-$backend.json"
  ) >/dev/null 2>&1
  r=$?
  got=$(node -e 'const o=JSON.parse(require("fs").readFileSync(process.argv[1]));console.log(JSON.stringify([o.a,o.nested.x,o.nested.y,o.arr,o.new,"_comment" in o]))' "$WORK/dst-$backend.json" 2>/dev/null)
  ok "$([ $r = 0 ] && [ "$got" = '[9,9,2,[7],true,false]' ] && echo 0 || echo 1)" "$backend: user wins, new keys added, _comment dropped ($got)"
done

echo "== Legacy singular dirs (plugin/, command/) cleaned up =="
legacy_home() {
  local h; h=$(newhome "$1"); mkdir -p "$(oc "$h")/plugin" "$(oc "$h")/command"
  printf 'export const X = 1 // check_context\n' >"$(oc "$h")/plugin/context-monitor.ts"
  printf 'Call the `check_context` tool\n' >"$(oc "$h")/command/context.md"
  echo "$h"
}
H=$(legacy_home legacy)
echo "my plugin" >"$(oc "$H")/plugin/mine.ts"
HOME=$H bash "$REPO/install.sh" </dev/null >"$WORK/legacy.log" 2>&1
ok $? "exit 0"
ok "$([ ! -e "$(oc "$H")/plugin/context-monitor.ts" ] && echo 0 || echo 1)" "old plugin/context-monitor.ts removed (no double load)"
ok "$([ ! -e "$(oc "$H")/command/context.md" ] && echo 0 || echo 1)" "old command/context.md removed"
ok "$([ ! -d "$(oc "$H")/command" ] && echo 0 || echo 1)" "empty legacy command/ dir removed"
ok "$([ "$(cat "$(oc "$H")/plugin/mine.ts" 2>/dev/null)" = "my plugin" ] && echo 0 || echo 1)" "user's other plugin in plugin/ kept"
ok "$([ -f "$(oc "$H")/plugins/context-monitor.ts" ] && echo 0 || echo 1)" "new plugins/context-monitor.ts installed"
ok "$(ls "$H"/.config/opencode.backup-*/plugin/context-monitor.ts >/dev/null 2>&1 && echo 0 || echo 1)" "legacy file preserved in backup"
H=$(newhome legacy-user); mkdir -p "$(oc "$H")/plugin"
echo "user wrote this" >"$(oc "$H")/plugin/context-monitor.ts"
HOME=$H bash "$REPO/install.sh" </dev/null >/dev/null 2>&1
ok "$([ "$(cat "$(oc "$H")/plugin/context-monitor.ts")" = "user wrote this" ] && echo 0 || echo 1)" "same-name user file without CodeXen marker kept"
H=$(legacy_home legacy-dry)
HOME=$H bash "$REPO/install.sh" --dry-run </dev/null >"$WORK/legacy-dry.log" 2>&1
ok "$([ -f "$(oc "$H")/plugin/context-monitor.ts" ] && grep -q 'Would remove legacy' "$WORK/legacy-dry.log" && echo 0 || echo 1)" "dry-run reports but keeps legacy file"
H=$(legacy_home legacy-upd)
printf '\n\n\n\n\n\n' | HOME=$H bash "$REPO/update_script.sh" >/dev/null 2>&1
ok "$([ ! -e "$(oc "$H")/plugin/context-monitor.ts" ] && [ -f "$(oc "$H")/plugins/context-monitor.ts" ] && echo 0 || echo 1)" "update_script.sh migrates plugin/ -> plugins/"

echo "== update: global-memory never overwritten, conflicts default keep =="
H=$(newhome upd)
HOME=$H bash "$REPO/install.sh" </dev/null >/dev/null 2>&1
gm=$(ls "$(oc "$H")/global-memory/"*.md | head -1)
echo "MY PRIVATE NOTES" >"$gm"
echo "custom agent" >"$(oc "$H")/agents/coder.md"
rm "$(oc "$H")/commands/audit.md"
printf '\n\n\n\n\n\n' | HOME=$H bash "$REPO/update_script.sh" >"$WORK/upd.log" 2>&1
ok $? "exit 0"
ok "$([ "$(cat "$gm")" = "MY PRIVATE NOTES" ] && echo 0 || echo 1)" "global-memory file kept"
ok "$([ "$(cat "$(oc "$H")/agents/coder.md")" = "custom agent" ] && echo 0 || echo 1)" "custom agent kept on Enter"
ok "$([ -f "$(oc "$H")/commands/audit.md" ] && echo 0 || echo 1)" "missing command re-added"
printf '2\n' | HOME=$H bash "$REPO/update_script.sh" >/dev/null 2>&1
ok "$(cmp -s "$REPO/core/agents/coder.md" "$(oc "$H")/agents/coder.md" && echo 0 || echo 1)" "choice 2 overwrites agent"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
