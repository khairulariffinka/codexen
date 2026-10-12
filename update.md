# Update CodeXen

> **When user loads this file:** User wants to update CodeXen to latest version.

```
"load update.md"
```

That's it!

---

## Options

| Option | Description |
|--------|-------------|
| (default) | Full update with backup |
| `--dry-run` | Preview only, no changes |

To use, append after command: `"load update.md --dry-run"`

---

## Changelog

### v0.10.1 (Current)
- FIX: opencode.json merge now updates old CodeXen defaults you never changed (e.g. planner/security permissions) and removes retired keys (`instructions`); your own values still win

### v0.10.0
- ADD: OpenCode v2 support (v1 >= 1.18.29 and v2); context monitor works on both
- ADD: `/goal` slash command (13 commands)
- FIX: subagents hand off via `## Handoff` (OpenCode subagents cannot call subagents)
- FIX: agent permissions consistent between `.md` and `opencode.json`
- CHANGE: plugin dir `plugin/` → `plugins/`; old CodeXen copies removed on install/update
- CHANGE: `instructions` removed from `opencode.json` (AGENTS.md is the entry point)

### v0.9.1
- FIX: Context Monitor plugin now actually counts tokens (read wrong event field; always showed 0)
- FIX: Context % uses latest message size + real model limit (was cumulative sum vs fixed 128K)
- FIX: `/context` command frontmatter
- FIX: install/update now copy the 11 slash commands (`core/commands/`)
- FIX: Enter on opencode.json/package.json conflict = Merge; no input = keep yours (script no longer aborts)
- FIX: Merge works without jq (falls back to node or python3); invalid JSON/JSONC is never overwritten
- FIX: `--dry-run` writes nothing; update never overwrites global-memory; update makes a backup
- ADD: `tests/test-install.sh` and `tests/test-context-monitor.mts` (run in CI)

### v0.9.0
- ADD: Context Monitor Plugin (`core/.opencode/plugin/context-monitor.ts`)
- ADD: `/context` slash command (`core/.opencode/command/context.md`)
- ADD: Checkpoint Writer agent (`core/agents/checkpoint-writer.md`)
- ADD: `@memory read-budgeted` for token-budgeted file reading
- ADD: `@memory auto-dream-check` and `@memory auto-distill-check`
- ADD: Plugin install/update with conflict resolution
- CHANGE: 25 agents (added checkpoint-writer)
- CHANGE: Generic opencode.json for all users

### v0.8.0
- ADD: Token optimization (compress mode with user preferences, compress-file, terse subagent output)
- ADD: Model-picker (task-based model selection)
- CHANGE: Removed default model setting

### v0.7.0
- ADD: 11 custom slash commands (`/audit`, `/test`, `/lint`, `/review`, `/plan`, `/brs`, `/srs`, `/sds`, `/commit`, `/refactor`, `/docker`)
- ADD: Model optimization (`model` + `small_model` for cost savings)
- ADD: LSP integration (`lsp: true` for code intelligence)
- ADD: Auto-formatters (`formatter: true` for Prettier, Ruff, etc.)
- ADD: Auto-compaction (`compaction: auto + prune` to prevent context overflow)
- ADD: Instructions config (multi-file instruction loading)
- ADD: Fine-grained permissions per agent role (coders=edit, auditors=read-only, etc.)
- ADD: `copy_core_commands` in install config
- ADD: Smart Recall — auto-suggest lessons based on task keywords
- ADD: Priority Scoring — rank lessons by frequency/severity/recency
- ADD: Agent Performance Tracking — track success/failure rate per agent
- ADD: Smart Routing — auto-select best agent based on track record
- ADD: Goal/Stop Condition — `/goal` command with judge evaluation
- ADD: Dream & Distill — `/dream` extract knowledge, `/distill` package workflows
- ADD: Auto-Checkpoint — save session state when context nears limit
- ADD: Mandatory Auto-Enforcement — 17 mandatory steps, zero exceptions

### v0.6.0
- REFACTOR: All 17 SKILL.md files standardized with OpenCode-compatible frontmatter
- REFACTOR: All 24 agent .md files standardized with consistent permission format
- REFACTOR: Removed `name:` field from agent frontmatter (OpenCode uses filename)
- ADD: opencode.json now registers all 24 subagents with mode and hidden flags
- ADD: validate.sh enhanced with SKILL.md name validation

### v0.5.0
- ADD: Self-healing orchestration (8 error recovery scenarios)
- ADD: Feedback loop with lessons learned system (lessons.md)
- ADD: CI/CD validation script (scripts/validate.sh, 12 checks)
- ADD: Token budgeting system with auto-triggers and sliding window
- ADD: Guardrails (ask before modify, circuit breaker, rate limit, scope)
- ADD: Open source files (CONTRIBUTING.md, SECURITY.md, CODE_OF_CONDUCT.md)

### v0.4.0
- Initial release with conditional update logic
- Preserve user customizations

---

## Context

When this file is loaded, AI must know:
- User wants to update to latest version
- NOT just reading the file
- AI must execute update steps
- IMPORTANT: Skip copying opencode.json if already exists AND same (preserve user customizations)
- IMPORTANT: Copy only missing global-memory files (never overwrite user data)

