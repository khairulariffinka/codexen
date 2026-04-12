# CodeXen Architecture

Documentation of the project structure and design decisions.

---

## Flow Diagrams

### User → CodeXen → Output

```
┌─────────────────────────────────────────────────────────────┐
│                    USER INPUT                              │
│  "build a login page" / "init project" / "review code"    │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│              CODEXEN (Primary Agent)                       │
│  1. Check: AGENTS.md exists? → Load project context       │
│  2. Check: Global memory (user profile, sessions)            │
│  3. Determine: Mode (dev/quick/review/debug)            │
│  4. Route: Task → appropriate subagent(s)              │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│              SUBAGENTS (Parallel + Chain)                 │
├─────────────────────────────────────────────────────────────┤
│  PARALLEL (Independent tasks):                            │
│  ├─ backend-coder  → Create API, models                │
│  ├─ frontend-coder → Create UI components             │
│  └─ test-coder    → Write tests                       │
│                                                         │
│  CHAIN (Dependent tasks):                            │
│  planner → research → coder                          │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│              AUDITS (Automatic)                           │
├─────────────────────────────────────────────────────────────┤
│  ├─ security-auditor   → Scan vulnerabilities            │
│  ├─ performance-auditor → Check performance              │
│  └─ style-auditor     → Code style                    │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌────────────────────────────────────────────────────���────────┐
│                   OUTPUT                                 │
│  - Code written + tests                                 │
│  - Audit results (passed/Issues found)                 │
│  - Git commit offer                                   │
│  - Session saved to memory                            │
└─────────────────────────────────────────────────────────────┘
```

---

### New Project Flow

```
┌─────────────────────────────────────────────────────────────┐
│                   NEW PROJECT                             │
│  $ mkdir my-project                                     │
│  $ cd my-project                                        │
│  $ opencode                                            │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│              CODEXEN: STARTUP                            │
│  → Check: AGENTS.md exists?                            │
│  → NOT FOUND: Prompt user                              │
│  User: "init project"                                  │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│              INIT-PROJECT SKILL (Auto)                   │
│  Creates:                                              │
│  ├─ AGENTS.md           ← AI context (tech stack)       │
│  ├─ docs/current-state.yaml ← Project snapshot          │
│  ├─ docs/session-diary.yaml ← Session log              │
│  ├─ docs/AI-AGENT-PROTOCOL.yaml                        │
│  ├─ .gitignore                                           │
│  └─ .env.example                                          │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                   READY TO WORK                         │
│  User: "build login page"                               │
└─────────────────────────────────────────────────────────────┘
```

---

### Install & Update Flow

```
┌─────────────────────────────────────────────────────────────┐
│                      INSTALL                             │
│  1. git clone https://github.com/khairulariffinka/codexen  │
│  2. Load install.md                                     │
│  3. Files → ~/.config/opencode/                          │
│  4. Restart OpenCode                                   │
└───────────���─��───────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                      UPDATE                             │
│  1. Load update.md  (or "update codexen")              │
│  2. Auto-check: Current vs Latest version              │
│  3. Auto-apply: Update core agents & skills             │
│  4. Preserve: User customizations & data             │
│  5. Done!                                               │
└─────────────────────────────────────────────────────────────┘
```

---

### Subagent Routing

```
┌─────────────────────────────────────────────────────────────┐
│              TASK TYPE → SUBAGENT                         │
├─────────────────────────────────────────────────────────────┤
│  "API", "backend", "database"    → @backend-coder         │
│  "UI", "page", "component"     → @frontend-coder        │
│  "test", "spec"               → @test-coder            │
│  "Docker", "deploy"           → @devops-coder           │
│  "security", "vulnerable"    → @security-auditor      │
│  "slow", "optimize"           → @performance-auditor   │
│  "style", "lint"              → @style-auditor         │
│  "plan", "breakdown"         → @planner              │
│  "research", "analyze"       → @research             │
│  "git", "commit"             → @git-manager          │
│  "memory", "context"         → @memory              │
│  "document"                 → @docs-manager         │
└─────────────────────────────────────────────────────────────┘
```

---

## Project Overview

CodeXen is an AI coding assistant for OpenCode that coordinates multiple specialized subagents to handle software development tasks.

## Directory Structure

```
codexen/
├── agent/                      # Primary agent (user renames this)
│   ├── codexen.md         # Main orchestrator
│   └── skills/codexen/   # Modular skill components
│       ├── greeting.md        # Time-based greetings
│       ├── orchestration.md   # Workflow & subagent management
│       ├── modes.md           # Operating modes
│       └── output.md          # Output formatting
│
├── core/                      # Core components (updated regularly)
│   ├── agents/                # Subagent definitions
│   │   ├── _template.md      # Agent template
│   │   ├── backend-coder.md
│   │   ├── frontend-coder.md
│   │   └── ... (other agents)
│   │
│   └── skills/               # Core skills
│       └── patterns.md       # Code patterns
│
├── features/                 # Optional extensions
│   └── relationship-memory/
│
└── templates/               # Templates for new agents
    └── agent-template.md
```

## Design Principles

### 1. Modularity

The primary agent is split into separate skill files:
- Each skill handles a specific concern
- Skills reference shared fragments
- Easy to update individual components

### 2. Shared Fragments

Common content is extracted to reusable fragments:
- `workflow.md` - Standard workflow pattern
- `output-format.md` - Consistent output formatting
- `rules.md` - Coding rules
- `patterns.md` - Code examples
- `audit-rules.md` - Audit criteria

### 3. Template-Driven

New agents should use `_template.md` as a starting point to ensure consistency.

## Agent Types

### Primary Agent

The main orchestrator (default: `codexen`). Handles:
- User interaction
- Mode selection
- Subagent coordination
- Workflow management

### Subagents

Specialized agents for specific tasks:

| Category | Agents |
|----------|--------|
| Coders | backend-coder, frontend-coder, test-coder, devops-coder |
| Auditors | security-auditor, performance-auditor, style-auditor |
| Planners | planner, research |
| Memory | memory, decision-log |
| Utilities | git-manager, docs-manager |

## Creating a New Agent

1. Copy `_template.md` to a new file in `core/agents/`
2. Fill in the template with agent-specific content
3. Reference shared fragments where applicable
4. Add to subagent registry in orchestration.md

## Updating Agents

When updating agents:
1. Check if shared fragments cover common content
2. Update fragments if needed (propagates to all agents)
3. Update individual agent files for specific content

## File Naming Conventions

- Agent files: `kebab-case.md`
- Skills: `kebab-case.md` in `skills/`
- Templates: `kebab-case.md`

## Version Information

- **Version**: See `VERSION.yaml`
- **Last Updated**: See `README.md`
