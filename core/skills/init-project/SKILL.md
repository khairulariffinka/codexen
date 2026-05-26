---
name: init-project
description: Initialize new project with Modular Memory, Decision-Log, and Current State - integrates with CodeXen
license: MIT
compatibility: opencode
metadata:
  audience: agents
  workflow: onboarding
---

# Init Project Skill (Modular & State Sync)

Initialize a new project with the CodeXen modular memory system.

## When to Use

- User says: "init project", "new project", "setup project"
- Starting a new project or adding CodeXen to an existing one
- No `AGENTS.md` file exists in the project root

---

## Workflow

1. Detect project name from the current directory name.
2. Detect the current date.
3. Create folder structure.
4. Generate all required files.
5. Initialize git if needed.
6. Confirm initialization is complete.

---

## Step 1: Create Folder Structure

Create the following directories if they do not exist:

- `docs/context/`
- `docs/decisions/`

---

## Step 2: Generate AGENTS.md (Project Index)

Write `AGENTS.md` in the project root with this content, replacing placeholders:

```markdown
# Project: {PROJECT_NAME}

## Tech Stack Index
- **Frontend:** Refer to `docs/context/frontend.md`
- **Backend:** Refer to `docs/context/backend.md`
- **Database:** Refer to `docs/context/database.md`

## Active Decisions
- Refer to `DECISIONS.md` for architectural history.

---
**Last Updated:** {CURRENT_DATE}
**Status:** INITIALIZED
```

---

## Step 3: Generate docs/current-state.md (Dashboard)

Write `docs/current-state.md` with this content:

```markdown
# {PROJECT_NAME} - Current State

> **Last Updated:** {CURRENT_DATE}
> **Status:** IN PROGRESS

---

## Snapshot Status
| Component | Status | Context Reference |
| :--- | :--- | :--- |
| **Backend** | Initializing | `docs/context/backend.md` |
| **Frontend** | Initializing | `docs/context/frontend.md` |
| **Database** | Initializing | `docs/context/database.md` |

---

## Implemented Features
- [x] Initial Project Setup (Modular Structure) [Ref: DEC-{DATE}-001]
- [ ] Base Infrastructure (Pending)

---

## Current Environment
- **Branch:** main
- **Last Commit:** None
- **Active Decision:** DEC-{DATE}-001

---

This file is automatically updated by agents at the end of each session.
```

---

## Step 4: Generate DECISIONS.md (First Decision Log)

Write `DECISIONS.md` in the project root:

```markdown
# Project Decisions

## DEC-{DATE}-001: Initial Project Setup
**Date:** {CURRENT_DATE}
**Status:** ACTIVE

### Context
Initialization of a new project with Modular Context and Current State tracking.

### Impacted Files
- `AGENTS.md`
- `docs/current-state.md`
- `docs/context/`
```

---

## Step 5: Generate docs/AI-AGENT-PROTOCOL.md

Write `docs/AI-AGENT-PROTOCOL.md`:

```markdown
# AI Agent Documentation Protocol (Modular Version)

Every session MUST:

1. **Read Index FIRST**: Start by reading `AGENTS.md` and `docs/current-state.md`.
2. **Load Specific Context**: Only read `docs/context/[module].md` relevant to your task.
3. **Check Decisions**: Before implementing, verify `DECISIONS.md` to avoid using deprecated logic.

Every session end MUST:

1. **Update Current State**: Refresh the snapshot in `docs/current-state.md`.
2. **Log Decisions**: Record any technical choices in `DECISIONS.md` with "Impacted Files".
3. **Mark Progress**: Update `planner.md` status.
4. **Project Log**: Add entry to `docs/session-diary.md`.
5. **Global Sync**: Sync session data to global work-diary.
```

---

## Step 6: Generate planner.md

Write `planner.md` in the project root:

```markdown
# Project Planner
- [ ] **TASK-001**: Define Tech Stack in `docs/context/` | @user
- [ ] **TASK-002**: Generate BRS/SRS | @brs-manager
```

---

## Step 7: Create Context Placeholders

Create empty placeholder files:
- `docs/context/backend.md`
- `docs/context/frontend.md`
- `docs/context/database.md`

Each placeholder should contain:

```markdown
# {Module Name} Context

> Auto-generated placeholder. Fill in during tech stack setup.

## Tech Stack
[To be defined]

## Conventions
[To be defined]

## Patterns
[To be defined]
```

---

## Step 8: Initialize Git (if needed)

Check if a `.git` directory exists in the project root. If not, run `git init`.

---

## Placeholder Reference

| Placeholder | Value |
|-------------|-------|
| `{PROJECT_NAME}` | Use the current directory name (`basename`) |
| `{CURRENT_DATE}` | Use the current date in `YYYY-MM-DD` format |
| `{DATE}` | Use the current date in `YYYYMMDD` format for decision IDs |

---

## Confirmation

After completing all steps, confirm to user:

```
MODULAR PROJECT, CURRENT STATE & PROTOCOL INITIALIZED!

Created:
  - AGENTS.md (project index)
  - DECISIONS.md (decision log)
  - planner.md (task planner)
  - docs/current-state.md (dashboard)
  - docs/AI-AGENT-PROTOCOL.md (protocol)
  - docs/context/backend.md (placeholder)
  - docs/context/frontend.md (placeholder)
  - docs/context/database.md (placeholder)

Next steps:
  1. Fill in tech stack details in docs/context/ files
  2. Start coding or run "create BRS" for formal requirements
```