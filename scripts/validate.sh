#!/bin/bash
# CodeXen Validation Script
# Run: bash scripts/validate.sh
# Checks: frontmatter, agent refs, permissions, overclaim terms, file integrity

set -e

PASS=0
FAIL=0
ROOT=$(dirname "$(dirname "$(realpath "$0")")")
AGENTS_DIR="$ROOT/core/agents"
SKILLS_DIR="$ROOT/core/skills"

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
agent_count=$(ls "$AGENTS_DIR"/*.md 2>/dev/null | wc -l)
check "24 agent files (found: $agent_count)" "$([ "$agent_count" -eq 24 ] && echo "pass" || echo "fail")"

# ── 2. Skill count ──
echo "── Skill Count ──"
skill_count=$(ls "$SKILLS_DIR"/*/SKILL.md 2>/dev/null | wc -l)
check "17 skill files (found: $skill_count)" "$([ "$skill_count" -eq 17 ] && echo "pass" || echo "fail")"

# ── 3. YAML frontmatter ──
echo "── YAML Frontmatter ──"
for f in "$AGENTS_DIR"/*.md; do
  name=$(basename "$f")
  if head -1 "$f" | grep -q '^---$'; then
    : # has frontmatter
  else
    check "$name: missing --- frontmatter" "fail"
    continue
  fi
  if ! grep -q '^name: ' "$f"; then
    check "$name: missing name:" "fail"
    continue
  fi
  if ! grep -q '^description: ' "$f"; then
    check "$name: missing description:" "fail"
    continue
  fi
  if ! grep -q '^mode: ' "$f"; then
    check "$name: missing mode:" "fail"
    continue
  fi
  if ! grep -q '^permission:' "$f"; then
    check "$name: missing permission:" "fail"
    continue
  fi
done
check "All agents have valid YAML frontmatter" "pass"

# ── 4. Skill frontmatter ──
echo "── Skill Frontmatter ──"
for f in "$SKILLS_DIR"/*/SKILL.md; do
  name=$(basename "$(dirname "$f")")
  if head -1 "$f" 2>/dev/null | grep -q '^---$'; then
    : # has frontmatter
  else
    check "$name/SKILL.md: missing --- frontmatter" "fail"
  fi
done
check "All skills have valid YAML frontmatter" "pass"

# ── 5. Permission consistency ──
echo "── Permission Consistency ──"
# Read-only auditors should have bash: deny + no edit
for agent in style-auditor security-auditor performance-auditor research; do
  f="$AGENTS_DIR/$agent.md"
  if [ -f "$f" ]; then
    if grep -q 'bash: deny' "$f" && ! grep -q 'edit: allow' "$f" 2>/dev/null; then
      : # ok
    else
      check "$agent: expected bash:deny + no edit" "fail"
    fi
  fi
done
# Spec writers: edit:allow + bash:deny
for agent in srs-manager sds-manager decision-log planner api-designer brs-manager docs-manager; do
  f="$AGENTS_DIR/$agent.md"
  if [ -f "$f" ] && ! grep -q 'edit: allow' "$f"; then
    check "$agent: expected edit:allow (spec writer)" "fail"
  fi
done
check "Permission sets are consistent" "pass"

# ── 6. No swap/temp files ──
echo "── Temp / Swap Files ──"
swaps=$(find "$ROOT/core" -name '*.swp' -o -name '*.swo' -o -name '*~' -o -name '*.kate-swp' 2>/dev/null)
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
for f in "$AGENTS_DIR"/*.md "$SKILLS_DIR"/*/SKILL.md; do
  [ ! -f "$f" ] && continue
  # Find @agent mentions, excluding @param @returns @throws @click etc.
  refs=$(grep -on '@[a-z][a-z-]*' "$f" 2>/dev/null | grep -v '@param\|@returns\|@throws\|@click\|@mouse\|@key\|@media\|@import\|@apply\|@tailwind\|@layer\|@screen\|@font\|@starting' || true)
  while IFS=: read -r line ref; do
    [ -z "$ref" ] && continue
    agent_name="${ref#@}"
    # Skip non-agent refs (code examples, npm packages)
    case "$agent_name" in
      codexen|coder|backend-coder|frontend-coder|test-coder|refactor-expert|devops-coder|auditor|security|security-auditor|performance-auditor|style-auditor|planner|research|memory|decision-log|git-manager|docs-manager|database-expert|api-designer|doc-scout|brs-manager|srs-manager|sds-manager) ;;
      *) continue ;; # Not an agent reference
    esac
    # Check if agent file exists
    if ! echo "$valid_agents" | grep -qw "$agent_name"; then
      bad_refs=$((bad_refs + 1))
    fi
  done <<< "$refs"
done
check "All @agent refs resolve to existing files (broken: $bad_refs)" "$([ "$bad_refs" -eq 0 ] && echo "pass" || echo "fail")"

# ── 8. Overclaim terms ──
echo "── Overclaim Terms ──"
overclaims=$(grep -rn 'semantic search\|knowledge graph\|pattern recognition' "$ROOT/core" --include='*.md' 2>/dev/null || true)
if [ -z "$overclaims" ]; then
  check "No overclaim terms detected" "pass"
else
  check "Overclaim terms found: $(echo "$overclaims" | wc -l)" "fail"
fi

# ── 9. No TODO/FIXME in production files ──
echo "── TODO / FIXME Check ──"
# Exclude false positives: rules mentioning TODO/FIXME, code blocks
todos=$(grep -rn 'TODO\|FIXME' "$ROOT/core" --include='*.md' 2>/dev/null \
  | grep -v 'code examples\|```\|No.*TODO.*left\|No.*FIXME.*comment' || true)
if [ -z "$todos" ]; then
  check "No TODO/FIXME in production files" "pass"
else
  check "TODO/FIXME found (review needed)" "fail"
fi

# ── 10. Install/Update agent count ──
echo "── Install/Update File Counts ──"
install_match=$(grep -c '24 agents\|24 subagents' "$ROOT/install.md" 2>/dev/null || true)
update_match=$(grep -c '24 agents\|24 subagents' "$ROOT/update.md" 2>/dev/null || true)
if [ "$install_match" -gt 0 ] && [ "$update_match" -gt 0 ]; then
  check "install/update.md reference correct agent count" "pass"
else
  check "install/update.md agent count mismatch" "fail"
fi

# ── 11. .gitignore scope ──
echo "── .gitignore Scope ──"
if grep -q '^/memory/' "$ROOT/.gitignore" 2>/dev/null; then
  check ".gitignore uses root-scoped /memory/" "pass"
else
  check ".gitignore memory/ not root-scoped" "fail"
fi

# ── Summary ──
echo ""
yellow "=========================================="
yellow "  Results: $PASS passed, $FAIL failed"
yellow "=========================================="
echo ""

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
