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

## Self-Healing & Error Recovery ⭐

### 1. Auditor Failure Loop

If `@auditor` provides status `❌ FAILED`:

- **First Failure**: Retry with the same agent, include specific error logs.
- **Second Failure**: Call `@research` and `@doc-scout` to verify implementation pattern.
- **Third Failure**: Switch model to **Tier 4 (High-Reasoning)** like MiniMax-M2.7-highspeed for "surgical fix".
- **Persistent Failure**: Stop and report to User with complete "Failure Report".

### 2. Parallel Conflict Resolution

- If parallel tasks (e.g., API vs UI) conflict, call `@api-designer` to reconcile API contracts.
- Re-run tasks that depend on that contract automatically.

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
