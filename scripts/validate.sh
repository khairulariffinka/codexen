#!/bin/bash
set -uo pipefail

# CodeXen Validation Script
# Run: bash scripts/validate.sh
# Checks: frontmatter, agent refs, permissions, overclaim terms, file integrity

PASS=0
FAIL=0

# Usage: bash validate.sh [--installed]
#   Default: validate codexen repo files (script's location)
#   --installed: validate ~/.config/opencode/ installed files

if [ "${1:-}" = "--installed" ]; then
  ROOT="$HOME/.config/opencode"
  AGENTS_DIR="$ROOT/agents"
  SKILLS_DIR="$ROOT/skills"
  echo "🔍 Validating installed config: $ROOT"
elif [ "${1:-}" = "--help" ]; then
  echo "Usage: bash validate.sh [--installed]"
  echo "  (no flag)  Validate codexen repo files"
  echo "  --installed Validate ~/.config/opencode/ installed files"
  echo "  --help     Show this help"
  exit 0
else
  ROOT=$(dirname "$(dirname "$(realpath "$0")")")
  AGENTS_DIR="$ROOT/core/agents"
  SKILLS_DIR="$ROOT/core/skills"
  echo "🔍 Validating repo: $ROOT"
fi

red()   { printf "\e[31m%s\e[0m\n" "$1"; }
green() { printf "\e[32m%s\e[0m\n" "$1"; }
yellow(){ printf "\e[33m%s\e[0m\n" "$1"; }

check() {
  local desc="$1"
  local result="$2"
  if [ "$result" = "pass" ]; then
    green "  ✅ $desc"
    PASS=$((PASS + 1))
  else
    red "  ❌ $desc"
    FAIL=$((FAIL + 1))
  fi
}

echo ""
yellow "=========================================="
yellow "  CodeXen Validation"
yellow "=========================================="
echo ""

# ── 1. Agent count ──
echo "── Agent Count ──"
# Expected counts come from VERSION.yaml (repo) — no hardcoded numbers to forget.
# Installed mode: users may add their own agents/skills, so only check ours exist.
yaml_count() { awk -v k="$1:" '$0==k{f=1;next} f&&/^  - /{n++;next} f{f=0} END{print n+0}' "$ROOT/VERSION.yaml"; }
agent_count=$(ls "$AGENTS_DIR"/*.md 2>/dev/null | wc -l)
if [ "${1:-}" = "--installed" ]; then
  check "codexen agent installed (agents found: $agent_count)" "$([ -f "$AGENTS_DIR/codexen.md" ] && echo "pass" || echo "fail")"
else
  want_agents=$(yaml_count core_agents)
  check "$want_agents agent files per VERSION.yaml (found: $agent_count)" "$([ "$agent_count" -eq "$want_agents" ] && [ "$want_agents" -gt 0 ] && echo "pass" || echo "fail")"
fi

# ── 2. Skill count ──
echo "── Skill Count ──"
skill_count=$(ls "$SKILLS_DIR"/*/SKILL.md 2>/dev/null | wc -l)
if [ "${1:-}" = "--installed" ]; then
  check "orchestration skill installed (skills found: $skill_count)" "$([ -f "$SKILLS_DIR/orchestration/SKILL.md" ] && echo "pass" || echo "fail")"
else
  want_skills=$(( $(yaml_count core_skills) + $(yaml_count template_skills) ))
  check "$want_skills skill files per VERSION.yaml (found: $skill_count)" "$([ "$skill_count" -eq "$want_skills" ] && [ "$want_skills" -gt 0 ] && echo "pass" || echo "fail")"
fi

