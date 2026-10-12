# Changelog

All notable changes to CodeXen are documented here.

Format based on [Keep a Changelog](https://keepachangelog.com/), versioning follows [SemVer](VERSIONING.md).

---

## [0.10.1] - 2026-10-12

### Fixed
- **Updates never delivered config fixes**: the `opencode.json` / `package.json` merge is "your values win", so old CodeXen defaults in your file counted as *your* values and were kept forever. v0.10.0's permission fixes (planner can write `planner.md`, `@security` can run audits) and the `instructions` removal therefore never reached existing users. Now, before merging, any value that still equals what an earlier CodeXen release shipped at the same path (checked against git history) is updated to the current default. Values you changed are untouched
- Keys CodeXen dropped are only deleted if explicitly retired (`instructions`); user choices that once matched a default (e.g. `small_model`) are never deleted
- Needs git history + node; zip downloads fall back to the plain merge
- Tests: install 65 (new refresh cases, key-order independent)

---

## [0.10.0] - 2026-10-12

OpenCode v2 support, working multi-agent handoffs, and docs that match reality.

### Added
- **OpenCode v2 support**: CodeXen runs on OpenCode v1 (>= 1.18.29) and v2. Config stays in v1 syntax, which v2 converts automatically
- **Context monitor for v1 + v2 in one file** (`core/.opencode/plugins/context-monitor.ts`): v1 uses `server()`, v2 uses `setup()`. v2 needs no npm dependency. v2 has no toast API for server plugins, so alerts go to the log there
- **`/goal` slash command**: set, show or clear a goal the agent must meet before it stops (the protocol existed, the command did not)
- **Handoff protocol**: subagents end with a `## Handoff` block; codexen dispatches the requested agents
- **Smarter update**: `update_script.sh` updates unmodified older CodeXen files automatically (matched against git history) and only prompts for files you customised — previously pressing Enter kept every old file, so fixes never arrived
- **validate.sh checks**: agent `.md` permissions vs `opencode.json`, no direct agent calls from subagents, and docs counts/versions vs files on disk (counts now come from `VERSION.yaml`, no hardcoded numbers)
- Tests: plugin 31 (v1 + v2 adapters), install 55 (incl. legacy-dir migration and unmodified-file detection)

### Fixed
- **Subagents silently failed to call other agents**: OpenCode subagents cannot start subagents (`subagent_depth` = 1), so steps like coder's "MANDATORY @memory lessons" and "call @test-coder / @auditor" never ran. Subagents now grep lessons themselves and hand off the rest
- **Permission conflicts** between agent `.md` files and `opencode.json`: planner can now write `planner.md`; `@security` can run `npm/composer/pip audit`; auditor, memory and doc-scout are consistently read-only; git-manager asks before `git push` / `git reset --hard`
- Stale docs: wrong counts ("12 commands" when there were 11, ARCHITECTURE.md with 24 agents / 17 skills / switch-config), version strings (README footer 0.8.0, setup-guide 1.0.0), phantom "Gemini CLI" install option, `mode: all` in COMMANDS.md

### Changed
- Plugin directory `plugin/` → `plugins/` (official name). `/context` moved to `core/commands/`. Install/update remove the old CodeXen copies (only files containing `check_context`), so the plugin does not load twice
- `instructions` removed from `opencode.json`: v2 ignores it, and it loaded every `docs/context/*.md` each session, against the "read only relevant context" protocol. `AGENTS.md` (auto-loaded by OpenCode) is the single entry point and now has a Session Protocol section
- `update.md` now runs the tested `update_script.sh` instead of a 300-line inline copy that had drifted
- Guardrails documented honestly: prompt-level rules vs what OpenCode permissions actually enforce
- CI runs `validate.sh` + both test suites only (no duplicated hardcoded checks)

### Upgrade notes
- Run `bash update_script.sh` (or `load update.md`), then restart OpenCode
- If you merged `instructions` into your own `opencode.json` before, it is kept (your values win). Remove it if you want the token savings
- 13 commands, 25 agents, 19 skills

---

## [0.9.1] - 2026-10-12

### Fixed
- **Context Monitor plugin did not work**: it read `event.properties.message` but OpenCode sends `properties.info`, so it never counted anything (`check_context` always showed 0)
- **Context % calculation**: now uses the latest assistant message (input + cache read/write + output + reasoning) instead of summing every `message.updated` event, which overcounted heavily
- **Context limit**: looked up from the provider's model list (was always the 128K default)
- **Thresholds per session**: alerts once per threshold per session, re-armed after compaction; shows a TUI toast
- **Cost**: uses real per-message `cost` instead of hardcoded Sonnet pricing
- **`/context` command**: added missing frontmatter
- **install.sh / update_script.sh**: now install the 11 slash commands from `core/commands/`
- **Conflict prompts**: Enter now selects Merge for opencode.json/package.json (was "Keep mine" despite the label); no input (EOF) keeps the user's file instead of aborting the script halfway
- **Merge without jq**: falls back to node or python3; invalid JSON/JSONC is never overwritten
- **`--dry-run`** no longer creates folders or files
- **update_script.sh**: never overwrites global-memory (profile/memory); now makes a backup; package.json uses merge
- **Backups**: unique per second, no nested folder on re-run
- **CI**: validation expected 24 agents / 17 skills (repo has 25 / 19) and was failing

### Changed
- Docs (README, orchestration and memory skills) now describe what the plugin really does: it alerts the user, and the agent calls `check_context` and dispatches @checkpoint-writer itself (the plugin cannot dispatch agents)
- Shared install helpers moved to `scripts/common.sh`

### Added
- `tests/test-install.sh` — 38 sandbox checks for install/update (never touches real `~/.config`)
- `tests/test-context-monitor.mts` — 14 plugin unit tests with a mock client
- CI runs both test suites

---

## [0.9.0] - 2026-06-18

### Added
- **Context Monitor Plugin**: `core/.opencode/plugin/context-monitor.ts` — event-based context monitoring via `message.updated` hooks
- **Token Tracking**: Input, output, reasoning, cache.read, cache.write tokens
- **Threshold Actions**: 70% warn, 80% checkpoint, 90% compress, 95% critical
- **Auto-Checkpoint**: Triggers @checkpoint-writer agent at 80% context _(corrected in 0.9.1: plugin alerts, agent dispatches)_
- **`/context` Command**: Manual context check with detailed breakdown
- **Checkpoint Writer Agent**: `core/agents/checkpoint-writer.md` — auto-writes checkpoints when context is full
- **`@memory read-budgeted`**: Token-budgeted file reading (~10 tokens/line) with priority-based compression
- **`@memory auto-dream-check`**: Auto-run dream if > 7 days since last
- **`@memory auto-distill-check`**: Auto-run distill if > 30 days since last
- **Checkpoint Restore**: Budgeted reading for checkpoint.md (5K) and memory.md (3K)
- **Orchestration Integration**: Plugin-based context monitoring documented in task lifecycle

### Changed
- **25 agents**: Added checkpoint-writer (total: 25 agents)
- **Session Init Step 9**: Auto-inject checkpoint via budgeted read
- **opencode.json**: Made generic for all users (removed hardcoded model)

### Technical
- Plugin: `@opencode-ai/plugin` package
- Dynamic context limit: reads `model.limit.context` from API
- Token budgets: checkpoint 5K, memory 3K, tasks 2K (total 8K)

---

## [0.8.0] - 2026-06-17

### Added
- **`compress` skill**: Ultra-compressed communication mode (~75% output token savings). Supports lite/full/ultra intensity levels. Trigger: "compress mode" / "terse mode" / "be brief". Auto-clarity for security warnings
- **User preferences**: Set compress default (full/lite/ultra/off) in `user-preferences.md` — respected across all sessions
- **`/compress-file` skill**: Compress memory files (AGENTS.md, planner.md, DECISIONS.md) to save ~46% input tokens per session
- **Terse subagent output**: All subagents now emit structured terse output to preserve main context

---

## [0.7.1] - 2026-06-17

### Changed
- **Replaced `switch-config` with `model-picker`**: Interactive model selection based on task type and budget instead of hardcoded config presets
- **Removed default model from opencode.json**: OpenCode now uses last-used model across sessions (via `persistModelAcrossSessions`)

### Removed
- `switch-config` skill (replaced by `model-picker`)

---

## [0.7.0] - 2026-06-16

### Added
- **11 custom slash commands**: `/audit`, `/test`, `/lint`, `/review`, `/plan`, `/brs`, `/srs`, `/sds`, `/commit`, `/refactor`, `/docker`
- **Model optimization**: `model` + `small_model` config for cost savings (cheap model for title generation)
- **LSP integration**: `lsp: true` for language server protocol code intelligence
- **Auto-formatters**: `formatter: true` for Prettier, Ruff, GoFmt, etc. on save
- **Auto-compaction**: `compaction: auto + prune` to prevent context overflow
- **Instructions config**: Multi-file instruction loading via `instructions` array
- **Fine-grained permissions**: Role-based permissions per agent type:
  - Coders: edit + bash allowed
  - Auditors: read-only (edit + bash denied)
  - Research/Planner: read-only (edit + bash denied)
  - Git Manager: bash with push confirmation
  - Doc Scout: webfetch + websearch only
  - Memory/Spec writers: edit allowed, bash denied
- **Smart Recall**: Auto-suggest relevant lessons based on task keywords (no manual topic needed)
- **Priority Scoring**: Rank lessons by frequency, severity, and recency
- **Agent Performance Tracking**: Track success/failure rate, avg duration, error patterns per agent
- **Smart Routing**: Auto-select best agent based on track record
- **Goal/Stop Condition**: `/goal` command with judge evaluation to prevent premature agent stop
- **Dream & Distill**: `/dream` extracts knowledge from sessions, `/distill` packages workflows into skills
- **Auto-Checkpoint**: Save session state when context nears limit, auto-restore on resume

### Changed
- Version: 0.6.0 → 0.7.0
- All 24 agents now have explicit permission configs in opencode.json
- README.md updated with slash commands and new features
- COMMANDS.md updated with slash commands section

---

## [0.5.0] - 2026-04-29

### Added
- **24 subagents** with routing table in `codexen.md`
- **Self-healing orchestration**: 8 error recovery scenarios (timeout, partial parallel, routing failure, etc.)
- **Self-learning**: auto-log lessons on circuit breaker, mandatory lessons check before tasks
- **Self-updating**: auto-check for new commits on session start (`@memory, update check`)
- **13 guardrails**: ask before modify, circuit breaker, rate limit, scope enforcement, catastrophic undo, delete confirm, command preview, network guard, large code warn, env detection, dependency guard, dry-run, secret scan, message validation
- **Token budgeting**: auto-trigger compression at 80%, `@memory, budget`
- **Feedback loop**: user rating after output ([1]/[2]/[3]), auto-log to `lessons.md`
- **Parallel validation**: dependency check, file conflict detection, circular dep check
- **CI/CD validation**: `scripts/validate.sh` (12 checks, --installed flag)
- **Formal changelog workflow**: BRS → SRS → SDS → Planner change propagation
- **Open source files**: CONTRIBUTING.md, SECURITY.md, CODE_OF_CONDUCT.md
- **GitHub templates**: issue templates, PR template
- **Agent generator**: `scripts/generate-agent.sh [name]`
- **Production test suite**: `tests/test-self-healing.sh` (18 scenarios)
- **Health check**: `@memory, health`

### Fixed
- Architecture.md: outdated directory structure (agent/ → core/)
- Memory agent: removed overclaim terminology
- Planner.md: edit:deny → edit:allow
- Permission consistency: bash:deny for doc-writers
- .gitignore scope: /memory/ and /docs/ (root-only)
- Install/update scripts: missing agent loop, primary agent name/mode preservation

### Changed
- Version: 0.4.0 → 0.5.0
- Expanded: research.md, refactor-expert.md, backend-coder.md, auditor.md, brs-manager.md
- Added cross-agent handoffs (@test-coder, @auditor, @decision-log) to all coders
- Added audit gate (mandatory @auditor PASSED before commit)

---

## [0.4.1] - 2026-04-13

### Added
- `--dry-run` option for install/update
- Auto-backup before install/update
- Changelog display in install/update

---

## [0.4.0] - 2026-04-13

### Added
- Initial release
- Core agent system
- BRS/SRS/SDS specification chain
- Memory system with compression
- Install/update scripts