## AI Execution

Run the tested update script from the CodeXen repo folder — do **not** re-implement it step by step:

```bash
cd /path/to/codexen          # the cloned repo (git pull first to get the latest version)
git pull
bash update_script.sh        # or: bash update_script.sh --dry-run   (preview, writes nothing)
```

What the script does (covered by `tests/test-install.sh`):
- Backs up `~/.config/opencode` first (unique timestamped folder).
- Agents / skills / commands / plugins: a file that is an **unmodified older CodeXen release** (matched against the repo's git history) is updated automatically; a file **you customised** prompts you — Enter or no input keeps yours. (Zip downloads have no git history, so every changed file prompts.)
- `opencode.json` / `package.json`: Enter = merge (your values win, new CodeXen keys added); no input = keep yours. Values still equal to an older CodeXen default are updated to the current default first (removed keys are deleted only if retired, e.g. `instructions`; model choices are never deleted).
- Removes old CodeXen copies in legacy singular dirs (`plugin/`, `command/`) so nothing loads twice.
- Never overwrites global-memory (profile, diary, lessons).

The script prompts on stdin. If you are running it for the user non-interactively, show them the conflict list from `--dry-run` first and ask which files to overwrite.

After it finishes: tell the user to restart OpenCode, and run `bash ~/.config/opencode/scripts/validate.sh --installed`.

---

## What It Does

| Action | Description |
|--------|-----------|
| Update agents (compare first) | Copy 25 agents |
| Update skills (compare first) | Copy 19 skills |
| Update commands (compare first) | Copy 13 commands |
| Update plugins | Copy context-monitor to plugins/ (removes old plugin/ copy) |
| Update global-memory (missing files only) | Copy templates if missing |
| Update opencode.json (if different) | Preserve user customizations |
| Update memory templates (if empty) | Skip if exists |
| Update validation script | Copy to ~/.config/opencode/scripts/ |
| **Preserves user's custom agents/skills** | Unchanged |
| Update version | Mark as current |

---

## Quick Update

In OpenCode:

```
"load update.md"
```

---

## Version

Current: **0.9.1**

---

## Troubleshooting

If update doesn't work, manually run:

```bash
# Update OUR agents only, preserve user's custom agents
for f in core/agents/*.md; do
  agent_name=$(basename "$f")
  if [ -f ~/.config/opencode/agents/"$agent_name" ]; then
    if ! diff -q "$f" ~/.config/opencode/agents/"$agent_name" > /dev/null 2>&1; then
      cp "$f" ~/.config/opencode/agents/"$agent_name" && echo "Updated: $agent_name"
    fi
  else
    cp "$f" ~/.config/opencode/agents/ && echo "Added: $agent_name"
  fi
done

# Update OUR skills only, preserve user's custom skills
for f in core/skills/*/*.md; do
  skill_name=$(basename "$f")
  skill_dir=$(dirname "$f" | xargs basename)
  mkdir -p ~/.config/opencode/skills/"$skill_dir"
  if [ -f ~/.config/opencode/skills/"$skill_dir"/"$skill_name" ]; then
    if ! diff -q "$f" ~/.config/opencode/skills/"$skill_dir"/"$skill_name" > /dev/null 2>&1; then
      cp "$f" ~/.config/opencode/skills/"$skill_dir"/"$skill_name" && echo "Updated: $skill_name"
    fi
  else
    cp "$f" ~/.config/opencode/skills/"$skill_dir"/ && echo "Added: $skill_name"
  fi
done

# Compare and update opencode.json
if [ -f ~/.config/opencode/opencode.json ]; then
  if ! diff -q core/opencode.json ~/.config/opencode/opencode.json > /dev/null 2>&1; then
    cp core/opencode.json ~/.config/opencode/opencode.json && echo "Updated opencode.json"
  fi
else
  cp core/opencode.json ~/.config/opencode/opencode.json && echo "Copied opencode.json"
fi

# Copy missing global-memory templates
for f in templates/global-memory/*; do
  fname=$(basename "$f")
  dest=~/.config/opencode/global-memory/"$fname"
  if [ -f "$f" ] && [ ! -f "$dest" ]; then
    cp "$f" "$dest" && echo "Added: $fname"
  fi
done
[ ! -f ~/.config/opencode/global-memory/work-diary/diary-YYYY-MM.md ] && mkdir -p ~/.config/opencode/global-memory/work-diary && cp templates/global-memory/work-diary/diary-YYYY-MM.md ~/.config/opencode/global-memory/work-diary/ && echo "Added: work-diary/diary-YYYY-MM.md"
```

---

## Development Workflow

For contributors - NEVER push directly to main. ALWAYS ask before pushing. Use branches:

```bash
# Create a new branch
git checkout -b feature/your-feature

# Make changes and commit
git add -A
git commit -m "feat: your feature"

# Push and create PR
git push -u origin feature/your-feature
# Then create Pull Request on GitHub

# IMPORTANT: Ask before pushing to main
```