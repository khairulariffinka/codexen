# Install CodeXen

> **When user loads this file:** User wants to install/copy CodeXen files to their system.

```
"load install.md"
```

That's it!

---

## Options

| Option | Description |
|--------|-------------|
| (default) | Install with backup |
| `--dry-run` | Preview only, no changes |

---

## Changelog

### v0.7.0 (Current)
- ADD: 12 custom slash commands (`/audit`, `/test`, `/lint`, `/review`, `/plan`, `/brs`, `/srs`, `/sds`, `/commit`, `/refactor`, `/init-codexen`, `/docker`)
- ADD: Model optimization (`model` + `small_model` for cost savings)
- ADD: LSP integration (`lsp: true` for code intelligence)
- ADD: Auto-formatters (`formatter: true` for Prettier, Ruff, etc.)
- ADD: Auto-compaction (`compaction: auto + prune` to prevent context overflow)
- ADD: Instructions config (multi-file instruction loading)
- ADD: Fine-grained permissions per agent role (coders=edit, auditors=read-only, etc.)
- ADD: `copy_core_commands` in install config
- CHANGE: All 24 agents have explicit permission configs in opencode.json

### v0.6.0
- REFACTOR: All 17 SKILL.md files standardized with OpenCode-compatible frontmatter (license, compatibility, metadata)
- REFACTOR: Memory, init-project, greeting skills converted from bash scripts to instructional prompts
- REFACTOR: All 24 agent .md files standardized with consistent permission format
- REFACTOR: Removed `name:` field from agent frontmatter (OpenCode uses filename as agent name)
- ADD: All skills now have `license`, `compatibility`, and `metadata` frontmatter fields
- ADD: opencode.json now registers all 24 subagents with mode and hidden flags
- ADD: opencode.json now has `permission:task` for codexen primary agent
- ADD: validate.sh enhanced with SKILL.md name validation, description length check, closing frontmatter check
- ADD: validate.sh removed `name:` requirement for agents (OpenCode uses filename)
- FIX: codexen.md session auto-save replaced bash script with instructional steps
- FIX: diary-YYYY-MM.md template placeholder format
- FIX: Removed `trigger:` non-standard field from init-project SKILL.md

### v0.5.0
- ADD: First-time setup prompts for agent name
- ADD: User can choose custom name (default: codexen)
- ADD: Agent set as mode: primary automatically
- ADD: `--dry-run` option for preview
- ADD: Automatic backup before install
- ADD: Conflict resolution for agents/skills
- ADD: Merge option for opencode.json
- ADD: Subagent routing table mapping task types to all 24 agents
- ADD: Cross-agent handoffs (@test-coder, @auditor, @decision-log, @doc-scout) to coder agents
- ADD: Mandatory audit gate in git-manager.md before commit
- ADD: Search/query and supersession logic to decision-log
- ADD: FR/NFR templates, ERD/API contract templates to srs/sds skills
- ADD: Parallel grouping and estimation criteria to planner skill
- FIX: Expanded incomplete agents (research, refactor-expert, backend-coder, auditor, brs-manager)
- FIX: Overclaim terminology in memory agent (semantic search → keyword search, etc.)
- FIX: planner.md edit:deny → edit:allow (content producer consistency)
- FIX: Restricted unnecessary bash:allow → bash:deny (api-designer, brs-manager, docs-manager)
- FIX: .gitignore scope (/memory/, /docs/ instead of memory/, docs/)
- FIX: Memory skill paths, sed pattern, RAM population flow
- ADD: Self-healing orchestration (8 error recovery scenarios)
- ADD: Feedback loop with lessons learned system (lessons.md)
- ADD: CI/CD validation script (scripts/validate.sh, 12 checks)
- ADD: Formal changelog workflow for BRS/SRS/SDS spec chain
- ADD: Parallel execution validation (dependency, file conflict, circular dep)
- ADD: Token budgeting system with auto-triggers and sliding window
- ADD: Guardrails (ask before modify, circuit breaker, rate limit, scope)
- ADD: Git guardrails (secret scan, large file warning, message validation)
- ADD: `--installed` flag for validate.sh
- ADD: Open source files (CONTRIBUTING.md, SECURITY.md, CODE_OF_CONDUCT.md)
- ADD: GitHub issue/PR templates
- ADD: Agent generator script (scripts/generate-agent.sh)
- ADD: Production test suite (tests/test-self-healing.sh, 18 scenarios)
- ADD: GitHub Actions CI pipeline (.github/workflows/validate.yml)
- ADD: SemVer policy (VERSIONING.md)

### v0.4.4
- ADD: `--dry-run` option for preview
- ADD: Automatic backup before install
- ADD: Changelog display
- ADD: Conflict resolution for agents/skills
- ADD: Merge option for opencode.json

### v0.4.0
- Initial release

---

## Context

When this file is loaded, AI must know:
- User wants to install/copy files to ~/.config/opencode/
- NOT just reading the file
- AI must execute install steps
- IMPORTANT: Skip copying opencode.json if already exists and user has custom settings
- IMPORTANT: Skip copying global-memory if it already contains files

## AI Execution

When executing install, follow these steps:

### Step 1: Check for dry-run mode

If the user said `--dry-run`, only preview what will change without making any changes.

### Step 2: Create backup

If not dry-run, create a backup:
- Backup `~/.config/opencode/` to `~/.config/opencode.backup-YYYY-MM-DD-HHMM/`
- Only if `~/.config/opencode/` already exists

### Step 3: Create directories

