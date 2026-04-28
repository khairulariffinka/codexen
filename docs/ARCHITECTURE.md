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
│  1. Read AGENTS.md → Load project context                 │
│  2. Read global memory (user profile, sessions)            │
│  3. Determine mode (default/quick/review/debug)            │
│  4. Route task → appropriate subagent(s)                  │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│              SUBAGENTS (Parallel + Chain)                 │
├─────────────────────────────────────────────────────────────┤
│  PARALLEL (Independent tasks):                            │
│  ├─ backend-coder  → Create API, models                │
│  └─ frontend-coder → Create UI components              │
│                                                         │
│  CHAIN (Dependent tasks):                               │
│  research → [backend-coder + frontend-coder] →         │
│    test-coder → auditor → git-manager                  │
│                                                         │
│  HANDOFFS (Built-in):                                   │
│  ├─ @test-coder     → Tests after code                  │
│  ├─ @auditor        → Quality gate before commit        │
│  ├─ @decision-log   → Log architectural choices         │
│  └─ @doc-scout      → Fetch live library docs           │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│              AUDITS (Automatic)                           │
├─────────────────────────────────────────────────────────────┤
│  ├─ auditor           → Code quality checklist            │
│  ├─ security-auditor  → OWASP Top 10 scan                 │
│  ├─ performance-auditor → N+1, memory, optimization       │
│  └─ style-auditor     → Naming, structure, conventions    │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│                   OUTPUT                                 │
│  - Code written + tests                                 │
│  - Audit results (passed/issues found)                  │
│  - Git commit offer (only if @auditor PASSED)           │
│  - Session saved to global memory                       │
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
│  → Check: AGENTS.md exists?                             │
│  → NOT FOUND: Prompt user                               │
│  User: "init project"                                   │
└─────────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────────┐
│              INIT-PROJECT SKILL (Auto)                   │
│  Creates:                                              │
│  ├─ AGENTS.md              ← AI context (tech stack)    │
│  ├─ docs/current-state.md  ← Project snapshot           │
│  ├─ docs/session-diary.md  ← Session log               │
│  ├─ docs/context/          ← Modular context dir        │
│  ├─ .gitignore                                         │
│  └─ .env.example                                       │
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
│  3. Agent naming prompt (default: codexen)               │
│  4. Files → ~/.config/opencode/                          │
│  5. Restart OpenCode                                   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                      UPDATE                             │
│  1. Load update.md                                     │
│  2. Backup ~/.config/opencode ← backup/                 │
│  3. Update primary agent (preserves name + mode)         │
│  4. Update 24 subagents (with conflict resolution)       │
│  5. Update 17 skills (with conflict resolution)          │
│  6. Merge/preserve opencode.json                        │
│  7. Done!                                               │
└─────────────────────────────────────────────────────────────┘
```

---

### Subagent Routing

```
┌─────────────────────────────────────────────────────────────┐
│              TASK TYPE → SUBAGENT                         │
├─────────────────────────────────────────────────────────────┤
│  Backend API, server logic    → @backend-coder            │
│  Frontend UI, component      → @frontend-coder           │
│  Full-stack, mixed           → @coder                    │
│  Tests                       → @test-coder               │
│  Database schema, query      → @database-expert          │
│  API design, OpenAPI spec    → @api-designer             │
│  DevOps, Docker, CI/CD       → @devops-coder             │
│  Refactor, code smells       → @refactor-expert          │
│  Code review, quality gate   → @auditor                  │
│  Security scan               → @security / @security-auditor│
│  Performance audit           → @performance-auditor       │
│  Style audit                 → @style-auditor             │
│  Planning, breakdown         → @planner                  │
│  Research, analysis          → @research                 │
│  Decision logging            → @decision-log             │
│  Memory, context             → @memory                   │
│  Git, commit, PR            → @git-manager              │
│  Documentation               → @docs-manager             │
│  Fetch live library docs     → @doc-scout                │
│  Business requirements       → @brs-manager              │
│  Software requirements       → @srs-manager              │
│  System design               → @sds-manager              │
└─────────────────────────────────────────────────────────────┘
```

---

## Project Overview

CodeXen is an AI coding assistant for OpenCode that coordinates 24 specialized subagents and 17 skills to handle software development tasks.

## Directory Structure

```
codexen/
├── core/                      # Framework (updated via install/update)
│   ├── agents/                # 24 subagent definitions
│   │   ├── codexen.md         # Primary orchestrator
│   │   ├── backend-coder.md
│   │   ├── frontend-coder.md
│   │   ├── test-coder.md
│   │   ├── auditor.md
│   │   ├── planner.md
│   │   ├── memory.md
│   │   ├── decision-log.md
│   │   ├── git-manager.md
│   │   ├── brs-manager.md
│   │   ├── srs-manager.md
│   │   ├── sds-manager.md
│   │   └── ... (12 more)
│   │
│   └── skills/                # 17 skill modules
│       ├── planner/SKILL.md
│       ├── coder/SKILL.md
│       ├── auditor/SKILL.md
│       ├── memory/SKILL.md
│       ├── security/SKILL.md
│       ├── research/SKILL.md
│       ├── srs/SKILL.md
│       ├── sds/SKILL.md
│       ├── brs/SKILL.md
│       └── ... (8 more)
│
├── docs/                      # Project documentation
│   └── ARCHITECTURE.md        # This file
│
├── templates/                 # Starter templates
│   ├── init-project/          # New project scaffolding
│   ├── setup-profile/         # User profile setup
│   └── global-memory/         # Cross-project memory
│
├── install.md                 # First-time install script
├── update.md                  # Update script
├── TUTORIALS.md               # Full usage guide
├── QUICKSTART.md              # 5-minute quick start
└── VERSION.yaml               # Version tracking
```

## Agent Categories

### Primary Agent
The main orchestrator (default: `codexen`, user-renameable). Handles:
- User interaction
- Mode selection (default/quick/review/debug)
- Subagent routing via routing table
- Workflow orchestration (chain, parallel)

### Subagents (24 total)

| Category | Agents |
|----------|--------|
| **Coders** | backend-coder, frontend-coder, coder, test-coder, refactor-expert, devops-coder |
| **Auditors** | auditor, security-auditor, security, performance-auditor, style-auditor |
| **Planners** | planner, research |
| **Memory** | memory, decision-log |
| **Specs** | brs-manager, srs-manager, sds-manager |
| **Utilities** | git-manager, docs-manager, database-expert, api-designer, doc-scout |

## Skills (17 total)

| Skill | Purpose |
|-------|---------|
| **greeting** | Time-based greetings |
| **orchestration** | Workflow, parallel execution, self-healing |
| **modes** | Operating modes (quick, review, debug) |
| **output** | Output formatting |
| **planner** | Task breakdown with estimation |
| **coder** | Code writing standards |
| **auditor** | Code review checklist |
| **memory** | Session persistence, global diary |
| **security** | OWASP Top 10 scanning |
| **research** | Codebase analysis methodology |
| **decision-log** | Decision format and tracking |
| **brs** | Business requirements templates |
| **srs** | Software requirements templates |
| **sds** | System design templates |
| **init-project** | New project scaffolding |
| **setup-profile** | User profile wizard |
| **switch-config** | OpenCode config switching |

## Key Architecture Decisions

### Permission Model
```
Agent Type        edit   bash
─────────────────────────────
Code writers      allow  allow     (need to create files, run commands)
Spec writers      allow  deny      (write docs, no execution)
Read-only auditors deny  deny      (review only, no changes)
Orchestrator      allow  allow     (full access + skill: allow)
```

### Audit Gate
All commits must pass `@auditor` check first. Enforced in `git-manager.md`.

### Token Optimization
- Modular context loading (only load relevant docs/context/)
- Memory compression (3 tiers, 30-80% savings)
- Efficiency guideline: "Don't call 3 agents if 1 can complete"
- Parallel execution reduces roundtrips

## Version Information

- **Version**: See `VERSION.yaml`
- **Changelog**: See `install.md` and `update.md`
- **Install**: See `QUICKSTART.md`
