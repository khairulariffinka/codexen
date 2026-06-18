---
name: orchestration
description: Main orchestration logic with self-healing, parallel execution, and pre-commit validation
license: MIT
compatibility: opencode
metadata:
  audience: agents
  workflow: orchestration
---

# Orchestration Skill

The central logic for coordinating agents, managing task flows, and ensuring system stability through self-healing protocols.

**IMPORTANT:** All mandatory steps MUST run before/after tasks. No exceptions.

---

## Task Lifecycle (Mandatory)

Every task follows this lifecycle. Skipping any step is a violation.

### Pre-Task (BEFORE agent starts)

| Step | Action | Mandatory |
|------|--------|-----------|
| 1 | Run `@memory smart-recall [task]` | ✅ YES |
| 2 | Run `@memory score-lessons` | ✅ YES |
| 3 | Check `agent-performance.md` for best agent | ✅ YES |
| 4 | Share relevant lessons with assigned agent | ✅ YES |
| 5 | Check if `/goal` is active → set checklist | ✅ YES |
| 6 | Invoke `@planner` for task breakdown | ✅ YES |
| 7 | Load modular context (`docs/context/`) | ✅ YES |

### During Execution

| Step | Action | Mandatory |
|------|--------|-----------|
| 8 | Dispatch to specialized agents | ✅ YES |
| 9 | Track agent performance (success/fail/duration) | ✅ YES |
| 10 | Auto-save checkpoint if context > 80% | ✅ YES |

### Post-Task (BEFORE agent stops)

| Step | Action | Mandatory |
|------|--------|-----------|
| 11 | Run `@auditor` for code review | ✅ YES |
| 12 | Run `@test-coder` for test verification | ✅ YES |
| 13 | Check `/goal` evaluation (if active) | ✅ YES |
| 14 | Update `agent-performance.md` with result | ✅ YES |
| 15 | Run `@memory dream` (if 10+ sessions) | ✅ YES |
| 16 | Run `@memory checkpoint save` (if context > 80%) | ✅ YES |
| 17 | Invoke `@git-manager` ONLY if all checks PASS | ✅ YES |

---

## Mandatory Auto-Check Enforcement

### What Happens If Skipped

```
IF agent skips mandatory step:
  → Log violation to docs/lessons.md
  → Add "SKIPPED MANDATORY STEP" to failure report
  → Force re-run of skipped step before proceeding
```

### Pre-Task Enforcement

```
BEFORE any agent dispatch:
  1. @memory smart-recall [task] → MUST complete
  2. @memory score-lessons → MUST complete
  3. agent-performance check → MUST complete
  4. Share lessons with agent → MUST confirm received
  5. /goal check → MUST set if not active

IF any step fails:
  → STOP task
  → Log to lessons.md
  → Report to user
```

### Post-Task Enforcement

```
BEFORE agent says "done":
  1. @auditor → MUST return ✅ PASSED
  2. @test-coder → MUST return ✅ PASSED
  3. /goal evaluation → MUST pass (if active)
  4. agent-performance → MUST log result
  5. @memory dream → MUST run (if 10+ sessions)
  6. @memory checkpoint save → MUST run (if context > 80%)

IF any step fails:
  → Agent CANNOT stop
  → Return to agent with gaps
  → Re-run failed step
```

## Plugin-Based Context Monitoring

Context monitoring is handled by `core/.opencode/plugin/context-monitor.ts`. This plugin automatically tracks token usage and triggers actions at predefined thresholds.

### How It Works

1. **Event-driven:** Monitors `message.updated` events in real-time
2. **Token tracking:** Counts input, output, reasoning, cache tokens
3. **Dynamic limits:** Reads `model.limit.context` from each message
4. **Auto-trigger:** Fires actions when thresholds are crossed

### Threshold Actions

| Threshold | Action | What Happens |
|-----------|--------|--------------|
| **70%** | `warn` | Log warning message |
| **80%** | `checkpoint` | Trigger `@checkpoint-writer` agent |
| **90%** | `compress` | Auto-compress low-priority content |
| **95%** | `critical` | Log error, prompt user to intervene |

