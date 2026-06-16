# CodeXen

**The Complete AI Framework for OpenCode**

![Version](https://img.shields.io/badge/version-0.7.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Agents](https://img.shields.io/badge/agents-24-blue)
![Skills](https://img.shields.io/badge/skills-17-blue)
![Commands](https://img.shields.io/badge/commands-12-blue)

> 24 agents, 17 skills, 12 commands. Zero config. Just install and start building. CodeXen turns OpenCode into a full development team with planning, coding, auditing, and deployment.

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
└── model-picker/     # Model selection
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
├── init-codexen.md   # /init-codexen → Initialize CodeXen
└── docker.md         # /docker → Setup Docker config
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

CodeXen v0.7.0 is fully optimized for OpenCode:
- **Agent system**: All 24 agents with fine-grained permissions
- **Skill system**: All 17 skills with `SKILL.md` format and valid frontmatter
- **Custom commands**: 12 slash commands for common workflows
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
│   ├── agents/            # 24 agents (Markdown format)
│   ├── skills/            # 17 skills (SKILL.md format)
│   ├── commands/          # 12 slash commands (Markdown format)
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

- **v0.7.1**: Replace switch-config with model-picker (task-based model selection), remove default model
- **v0.7.0**: OpenCode optimization (custom commands, LSP/formatters, compaction, fine-grained permissions, model optimization)
- **v0.6.0**: OpenCode compatibility refactor (skill/agent standardization, opencode.json, validate.sh)
- **v0.5.0**: Guardrails, self-healing orchestration, BRS/SRS/SDS chain, lessons learned
- **v0.4.4**: Dry-run, auto-backup, conflict resolution
- **v0.4.0**: Initial release

---

## Multi-Language Support

- English
- Bahasa Melayu Malaysia

---

## Architecture

For detailed flow diagrams, see [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md).

---

## License

MIT License

**Version**: 0.7.0