# ── 3. YAML frontmatter ──
echo "── YAML Frontmatter ──"
agent_fm_fail=0
for f in "$AGENTS_DIR"/*.md; do
  name=$(basename "$f")
  if head -1 "$f" | grep -q '^---$'; then
    : # has frontmatter opening
  else
    check "$name: missing --- frontmatter" "fail"
    agent_fm_fail=$((agent_fm_fail + 1))
    continue
  fi
  if ! grep -q '^description: ' "$f"; then
    check "$name: missing description:" "fail"
    agent_fm_fail=$((agent_fm_fail + 1))
    continue
  fi
  if ! grep -q '^mode: ' "$f"; then
    check "$name: missing mode:" "fail"
    agent_fm_fail=$((agent_fm_fail + 1))
    continue
  fi
  if ! grep -q '^permission:' "$f" && ! grep -q '^permission' "$f"; then
    check "$name: missing permission:" "fail"
    agent_fm_fail=$((agent_fm_fail + 1))
    continue
  fi
done
if [ "$agent_fm_fail" -eq 0 ]; then
  check "All agents have valid YAML frontmatter" "pass"
else
  check "Some agents have invalid frontmatter ($agent_fm_fail failures)" "fail"
fi

# ── 4. Skill frontmatter ──
echo "── Skill Frontmatter ──"
skill_fm_pass=0
skill_fm_fail=0
for f in "$SKILLS_DIR"/*/SKILL.md; do
  name=$(basename "$(dirname "$f")")
  if head -1 "$f" 2>/dev/null | grep -q '^---$'; then
    : # has frontmatter opening
  else
    check "$name/SKILL.md: missing opening ---" "fail"
    skill_fm_fail=$((skill_fm_fail + 1))
    continue
  fi
  # Check that name field matches directory name and follows OpenCode naming convention
  skname=$(grep '^name:' "$f" 2>/dev/null | head -1 | sed 's/^name:[[:space:]]*//')
  if [ -z "$skname" ]; then
    check "$name/SKILL.md: missing name field" "fail"
    skill_fm_fail=$((skill_fm_fail + 1))
    continue
  fi
  if [ "$skname" != "$name" ]; then
    check "$name/SKILL.md: name='$skname' does not match directory '$name'" "fail"
    skill_fm_fail=$((skill_fm_fail + 1))
    continue
  fi
  if ! echo "$skname" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$'; then
    check "$name/SKILL.md: name '$skname' does not match OpenCode naming convention" "fail"
    skill_fm_fail=$((skill_fm_fail + 1))
    continue
  fi
  # Check description field exists and is under 1024 chars
  skdesc=$(grep '^description:' "$f" 2>/dev/null | head -1 | sed 's/^description:[[:space:]]*//')
  if [ -z "$skdesc" ]; then
    check "$name/SKILL.md: missing description field" "fail"
    skill_fm_fail=$((skill_fm_fail + 1))
    continue
  fi
  skdesc_len=${#skdesc}
  if [ "$skdesc_len" -gt 1024 ]; then
    check "$name/SKILL.md: description too long ($skdesc_len chars, max 1024)" "fail"
    skill_fm_fail=$((skill_fm_fail + 1))
    continue
  fi
  # Check closing --- exists (second occurrence of ---)
  closing_line=$(awk '/^---$/{n++; if(n==2) print NR}' "$f" 2>/dev/null)
  if [ -z "$closing_line" ]; then
    check "$name/SKILL.md: missing closing --- for frontmatter" "fail"
    skill_fm_fail=$((skill_fm_fail + 1))
    continue
  fi
  skill_fm_pass=$((skill_fm_pass + 1))
done
if [ "$skill_fm_fail" -eq 0 ]; then
  check "All skills have valid YAML frontmatter (name, description, format)" "pass"
else
  check "Some skills have invalid frontmatter" "fail"
fi

# ── 5. Permission consistency ──
echo "── Permission Consistency ──"
perm_fail=0
# Read-only auditors should have bash: deny + no edit
for agent in auditor style-auditor security-auditor performance-auditor research doc-scout; do
  f="$AGENTS_DIR/$agent.md"
  if [ -f "$f" ]; then
    if grep -q 'bash: deny' "$f" && ! grep -q 'edit: allow' "$f" 2>/dev/null; then
      : # ok
    else
      check "$agent: expected bash:deny + no edit" "fail"
      perm_fail=$((perm_fail + 1))
    fi
  fi
done
# Spec writers: edit:allow + bash:deny
for agent in srs-manager sds-manager decision-log planner api-designer brs-manager docs-manager; do
  f="$AGENTS_DIR/$agent.md"
  if [ -f "$f" ] && ! grep -q 'edit: allow' "$f"; then
    check "$agent: expected edit:allow (spec writer)" "fail"
    perm_fail=$((perm_fail + 1))
  fi
done
if [ "$perm_fail" -eq 0 ]; then
  check "Permission sets are consistent" "pass"
else
  check "Permission inconsistencies found ($perm_fail failures)" "fail"
fi

# ── 6. No swap/temp files ──
echo "── Temp / Swap Files ──"
swap_dir="$ROOT"
[ "${1:-}" = "--installed" ] && swap_dir="$ROOT/agents"  # no core/ dir in installed
swaps=$(find "$swap_dir" -name '*.swp' -o -name '*.swo' -o -name '*~' -o -name '*.kate-swp' 2>/dev/null || true)
if [ -n "$swaps" ]; then
  check "Swap files found: $(echo "$swaps" | tr '\n' ' ')" "fail"
else
  check "No swap/temp files" "pass"
fi

# ── 7. Agent references ──
echo "── Agent @references ──"
# Build list of valid agent names
valid_agents=""
for f in "$AGENTS_DIR"/*.md; do
  agent_name=$(basename "$f" .md)
  valid_agents="$valid_agents $agent_name"
done

bad_refs=0
shopt -s nullglob
if [ "${1:-}" = "--installed" ]; then
  ref_files=("$AGENTS_DIR"/*.md)
else
  ref_files=("$AGENTS_DIR"/*.md "$SKILLS_DIR"/*/SKILL.md)
