# Changelog

All notable changes to CodeXen are documented here.

Format based on [Keep a Changelog](https://keepachangelog.com/), versioning follows [SemVer](VERSIONING.md).

---

## [0.9.0] - 2026-06-18

### Added
- **Context Monitor Plugin**: `core/.opencode/plugin/context-monitor.ts` — event-based context monitoring via `message.updated` hooks
- **Token Tracking**: Input, output, reasoning, cache.read, cache.write tokens
- **Threshold Actions**: 70% warn, 80% checkpoint, 90% compress, 95% critical
- **Auto-Checkpoint**: Triggers @checkpoint-writer agent at 80% context
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