Ensure these directories exist:
- `~/.config/opencode/agents/`
- `~/.config/opencode/skills/`
- `~/.config/opencode/commands/`
- `~/.config/opencode/global-memory/`
- `~/.config/opencode/global-memory/work-diary/`
- `~/.config/opencode/global-memory/work-diary/archive/`
- `~/.config/opencode/scripts/`

### Step 4: Install agents

Copy `core/agents/*.md` to `~/.config/opencode/agents/`.

For each agent file:
- If the file does not exist at destination: copy it (new install)
- If the file exists and differs: ask user whether to keep theirs, overwrite with CodeXen version, or show diff
- If the file exists and is identical: skip (unchanged)

Note: OpenCode uses the filename as the agent name. The `codexen.md` file becomes the `codexen` agent. No `sed` modifications are needed since the filename determines the agent name.

### Step 5: Install skills

Copy `core/skills/*/SKILL.md` to `~/.config/opencode/skills/*/SKILL.md` (preserving directory structure).

For each skill:
- Create the skill directory if it does not exist
- If the file does not exist at destination: copy it (new install)
- If the file exists and differs: ask user whether to keep theirs, overwrite, or show diff
- If the file exists and is identical: skip (unchanged)

### Step 5b: Install commands

Copy `core/commands/*.md` to `~/.config/opencode/commands/`.

For each command file:
- If the file does not exist at destination: copy it (new install)
- If the file exists and differs: ask user whether to keep theirs, overwrite, or show diff
- If the file exists and is identical: skip (unchanged)

### Step 6: Install opencode.json

Handle the opencode.json config carefully:
- If the file does not exist: copy `core/opencode.json` to `~/.config/opencode/opencode.json`
- If the file exists and is different:
  - Ask user: Keep theirs (RECOMMENDED), Merge (requires `jq`), or Show diff
  - If merging, use: `jq -s '.[0] * .[1]' user_config codexen_config`
  - If `jq` is not available, keep the user's config and inform them

### Step 7: Install global-memory templates

Copy `templates/global-memory/*` to `~/.config/opencode/global-memory/` only if the global-memory directory is empty or does not contain user data.

Files to copy:
- `templates/global-memory/user-profile.md` → `~/.config/opencode/global-memory/user-profile.md`
- `templates/global-memory/current-session.md` → `~/.config/opencode/global-memory/current-session.md`
- `templates/global-memory/work-diary/diary-YYYY-MM.md` → `~/.config/opencode/global-memory/work-diary/diary-YYYY-MM.md`

### Step 8: Install validation script

Copy `scripts/validate.sh` to `~/.config/opencode/scripts/validate.sh`.

### Step 9: Confirm

After completing all steps, show a summary:

```
Install complete!

Agents: 24 files → ~/.config/opencode/agents/
Skills: 17 directories → ~/.config/opencode/skills/
Commands: 12 files → ~/.config/opencode/commands/
Config: opencode.json → ~/.config/opencode/opencode.json
Memory: templates → ~/.config/opencode/global-memory/
Script: validate.sh → ~/.config/opencode/scripts/validate.sh

Next steps:
1. Restart OpenCode
2. Press TAB until you see codexen
3. Say: hello!
4. Try: /audit or /test
```

---

## What It Does

| Action | Location |
|--------|---------|
| Copies 24 agents (with conflict resolution) | `~/.config/opencode/agents/` |
| Copies 17 skills (with conflict resolution) | `~/.config/opencode/skills/` |
| Copies 12 commands (with conflict resolution) | `~/.config/opencode/commands/` |
| Copies opencode.json (with merge option) | `~/.config/opencode/opencode.json` |
| Creates memory templates (if empty) | `~/.config/opencode/global-memory/` |
| Copies validation script | `~/.config/opencode/scripts/validate.sh` |
| **Preserves user's custom agents/skills** | Unchanged |

---

## Quick Start

```bash
git clone https://github.com/khairulariffinka/codexen.git
cd codexen
opencode
```

Then in OpenCode:

```
"load install.md"
```

---

## After Install

1. Restart OpenCode
2. Press `TAB` until you see `codexen`
3. Say: `hello!`

---

## Troubleshooting

If something goes wrong, manually run:

```bash
mkdir -p ~/.config/opencode/agents ~/.config/opencode/skills ~/.config/opencode/commands ~/.config/opencode/global-memory ~/.config/opencode/scripts

# Copy agents
for f in core/agents/*.md; do
  cp "$f" ~/.config/opencode/agents/
done

# Copy skills
for f in core/skills/*/SKILL.md; do
  skill_dir=$(basename "$(dirname "$f")")
  mkdir -p ~/.config/opencode/skills/"$skill_dir"
  cp "$f" ~/.config/opencode/skills/"$skill_dir"/
done

# Copy commands
for f in core/commands/*.md; do
  cp "$f" ~/.config/opencode/commands/
done

# Copy config (overwrite with caution)
cp core/opencode.json ~/.config/opencode/opencode.json

# Copy global-memory templates (skip if user data exists)
if [ -z "$(ls -A ~/.config/opencode/global-memory/ 2>/dev/null)" ]; then
  cp -r templates/global-memory/* ~/.config/opencode/global-memory/
fi

# Copy validation script
cp scripts/validate.sh ~/.config/opencode/scripts/
```

## Development

To push changes, use a separate branch and create a PR. ALWAYS ask before pushing to main:

```bash
git checkout -b feature/your-feature
git add -A
git commit -m "your message"
git push -u origin feature/your-feature
```

Then create a Pull Request on GitHub.