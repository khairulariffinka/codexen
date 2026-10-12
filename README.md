# CodeXen

**Turn OpenCode into a full dev team — 25 agents, auto-memory, context monitoring, self-healing. Just tell it what to build.**

![Version](https://img.shields.io/badge/version-0.10.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Agents](https://img.shields.io/badge/agents-25-blue)
![Skills](https://img.shields.io/badge/skills-19-blue)
![Commands](https://img.shields.io/badge/commands-13-blue)

> 25 AI agents that handle planning, coding, auditing, and deployment. Zero config. Just install and go.

Give it a task, it handles the rest.

```bash
"build a login page"
"create a REST API"
"review my code"
```

---

## Get Started

### 1. Clone / Download

```bash
git clone https://github.com/khairulariffinka/codexen.git
cd codexen
```

### 2. Install

```
"load install.md"
```

### 3. Activate

Press `TAB` until you see `codexen`

### 4. Use

```
build a user authentication system
```

---

## Docs

- [Quick Start Guide](QUICKSTART.md)
- [Commands Reference](COMMANDS.md)
- [Tutorials](TUTORIALS.md)

---

## What Can It Do?

| Task | Example |
|------|---------|
| Build features | `build a login page` |
| Create APIs | `create a REST API for products` |
| Write tests | `write tests for auth module` |
| Review code | `review the payment module` |
| Fix bugs | `debug: login returns 500 error` |
| Docker setup | `set up Docker for my app` |

---

## Operating Modes

| Mode | Example | Best For |
|------|---------|----------|
| (default) | `build a login page` | Full workflow + audits |
| **quick** | `quick, build test API` | Fast, skip audits |
| **review** | `review, audit this module` | Code review only |
| **debug** | `debug, fix this error` | Troubleshooting |

---

## Skills

CodeXen uses a **skills** system loaded by OpenCode's native `skill` tool:

```
core/skills/
├── planner/          # Planning
├── coder/            # Coding
├── auditor/          # Auditing
├── memory/           # Memory
├── security/         # Security
├── research/         # Research
├── decision-log/     # Decision logging
├── brs/              # Business Requirements
├── srs/              # Software Requirements
├── sds/              # System Design
├── orchestration/    # Orchestration logic
├── modes/            # Operating modes
├── output/           # Output formatting
├── greeting/         # Time-based greetings
├── init-project/     # Project initialization
├── setup-profile/    # User profile setup
├── model-picker/     # Model selection
├── compress/         # Terse communication mode (~75% token savings)
└── compress-file/    # Compress memory files (~46% input savings)
```

---

## Plugins

CodeXen includes a **context-monitor plugin** that tracks token usage and alerts you when context gets full. One file works on **OpenCode v1 (>= 1.18.29) and v2**.

```
core/.opencode/
├── plugins/
│   └── context-monitor.ts    # Context monitoring + threshold alerts (v1 + v2)
└── package.json              # v1 plugin dependency (v2 needs none)
```

### Context Monitor Features

| Feature | Description |
|---------|-------------|
| **Token Tracking** | Input, output, reasoning, cache tokens of the latest turn |
| **Thresholds** | 70% warn, 80% checkpoint, 90% compress, 95% critical |
| **Context Alerts** | v1: toast + log; v2: server log only (v2 has no toast API for server plugins). The agent checks `check_context` and runs @checkpoint-writer itself — the plugin cannot dispatch agents |
| **Dynamic Limits** | Reads the model's context limit from the provider list |
| **Manual Check** | `/context` command for on-demand status |

### Usage

```
/context           → Show context usage
/context detailed  → Show threshold breakdown
```

---

## Custom Commands

CodeXen provides slash commands for repetitive tasks:

```
core/commands/
├── audit.md          # /audit → Full security + quality audit
├── test.md           # /test → Run tests with coverage
├── lint.md           # /lint → Lint and auto-fix issues
├── review.md         # /review → Code review recent changes
├── plan.md           # /plan → Create implementation plan
├── brs.md            # /brs → Generate Business Requirements
├── srs.md            # /srs → Generate Software Requirements
├── sds.md            # /sds → Generate System Design
├── commit.md         # /commit → Smart git commit
├── refactor.md       # /refactor → Refactor with SOLID
├── docker.md         # /docker → Setup Docker config
├── context.md        # /context → Context usage + token breakdown
└── goal.md           # /goal → Set a goal the agent must meet before stopping
```

---

## Subagents

| Category | Agents |
|----------|--------|
| **Primary** | codexen (orchestrator) |
| **Coders** | frontend-coder, backend-coder, test-coder, refactor-expert, devops-coder |
| **Auditors** | auditor, security-auditor, security, performance-auditor, style-auditor |
| **Planners** | planner, research |
| **Memory** | memory, decision-log |
| **Utilities** | git-manager, docs-manager, coder, database-expert, api-designer, doc-scout |
| **Specs** | brs-manager, srs-manager, sds-manager |

---

## Features

### Global Memory

Cross-project memory that follows you:
- User profile
- Session tracking
- Work diary

### OpenCode Native Integration

CodeXen v0.10.0 is fully optimized for OpenCode:
- **Agent system**: All 25 agents with fine-grained permissions
- **Skill system**: All 19 skills with `SKILL.md` format and valid frontmatter
- **Custom commands**: 13 slash commands for common workflows
- **Permission system**: Role-based permissions per agent (coders get edit, auditors are read-only)
- **Subagent routing**: Defined in `opencode.json` with `mode` and `hidden` flags
- **LSP integration**: Language server protocol for code intelligence
- **Auto-formatters**: Prettier, Ruff, GoFmt, etc. auto-format on save
- **Compaction**: Auto-compact context when token limit approaches
- **Model optimization**: Use cheaper models for lightweight tasks (title generation)

---

## Project Structure

```
codexen/
├── core/
│   ├── agents/            # 25 agents (Markdown format)
│   ├── skills/            # 19 skills (SKILL.md format)
│   ├── commands/          # 13 slash commands (Markdown format)
│   └── opencode.json      # Agent configuration
├── templates/             # Global memory templates
├── scripts/               # Validation scripts
└── VERSION.yaml            # Version tracking
```

---

## Installation

1. Clone or download this repository
2. Run: `load install.md`
3. Restart OpenCode

### OpenCode v1 and v2

CodeXen works on **OpenCode v1 (>= 1.18.29)** and **OpenCode v2**. Config stays in v1 syntax, which v2 reads through its compatibility layer.

| Area | v1 | v2 |
|------|----|----|
| Agents, skills, commands | ✅ | ✅ (v1 format auto-converted) |
| Context monitor plugin | ✅ toast + log | ✅ log only (no toast API for server plugins) |
| `lsp: true` | ✅ | ignored (v2 has no LSP) |
| `compaction.prune` | ✅ | ignored with a warning |
| Project memory | `AGENTS.md` | `AGENTS.md` (the `instructions` key and `CLAUDE.md` fallback are not loaded in v2) |
| Tool names in permissions | `bash`, `task` | `shell`, `subagent` (v1 names auto-converted) |

## New Project

```bash
mkdir my-project
cd my-project
opencode
```
Then type: `init project`

---

## Updating

### Check for Updates

```
"load update.md"
```

### Options

| Option | Description |
|--------|-------------|
| (default) | Full update with backup |
| `--dry-run` | Preview changes only |

### Changelog

See [CHANGELOG.md](CHANGELOG.md) for every release.

---

## Multi-Language Support

- English
- Bahasa Melayu Malaysia

---

## Architecture

CodeXen uses a modular architecture with agents, skills, and commands working together through an orchestration layer. For details, see the [Tutorials](TUTORIALS.md) and [Commands Reference](COMMANDS.md).

---

## License

MIT License — see [LICENSE](LICENSE). Current version: see [VERSION.yaml](VERSION.yaml).
