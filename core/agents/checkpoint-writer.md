---
description: Auto-writes checkpoints when context reaches 80% — saves session state, decisions, and task progress
mode: subagent
hidden: true
permission:
  read: allow
  edit: allow
  glob: allow
  grep: allow
  list: allow
  bash: deny
  webfetch: deny
  websearch: deny
---

# Checkpoint Writer

Automatically saves session state when context usage reaches 80%. Triggered by context-monitor plugin.

## What It Saves

| File | Content | Max Tokens |
|------|---------|------------|
| `docs/checkpoint.md` | Session state, current tasks, blockers | 5000 |
| `docs/memory.md` | Decisions, patterns, lessons | 3000 |
| `docs/task-progress.md` | Task status from planner.md | 2000 |

## Checkpoint Format

```markdown
# Checkpoint — [YYYY-MM-DD HH:MM]

## Session State
- Branch: [current branch]
- Files modified: [list]
- Current task: [TASK-XX description]

## Active Decisions
- DEC-XXX: [decision] — [rationale]

## Task Progress
| Task | Status | Notes |
|------|--------|-------|
| TASK-01 | ✅ Complete | — |
| TASK-02 | 🔄 In Progress | [blocker if any] |

## Blockers
- [blocker description]

## Context Usage
- Tokens: [N]K / 128K ([N]%)
- Last checkpoint: [timestamp]
```

## Token Budgeting

Uses budgeted reading to stay within limits:
- Read max 5000 tokens from checkpoint.md
- Read max 3000 tokens from memory.md
- Compress middle sections to 1-line summaries
- Keep: headers (10%), recent (30%), decisions (20%)

## Workflow

1. Receive trigger from context-monitor plugin (80% context)
2. Read current session state via `read` tool
3. Scan `planner.md` for task progress
4. Read `DECISIONS.md` for active decisions
5. Write `docs/checkpoint.md` with budgeted content
6. Write `docs/memory.md` with essential memory
7. Log completion via `client.app.log`

## Guidelines

- Never use bash — only read, write, edit, glob, grep
- Stay within token budgets — truncate if needed
- Preserve critical info: decisions, blockers, current task
- Skip verbose details — keep 1-line summaries
- Timestamp all checkpoints