fi
for f in "${ref_files[@]}"; do
  [ ! -f "$f" ] && continue
  refs=$(grep -on '@[a-z][a-z-]*' "$f" 2>/dev/null | grep -v '@param\|@returns\|@throws\|@click\|@mouse\|@key\|@media\|@import\|@apply\|@tailwind\|@layer\|@screen\|@font\|@starting' || true)
  while IFS=: read -r line ref; do
    [ -z "$ref" ] && continue
    agent_name="${ref#@}"
    case "$agent_name" in
      codexen|coder|backend-coder|frontend-coder|test-coder|refactor-expert|devops-coder|auditor|security|security-auditor|performance-auditor|style-auditor|planner|research|memory|decision-log|git-manager|docs-manager|database-expert|api-designer|doc-scout|brs-manager|srs-manager|sds-manager|checkpoint-writer) ;;
      *) continue ;;
    esac
    if ! echo "$valid_agents" | grep -qw "$agent_name"; then
      bad_refs=$((bad_refs + 1))
    fi
  done <<< "$refs"
done
check "All @agent refs resolve to existing files (broken: $bad_refs)" "$([ "$bad_refs" -eq 0 ] && echo "pass" || echo "fail")"

# ── 8. Overclaim terms ──
echo "── Overclaim Terms ──"
if [ "${1:-}" = "--installed" ]; then
  overclaims=$(grep -rn 'semantic search\|knowledge graph\|pattern recognition' "$ROOT/agents" "$ROOT/skills" --include='*.md' 2>/dev/null || true)
else
  overclaims=$(grep -rn 'semantic search\|knowledge graph\|pattern recognition' "$ROOT/core" --include='*.md' 2>/dev/null || true)
fi
if [ -z "$overclaims" ]; then
  check "No overclaim terms detected" "pass"
else
  check "Overclaim terms found: $(echo "$overclaims" | wc -l)" "fail"
fi

# ── 9. No TODO/FIXME in production files ──
echo "── TODO / FIXME Check ──"
if [ "${1:-}" = "--installed" ]; then
  todos=$(grep -rn 'TODO\|FIXME' "$ROOT/agents" "$ROOT/skills" --include='*.md' 2>/dev/null | grep -v 'code examples\|```\|No.*TODO.*left\|No.*FIXME.*comment\|TODO/FIXME\|TODO.*left\|FIXME.*comment\|cleanup TODOs' || true)