### Plugin → Agent Handoff

```
Context Monitor Plugin
    ↓ (at 80%)
Logs: "Context 80% — checkpoint triggered"
    ↓
Orchestration detects log event
    ↓
Dispatches @checkpoint-writer agent
    ↓
@checkpoint-writer saves:
  - docs/checkpoint.md (5K tokens max)
  - docs/memory.md (3K tokens max)
  - docs/task-progress.md (2K tokens max)
```

### Manual Context Check

Use the `check_context` tool or `/context` command:
```
/check context
→ Shows: tokens, percentage, cost estimate
→ Optional: /context detailed (threshold breakdown)
```

### Integration with Task Lifecycle

| Lifecycle Step | Plugin Integration |
|----------------|-------------------|
| **Pre-Task (Step 1-7)** | Plugin runs in background, no blocking |
| **During (Step 10)** | Plugin auto-checkpoints at 80% |
| **Post-Task (Step 16)** | Plugin confirms checkpoint saved |

---

## Spec Change Propagation

When a BRS/SRS/SDS document changes, propagate updates through the chain:

```
BRS updated (new version or CR-XXX)
  ↓
@brs-manager: bump version, update changelog
  ↓
@srs-manager: sync SRS, identify affected FRs, bump version
  ↓
@sds-manager: sync SDS, update ERD/API/architecture, bump version
  ↓
@planner: recalculate estimates, adjust tasks, update dependencies
  ↓
@memory: log spec change in session diary
  ↓
@decision-log: log CR decision if applicable
```

### Change Request Flow

```
User: "Add TikTok integration"

1. @brs-manager → Create CR-001-tiktok.md
   - Impact analysis (timeline, cost, risk)
   - Updated BRS → v1.1
   
2. @srs-manager → Update SRS
   - Add FR for TikTok integration
   - Updated SRS → v1.1
   
3. @sds-manager → Update SDS
   - Add TikTok API contract
   - Updated SDS → v1.1
   
4. @planner → Replan
   - Add tasks for TikTok feature
   - Adjust estimates and timeline
   
5. Execute new tasks → code, test, audit, commit
```

## Self-Healing & Error Recovery

### 0. Guardrails (Always Active)

**Principle:** All sensitive operations require user confirmation. Exception: user has given explicit permission in current session.

