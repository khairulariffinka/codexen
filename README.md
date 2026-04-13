# CodeXen

**AI Coding Assistant for OpenCode**

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
"Load install.md"
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

CodeXen uses a **skills** system:

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
├── init-project/     # Project initialization
├── setup-profile/    # User profile setup
└── switch-config/    # Model config switching
```

### Template Skills

```
templates/skills/
├── setup-profile/    # User profile setup
└── init-project/      # New project setup
```

---

## Subagents

| Category | Agents |
|----------|--------|
| **Coders** | frontend-coder, backend-coder, test-coder, devops-coder |
| **Auditors** | security-auditor, performance-auditor, style-auditor |
| **Planners** | planner, research |
| **Memory** | memory, decision-log |
| **Utilities** | git-manager, docs-manager, database-expert, api-designer, doc-scout |
| **Specs** | brs-manager, srs-manager, sds-manager |

---

## Features

### Global Memory

Cross-project memory that follows you:
- User profile
- Session tracking
- Work diary

### Switch Config

Change AI model configs:
```
"switch to free config"
"switch to budget"
"switch to quality"
```

| Config | Cost | Models |
|--------|------|--------|
| Free | $0 | big-pickle |
| Budget | $5-10/mo | kimi-k2.5 |
| Quality | $30-50/mo | Claude Sonnet |
| Optimized | Mixed | Smart selection |

---

## Project Structure

```
codexen/
├── core/
│   ├── agents/            # 23 subagents
│   └── skills/            # 17 skills
├── templates/             # Templates
└── VERSION.yaml          # Version
```

---

## Installation

1. Clone or download this repository
2. Run: `Load install.md`
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

Check for updates:
```
"Load update.md"
```

---

## Multi-Language Support

- English
- Bahasa Melayu Malaysia

---

## Advanced: Switch Config (Optional)

> For **advanced users only** - Optional feature, skip if unsure.

Switch between different OpenCode model configurations to optimize cost vs quality:

| Config | Cost | Best For |
|--------|------|----------|
| Free | $0/mo | Learning, testing |
| Budget | $5-10/mo | Daily coding |
| Quality | $30-50/mo | Professional work |
| Optimized | Mixed | Power users |

**Referensi:**
- https://opencode.ai/docs/zen/ - Untuk Quality config
- https://opencode.ai/docs/go/ - Untuk Budget config

**Cara switch:**

```
"load switch-config"
```

Then pilih config dari option dan restart OpenCode.

---

## Architecture

For detailed flow diagrams, see [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md).

---

## License

MIT License

**Version**: 0.4.0