else
  todos=$(grep -rn 'TODO\|FIXME' "$ROOT/core" --include='*.md' 2>/dev/null | grep -v 'code examples\|```\|No.*TODO.*left\|No.*FIXME.*comment\|TODO/FIXME\|TODO.*left\|FIXME.*comment\|cleanup TODOs' || true)
fi
if [ -z "$todos" ]; then
  check "No TODO/FIXME in production files" "pass"
else
  check "TODO/FIXME found (review needed)" "fail"
fi

# ── 10. Install/Update agent count (repo only) ──
if [ "${1:-}" != "--installed" ]; then
  echo "── Install/Update File Counts ──"
  install_match=$(grep -c "$agent_count agents" "$ROOT/install.md" 2>/dev/null || true)
  update_match=$(grep -c "$agent_count agents" "$ROOT/update.md" 2>/dev/null || true)
  if [ "$install_match" -gt 0 ] && [ "$update_match" -gt 0 ]; then
    check "install/update.md reference correct agent count" "pass"
  else
    check "install/update.md agent count mismatch" "fail"
  fi
fi

# ── 11. Parallel group consistency (repo only) ──
if [ "${1:-}" != "--installed" ]; then
  echo "── Parallel Group Consistency ──"
  parallel_planner=$(grep -c 'Parallel Group\|Parallel.*Group' "$ROOT/core/skills/planner/SKILL.md" 2>/dev/null || true)
  parallel_codexen=$(grep -c 'Parallel Group\|Parallel.*Group\|Parallel Execution' "$ROOT/core/agents/codexen.md" 2>/dev/null || true)
  if [ "$parallel_planner" -ge 3 ] && [ "$parallel_codexen" -ge 1 ]; then
    check "Parallel execution defined consistently across files" "pass"
  else
    check "Parallel execution references inconsistent" "fail"
  fi
fi

# ── 12. .gitignore scope (repo only) ──
if [ "${1:-}" != "--installed" ]; then
  echo "── .gitignore Scope ──"
  if grep -q '^/memory/' "$ROOT/.gitignore" 2>/dev/null; then
    check ".gitignore uses root-scoped /memory/" "pass"
  else
    check ".gitignore memory/ not root-scoped" "fail"
  fi
fi