| Guardrail | Scope | Action |
|-----------|-------|--------|
| **Circuit Breaker** | 3 failures same agent/task | Halt all retries, generate Failure Report |
| **Rate Limit** | 5 subagent dispatches per msg | Batch remaining, execute sequentially |
| **Parallel Cap** | 3 concurrent agents max | Queue overflow agents for next batch |
| **Project Files Gate** | core/*, scripts/*, templates/* | ❌ Edit freely (no confirmation) |
| **User Files Gate** | ~/.config/opencode/* | ✅ Ask before overwrite |
| **Delete Gate** | Any file/branch deletion | ✅ Ask before delete |
| **Git Push Gate** | Any `git push` command | ✅ Ask: "Push ke GitHub sekarang, bos?" |
| **Git Commit Gate** | Any `git commit` command | ✅ Show summary + ask permission |
| **Install Gate** | Package install/remove | ✅ Ask before install |
| **Network Gate** | External API calls | ✅ Ask before call (except localhost) |

**What needs confirmation:**
| Operation | Confirm? |
|-----------|----------|
| Edit new file | ❌ No |
| Edit project file (core/*) | ❌ No |
| Edit user's personal file | ✅ Yes |
| Delete any file | ✅ Yes |
| Git push | ✅ Yes |
| Git commit | ✅ Yes |
| Install package | ✅ Yes |
| External API call | ✅ Yes |

### Session Permission

User can pre-authorize actions for the session:

```
User: "auto-push allowed"
→ All subsequent git push will skip confirmation

User: "auto-commit allowed"
→ All subsequent git commit will skip confirmation

User: "revoke auto-push"
→ Resume asking for confirmation
```

**Rules:**
1. Default: ALWAYS ask for sensitive operations
2. Exception: User said "allowed" / "proceed" / "yes" in this session
3. Reset: New session = fresh permission (ask again)
4. Scope: Permission only applies to current session

### Quick Reference

| Operation | Confirm? |
|-----------|----------|
| Edit project file (core/*) | ❌ |
| Edit user's file (~/.config/opencode/*) | ✅ |
| Delete any file/branch | ✅ |
| Git push | ✅ |
| Git commit | ✅ |
| Install package | ✅ |
| External API call | ✅ |

### 1. Agent Failure Continuum (Progressive)

When ANY agent fails (timeout, error, unexpected output):

| Attempt | Action |
|---------|--------|
| **1st** | Retry same agent with specific error context |
| **2nd** | Call `@research` + `@doc-scout` to validate approach |
| **3rd** | ❌ Circuit Breaker trips — STOP all retries, AUTO-log lesson |
| **Final** | Generate Failure Report + auto-save to lessons.md, present to user |

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

### 9. Post-Mortem Feedback (Lessons Learned)

After ANY task completion or failure:

```
IF task FAILED after retries:
  → Log lesson to docs/lessons.md via @memory
  → Include: agent, symptom, root cause, fix

IF task SUCCEEDED but had notable challenges:
  → Log lesson if the approach was non-obvious
  → Include: what made it tricky, how it was solved

IF common mistake detected:
  → Log lesson so same agent doesn't repeat
  → Tag for easy search (#auth, #database, etc.)
```

**Before starting a NEW task of the same type:**
```
1. @memory, show lessons about [topic]
2. If relevant lessons exist → share with agent as context
3. Agent adjusts approach based on past mistakes
```

### 10. Auto-Lesson Logging (Self-Learning)

When circuit breaker trips (agent fails 3x), auto-log to lessons.md:

```
@memory, lesson: [Agent] [task] failed after 3 retries
  Root Cause: [from failure analysis]
  Fix Applied: [from last attempt]
  Tags: #[agent-name] #common-mistake #auto-logged
```

This happens automatically at step "Final" — no manual action needed.

### 11. Auto-Update Check (Self-Updating)

When a session starts, check if CodeXen has updates available:

```
1. Check: git remote update 2>/dev/null
2. Compare: git rev-list HEAD...origin/main --count
3. If behind:
   "📦 CodeXen update available ([N] commits behind).
    Auto-update? [y/N]"
   → If YES: git pull → re-run install
   → If NO: "You can update later via 'load update.md'"
4. If up to date: "✅ CodeXen is up to date"
```

### 12. Failure Report Format

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

---

## Goal/Stop Condition

Prevent premature agent stop by setting explicit stopping conditions.

### Problem

Without a goal, agents may stop early:
- Agent says "Done!" but tests not written
- Agent completes 80% and claims success
- No way to verify if task is truly complete

### Solution

User sets a goal, agent must satisfy it before stopping.

### Usage

```
User: /goal "All API endpoints have tests and pass security audit"
```

Or inline:

```
Build user auth with goal: "JWT working, tests passing, no security issues"
```

### Goal Evaluation

When agent tries to stop, run evaluation:

```
[GOAL EVALUATION]

Goal: "All API endpoints have tests and pass security audit"

Checklist:
├─ [✅] API endpoints created (5/5)
├─ [✅] Tests written (5/5)
├─ [✅] Tests passing (100%)
├─ [❌] Security audit passed (0/1 — not run yet)
└─ [❌] No TODO/FIXME in code (found 2)

Verdict: ❌ NOT COMPLETE
Missing: security audit, cleanup TODOs

Action: Continue working...
```

### Judge Model

For complex goals, use separate evaluation step:

```
1. Agent claims: "Task complete"
2. Orchestrator runs: @auditor + @test-coder
3. Judge evaluates: Does output match goal?
4. If NO → return to agent with gaps
5. If YES → allow stop, log success
```

### Goal Format

```
/goal "[specific, measurable condition]"

Examples:
/goal "All tests pass with >80% coverage"
/goal "No security vulnerabilities found"
/goal "API handles 100 concurrent users"
/goal "Code follows PSR-12 style"
```

### Auto-Stop Prevention

```
IF agent says "done" OR "complete" OR "finished":
  1. Check if /goal is active
  2. If YES → run evaluation
  3. If evaluation FAILS → return to agent with gaps
  4. If evaluation PASSES → allow stop
  5. If NO goal set → normal stop (no evaluation)
```

### Goal Storage

Store active goal in `~/.config/opencode/global-memory/current-goal.md`:

```markdown
# Active Goal

**Set:** 2026-06-16 14:30
**Goal:** All API endpoints have tests and pass security audit
**Status:** In Progress

## Checklist
- [ ] API endpoints created
- [ ] Tests written
- [ ] Tests passing
- [ ] Security audit passed
- [ ] No TODO/FIXME

## Evaluation Log
- 14:35 — ❌ Failed (tests not run)
- 14:45 — ❌ Failed (2 security issues)
- 14:55 — ✅ Passed
```

### Clearing Goal

```
User: /goal clear
→ Clears active goal, normal stop behavior resumes
```

---

## Agent Performance Tracking

Track success/failure rate per agent to make intelligent routing decisions.

### Data Collection

After every agent dispatch, log to `~/.config/opencode/global-memory/agent-performance.md`:

```markdown
## Agent: @backend-coder

| Date | Task | Status | Duration | Error |
|------|------|--------|----------|-------|
| 2026-06-16 | Create API endpoint | ✅ SUCCESS | 45s | - |
| 2026-06-15 | Fix auth bug | ❌ FAILED | 120s | timeout |
| 2026-06-14 | Setup database | ✅ SUCCESS | 90s | - |

**Stats:**
- Total: 15 tasks
- Success: 12 (80%)
- Failed: 3 (20%)
- Avg Duration: 65s
- Common Errors: timeout (2x), permission (1x)
```

### Performance Metrics

| Metric | Calculation | Use Case |
|--------|-------------|----------|
| **Success Rate** | success / total × 100 | Route to highest success rate agent |
| **Avg Duration** | total duration / total tasks | Estimate task time |
| **Error Pattern** | group by error type | Identify systematic issues |
| **Trend** | last 7 days vs previous 7 days | Detect improvement/regression |

### Smart Routing

Use performance data to influence agent selection:

```
IF multiple agents can handle same task:
  1. Filter by success rate > 70%
  2. Sort by success rate (highest first)
  3. Tie-break by avg duration (lowest first)
  4. If all agents < 70% success → warn user, suggest @research first

IF agent fails 3x same task type:
  1. Auto-switch to next highest success rate agent
  2. Log routing decision to lessons.md
  3. Notify user: "Switched to @agent-name (better track record)"
```

### Performance Report

Command: `@memory agent-report [agent-name]`

Output:
```
[AGENT PERFORMANCE]

Agent: @backend-coder
Period: Last 30 days

Metrics:
├─ Success Rate: 85% (17/20 tasks)
├─ Avg Duration: 52s
├─ Trend: ↑ Improving (+5% from last week)
└─ Best Category: REST APIs (95% success)

Weak Areas:
├─ GraphQL: 60% success (3/5 tasks)
└─ Common Error: timeout on complex queries

Recommendation: Use @backend-coder for REST, consider @coder for GraphQL
```

### Data Storage

```
~/.config/opencode/global-memory/
  agent-performance.md      # All agent stats
  agent-performance/
    @backend-coder.md       # Individual agent history
    @frontend-coder.md
    @test-coder.md
    ...
```

### Integration with Orchestration

Before dispatching any agent:
1. Check `agent-performance.md` for success rate
2. If success rate < 50% → suggest alternative agent
3. If success rate < 30% → block dispatch, require user confirmation
4. Update stats after task completion (success or failure)
