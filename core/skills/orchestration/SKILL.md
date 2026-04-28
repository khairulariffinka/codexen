---
name: orchestration
description: Main orchestration logic with self-healing, parallel execution, and pre-commit validation
---

# Orchestration Skill

The central logic for coordinating agents, managing task flows, and ensuring system stability through self-healing protocols.

## Task Lifecycle

1. **Plan Generation**: Invoke `@planner` to break down user requests based on BRS/SDS.
2. **Context Loading**: Ensure relevant modular context (`docs/context/`) is loaded for the assigned agent.
3. **Execution**: Distribute tasks to specialized agents (e.g., `backend-coder`, `frontend-coder`).
4. **Validation**: Invoke `@auditor` for code review and compliance check.
5. **Commit**: Invoke `@git-manager` ONLY if Auditor status is `✅ PASSED`.

## Self-Healing & Error Recovery

### 1. Agent Failure Continuum (Progressive)

When ANY agent fails (timeout, error, unexpected output):

| Attempt | Action |
|---------|--------|
| **1st** | Retry same agent with specific error context |
| **2nd** | Call `@research` + `@doc-scout` to validate approach |
| **3rd** | Switch model to high-reasoning tier for surgical fix |
| **Final** | Stop, collect Failure Report, present to user |

### 2. Auditor Failure Loop

If `@auditor` returns `❌ FAILED`:

```
FAILED → Retry agent with error logs → FAILED → 
Call @research + @doc-scout for pattern validation → FAILED → 
High-reasoning fix → FAILED → 
Failure Report → USER
```

### 3. Timeout Handling

If an agent takes too long or produces no output:

- **Wait threshold**: 30 seconds for simple tasks, 2 minutes for complex
- **First timeout**: Retry with `[timeout]` prefix to force immediate response
- **Second timeout**: Break task into smaller chunks via `@planner`
- **Persistent timeout**: Report as infrastructure issue

### 4. Partial Parallel Failure

When parallel agents run and ONE fails:

```
backend-coder ✅  frontend-coder ❌  test-coder ✅

Action:
1. Accept completed work (backend-coder, test-coder)
2. Isolate failed task (frontend-coder)
3. Retry failed agent only (not the whole group)
4. If retry fails → check dependency chain
5. If other agents depend on failed task → block them
6. Report partial completion to user
```

### 5. Routing Failure

If no subagent matches the task:

```
1. Check if task is a combination (e.g., "full-stack" → @coder)
2. Try @coder as generic fallback (covers any framework)
3. If still no match → ask user for clarification
4. Log unknown task type for future pattern addition
```

### 6. Context Loading Failure

If `docs/context/` files are missing:

```
1. Check if init-project has been run (AGENTS.md exists?)
2. If not → prompt: "Project not initialized. Run 'init project' first?"
3. If yes but context missing → use AGENTS.md as fallback
4. Log missing context paths for user to create
```

### 7. Permission Denied Recovery

If an agent lacks permission for a critical action:

```
1. Check if alternative agent has the required permission
   e.g., @security-auditor (bash: deny) → @security (bash: allow)
2. Route to alternative agent with context
3. If no alternative → report permission gap
```

### 8. Git Operation Failure

If `@git-manager` commit fails (pre-hook rejection, merge conflict):

```
1. Parse error output from git
2. If pre-hook → fix issues, retry commit
3. If merge conflict → call user to resolve manually
4. If auth error → check git remote config
```

### 9. Failure Report Format

When all recovery attempts are exhausted:

```markdown
## Failure Report

**Task:** [original task description]
**Failed Agent:** @agent-name
**Attempts:** 3
**Root Cause:** [error message summary]

**Partial Work:**
- ✅ Completed: [files/tasks done]
- ❌ Failed: [files/tasks failed]
- ⏭️ Skipped: [dependent tasks not started]

**Recovery Actions Taken:**
1. Retry with context → FAILED
2. Research pattern validation → FAILED
3. High-reasoning fix → FAILED

**Suggested Next Steps:**
- [Recommendation 1]
- [Recommendation 2]

**Decision Logged**: DEC-YYYY-NNN (failure analysis)
```

## Pre-Commit Validation

Before allowing any `git commit` or `git push`:

- [ ] Auditor status must be `✅ PASSED`.
- [ ] Test status from `@test-coder` must be `✅ 100% SUCCESS`.
- [ ] No "TODO" or "FIXME" comments in files ready for production.

## Orchestration Modes

| Mode         | Behavior                                                          |
| ------------ | ----------------------------------------------------------------- |
| **Quick**    | Send directly to Coder, skip Audit (only for minor tasks). |
| **Standard** | Coder -> Auditor -> Git.                                          |
| **Strict**   | Coder -> Test-Coder -> Auditor -> Security-Auditor -> Git.        |

## Guidelines

- **Efficiency**: Don't call 3 agents if 1 agent can complete.
- **Traceability**: Every orchestrator move must be recorded in `current-state.md`.
- **Safety First**: If decision has major impact on UI or core logic, must ask User.