# ── 13. Agent .md permissions match opencode.json (repo only) ──
# OpenCode merges both; if they disagree, which one wins is not obvious to users.
if [ "${1:-}" != "--installed" ]; then
  echo "── Agent Permissions: .md vs opencode.json ──"
  if command -v node >/dev/null 2>&1; then
    perm_diff=$(node - "$ROOT" <<'NODE'
const fs = require("fs"), path = require("path")
const root = process.argv[2]
const cfg = JSON.parse(fs.readFileSync(path.join(root, "core/opencode.json"), "utf8"))
const norm = (v) => (v && typeof v === "object" && Object.keys(v).length === 1 && "*" in v) ? v["*"] : v
const flat = (v) => typeof norm(v) === "string" ? norm(v) : JSON.stringify(norm(v))
function frontmatter(file) {
  const m = fs.readFileSync(file, "utf8").match(/^---\n([\s\S]*?)\n---/)
  const out = {}; if (!m) return out
  let inPerm = false, sub = null
  for (const line of m[1].split("\n")) {
    if (/^permission:\s*$/.test(line)) { inPerm = true; continue }
    if (inPerm && /^\S/.test(line)) inPerm = false
    if (!inPerm) continue
    let mm
    if ((mm = line.match(/^  ([\w-]+):\s*(\S.*)$/))) { out[mm[1]] = mm[2].replace(/^["']|["']$/g, ""); sub = null }
    else if ((mm = line.match(/^  ([\w-]+):\s*$/))) { sub = mm[1]; out[sub] = {} }
    else if (sub && (mm = line.match(/^    ["']?(.+?)["']?:\s*(\S+)$/))) out[sub][mm[1]] = mm[2]
  }
  return out
}
const issues = []
for (const f of fs.readdirSync(path.join(root, "core/agents")).filter((f) => f.endsWith(".md"))) {
  const name = f.slice(0, -3)
  if (!cfg.agent || !cfg.agent[name]) { issues.push(`${name}: not registered in opencode.json`); continue }
  const md = frontmatter(path.join(root, "core/agents", f)), js = cfg.agent[name].permission || {}
  for (const k of Object.keys(md)) if (k in js && flat(md[k]) !== flat(js[k])) issues.push(`${name}.${k}: md=${flat(md[k])} json=${flat(js[k])}`)
}
console.log(issues.join("\n"))
NODE
)
    if [ -z "$perm_diff" ]; then
      check "Agent .md permissions match opencode.json" "pass"
    else
      check "Agent .md vs opencode.json permission mismatch: $(echo "$perm_diff" | tr '\n' ';')" "fail"
    fi
  else
    yellow "  ⚠️  node not found — skipped .md vs opencode.json permission check"
  fi
fi

# ── 14. Subagents never call other agents directly ──
# OpenCode subagents cannot start subagents (subagent_depth = 1), so they must
# request other agents through a "## Handoff" block that codexen dispatches.
echo "── Subagent Handoff (no direct agent calls) ──"
agent_alt=$(for f in "$AGENTS_DIR"/*.md; do basename "$f" .md; done | paste -sd'|' -)
direct_calls=""
for f in "$AGENTS_DIR"/*.md; do
  self=$(basename "$f" .md)
  [ "$self" = codexen ] && continue
  hits=$(grep -inE "\b(call|invoke|run|consult|delegate|notify|trigger|dispatch|redirect to|route to)\b[^@]{0,12}\`?@($agent_alt)\b" "$f" 2>/dev/null \
    | grep -viE "## Handoff|in your Handoff|hand off|hand it off|cannot" \
    | grep -vE "@$self\b" || true)
  [ -n "$hits" ] && direct_calls="$direct_calls $self:$(echo "$hits" | cut -d: -f1 | paste -sd, -)"
done
if [ -z "$direct_calls" ]; then
  check "Subagents use ## Handoff instead of calling agents" "pass"
else
  check "Subagents call other agents directly (use ## Handoff):$direct_calls" "fail"
fi

# ── 15. Docs match reality: counts, VERSION.yaml lists, version strings (repo only) ──
# Counts come from the files on disk; changelog / "New in vX" sections are history and skipped.
if [ "${1:-}" != "--installed" ]; then
  echo "── Docs Consistency (counts + version) ──"
  if command -v node >/dev/null 2>&1; then
    docs_diff=$(node - "$ROOT" <<'NODE'
const fs = require("fs"), path = require("path")
const root = process.argv[2]
const rd = (p) => { try { return fs.readFileSync(path.join(root, p), "utf8") } catch { return null } }
const ls = (d, test) => fs.readdirSync(path.join(root, d)).filter(test)
const agents = ls("core/agents", (f) => f.endsWith(".md")).map((f) => f.slice(0, -3)).sort()
const skills = ls("core/skills", (d) => fs.existsSync(path.join(root, "core/skills", d, "SKILL.md"))).sort()
const commands = ls("core/commands", (f) => f.endsWith(".md")).map((f) => f.slice(0, -3)).sort()
const N = { agents: agents.length, subagents: agents.length - 1, skills: skills.length, commands: commands.length }
const issues = []

// VERSION.yaml lists = files on disk
const vy = rd("VERSION.yaml")
const list = (key) => { const m = vy.match(new RegExp(`^${key}:\\n((?:  - .*\\n?)+)`, "m")); return m ? m[1].trim().split("\n").map((l) => l.replace(/^\s*-\s*/, "").trim()).sort() : [] }
const same = (a, b) => JSON.stringify(a) === JSON.stringify(b)
if (!same(list("core_agents"), agents)) issues.push(`VERSION.yaml core_agents != core/agents (${list("core_agents").length} vs ${agents.length})`)
if (!same([...list("core_skills"), ...list("template_skills")].sort(), skills)) issues.push(`VERSION.yaml core_skills+template_skills != core/skills`)
if (!same(list("core_commands"), commands)) issues.push(`VERSION.yaml core_commands != core/commands (${list("core_commands").join(",")} vs ${commands.join(",")})`)

// Version strings
const V = (vy.match(/^version:\s*(\S+)/m) || [])[1]
const want = [
  ["README.md", new RegExp(`version-${V.replace(/\./g, "\\.")}-`), "badge"],
  ["install.sh", new RegExp(`CodeXen v${V.replace(/\./g, "\\.")}\\b`), "header"],
  ["update_script.sh", new RegExp(`CodeXen v${V.replace(/\./g, "\\.")}\\b`), "header"],
  ["CHANGELOG.md", new RegExp(`^## \\[${V.replace(/\./g, "\\.")}\\]`, "m"), "top entry"],
]
for (const [f, re, what] of want) if (!re.test(rd(f) || "")) issues.push(`${f}: ${what} does not say ${V}`)
for (const f of ["README.md", "install.md", "update.md"]) {
  const t = rd(f) || ""
  for (const m of t.matchAll(/CodeXen v(\d+\.\d+\.\d+)|### v(\d+\.\d+\.\d+) \(Current\)/g)) { const got = m[1] || m[2]; if (got !== V) issues.push(`${f}: says ${m[0]} but VERSION.yaml is ${V}`) }
}

// Count claims in current-state docs (history sections skipped)
const files = ["README.md", "QUICKSTART.md", "install.md", "update.md", "uninstall.md", "setup-guide.md", "COMMANDS.md", "TUTORIALS.md", "docs/ARCHITECTURE.md", "core/opencode.json", "VERSION.yaml", "core/agents/memory.md", "core/agents/codexen.md"]
const strip = (t) => {
  const out = []; let skip = 0
  for (const line of t.split("\n")) {
    const h = line.match(/^(#{1,6})\s/)
    if (h && skip && h[1].length <= skip) skip = 0
    if (h && /changelog|new in v|\bv\d+\.\d+|^#+\s*\[\d/i.test(line)) { skip = h[1].length; continue }
    if (!skip) out.push(line)
  }
  return out.join("\n")
}
const claims = [
  [/agents-(\d+)-/g, "agents"], [/skills-(\d+)-/g, "skills"], [/commands-(\d+)-/g, "commands"],
  [/\b(\d+)\s+subagents?\b(?!\s+(?:dispatch|call|run|per))/gi, "subagents"], [/\b(\d+)\s+(?:AI\s+)?agents?\b(?!-)/gi, "agents"],
  [/\b(\d+)\s+agent definitions\b/gi, "agents"], [/\b(\d+)\s+skills?\b(?!-)/gi, "skills"],
  [/\b(\d+)\s+(?:slash\s+|custom\s+)?commands?\b(?!-)/gi, "commands"],
]
for (const f of files) {
  const t = rd(f); if (t == null) continue
  const body = strip(t).split("\n")
  body.forEach((line, i) => {
    for (const [re, kind] of claims) for (const m of line.matchAll(re)) {
      const n = Number(m[1]); if (n < 5) continue // "3 agents in parallel" etc. are limits, not totals
      if (n !== N[kind]) issues.push(`${f}: "${m[0].trim()}" (actual ${kind}: ${N[kind]})`)
    }
  })
}
console.log([...new Set(issues)].join("\n"))
NODE
)
    if [ -z "$docs_diff" ]; then
      check "Docs counts/versions match files on disk + VERSION.yaml" "pass"
    else
      check "Docs out of date: $(echo "$docs_diff" | head -12 | tr '\n' ';')" "fail"
      echo "$docs_diff" | sed 's/^/      - /'
    fi
  else
    yellow "  ⚠️  node not found — skipped docs consistency check"
  fi
fi

# ── Summary ──
echo ""
yellow "=========================================="
TOTAL=$((PASS + FAIL))
yellow "  Results: $PASS passed, $FAIL failed (${TOTAL} checks)"
yellow "=========================================="
echo ""

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
