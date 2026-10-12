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
│  HANDOFFS (## Handoff block → codexen dispatches):      │
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
│  5. Update 19 skills (with conflict resolution)          │
│  6. Update 13 commands + context-monitor plugin          │
│  7. Merge/preserve opencode.json                        │
│  8. Done!                                               │
└─────────────────────────────────────────────────────────────┘
```

Target dirs under `~/.config/opencode/`: `agents/`, `skills/`, `commands/`, `plugins/` (all plural), plus `opencode.json`.

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
│  Checkpoint (context high)   → @checkpoint-writer        │
└─────────────────────────────────────────────────────────────┘
```

---

## Project Overview

CodeXen is an AI coding assistant for OpenCode with 25 agents (1 primary `codexen` + 24 specialized subagents), 19 skills, 13 slash commands, and a context-monitor plugin to handle software development tasks.

## Directory Structure

```
codexen/
├── core/                      # Framework (updated via install/update)
│   ├── agents/                # 25 agent definitions (1 primary + 24 subagents)
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
│   │   ├── checkpoint-writer.md
│   │   └── ... (12 more)
│   │
│   ├── skills/                # 19 skill modules
│   │   ├── planner/SKILL.md
│   │   ├── coder/SKILL.md
│   │   ├── auditor/SKILL.md
│   │   ├── memory/SKILL.md
│   │   ├── security/SKILL.md
│   │   ├── research/SKILL.md
│   │   ├── srs/SKILL.md
│   │   ├── sds/SKILL.md
│   │   ├── brs/SKILL.md
│   │   └── ... (10 more)
│   │
│   ├── commands/              # 13 slash commands (/audit, /brs, /commit,
│   │                          #   /context, /docker, /lint, /plan, /refactor,
│   │                          #   /review, /sds, /srs, /test)
│   │
│   ├── .opencode/plugins/
│   │   └── context-monitor.ts # Context usage monitor (OpenCode v1 + v2)
│   │
│   └── opencode.json          # Agent modes + permissions (no `instructions` key)
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
- Dispatching subagent `## Handoff` requests
- Calling `check_context` and dispatching `@checkpoint-writer`

### Subagents (24 total)

| Category | Agents |
|----------|--------|
| **Coders** | backend-coder, frontend-coder, coder, test-coder, refactor-expert, devops-coder |
| **Auditors** | auditor, security-auditor, security, performance-auditor, style-auditor |
| **Planners** | planner, research |
| **Memory** | memory, decision-log, checkpoint-writer |
| **Specs** | brs-manager, srs-manager, sds-manager |
| **Utilities** | git-manager, docs-manager, database-expert, api-designer, doc-scout |

## Skills (19 total)

| Skill | Purpose |
|-------|---------|
| **auditor** | Review code quality, security, and best practices (any framework/language) |
| **brs** | Business Requirement Specification standards, templates, and guidelines (multilingual) |
| **coder** | Write clean code based on planner.md task breakdown (any framework/language) |
| **compress** | Ultra-compressed communication mode (lite/full/ultra), ~75% fewer tokens |
| **compress-file** | Compress memory files (AGENTS.md, planner.md, etc.) into terse format; backup as FILE.original.md |
| **decision-log** | Decision logging with rationale and impacted-file tracking |
| **greeting** | Time-based greetings for CodeXen |
| **init-project** | Initialize new project with Modular Memory, Decision-Log, and Current State |
| **memory** | Project memory: modular context, decision syncing, global Work Diary |
| **model-picker** | Interactive model selection based on task type, budget, and quality needs |
| **modes** | Operating modes for different workflows |
| **orchestration** | Orchestration logic with self-healing, parallel execution, pre-commit validation |
| **output** | Standardized output formats for CodeXen |
| **planner** | Task planning with estimation, dependency tracking, and decision alignment |
| **research** | Analyze codebase and gather context before planning |
| **sds** | System Design Specification: architecture, ERD generation, API contracts |
| **security** | Security vulnerability scanner: OWASP Top 10, secrets, detailed reports |
| **setup-profile** | Interactive wizard to configure user profile for global memory |
| **srs** | Software Requirements Specification: maps business needs to functional requirements |

## Slash Commands (12 total)

Defined in `core/commands/*.md`, installed to `~/.config/opencode/commands/`:
`/audit`, `/brs`, `/commit`, `/context`, `/docker`, `/lint`, `/plan`, `/refactor`, `/review`, `/sds`, `/srs`, `/test`.

## Orchestration Model (Handoffs)

OpenCode subagents cannot start other subagents (`subagent_depth = 1`), so only the primary agent dispatches work:

1. `codexen` (primary) dispatches a subagent.
2. The subagent finishes its task and ends its reply with a `## Handoff` block:
   ```
   ## Handoff
   - @test-coder: write tests for the new auth endpoints
   - @auditor: review changed files
   ```
   (or `- none` when nothing follows)
3. `codexen` reads the block and dispatches the listed agents (in parallel or chained as needed).

## Context Monitor Plugin

`core/.opencode/plugins/context-monitor.ts` (installed to `~/.config/opencode/plugins/`) is one file that works on OpenCode v1 (>= 1.18.29) and v2.

- Tracks context-window usage per session and alerts at **70 / 80 / 90 / 95%**.
- v1: toast + log; v2: log only.
- Provides the custom tool `check_context` (current tokens, percentage, cost estimate).
- The plugin cannot dispatch agents. The `codexen` agent calls `check_context` and dispatches `@checkpoint-writer` itself (also available via `/context`).

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

### Single Memory Entry Point
`core/opencode.json` has no `instructions` key. `AGENTS.md` (auto-loaded by OpenCode) is the single entry point for project memory.

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
