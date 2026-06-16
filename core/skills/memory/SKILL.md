---
name: memory
description: Managed project memory - handles modular context, decision syncing, and global diary management using the standard Work Diary format
license: MIT
compatibility: opencode
metadata:
  audience: agents
  workflow: memory
---

# Memory Skill

Manages persistent project context and global knowledge preservation.

## Primary Functions

| Function | Description |
|----------|-------------|
| **READ** | Selective loading of AGENTS.md, current-state.md, and specific module context. |
| **UPDATE** | Marking planner.md progress, syncing decisions. |
| **SAVE** | Local session diary + global work diary sync. |
| **RECALL** | Auto-suggest relevant lessons based on task context. |
| **SCORE** | Rank lessons by frequency and severity. |
| **DREAM** | Extract persistent knowledge from session traces. |
| **DISTILL** | Package repeated workflows into reusable skills. |
| **CHECKPOINT** | Auto-save session state when context nears limit. |

---

## Commands

### @memory read [module]

Load project context for the current task.

**Steps:**
1. Read `AGENTS.md` to identify the tech stack and project phase.
2. Read `docs/current-state.md` for the latest project snapshot.
3. If a module is specified (e.g., `backend`, `frontend`, `database`), read `docs/context/{module}.md` for that specific context.
4. Present a summary of loaded context to the user.

**Output format:**
```
[MEMORY LOADED]

Project: [name]
Tech Stack: [detected stack]

Active Decisions:
- DEC-XXX: [decision summary]

Patterns Found:
1. [Pattern name] (documented)
2. [Pattern name] (documented)

Similar Past Work:
- Session [date]: [topic]

Ready to assist!
```

---

### @memory complete TASK-ID

Mark a task as complete in planner.md.

**Steps:**
1. Open `planner.md`.
2. Find the task line containing `TASK-ID`.
3. Change `[ ]` to `[x]` for that task.
4. Confirm to user: `Task TASK-ID marked complete in planner.md`.

---

### @memory save

Save the current session to local and global memory.

**Steps:**

1. **Write session summary to global RAM:**
   - Create directory `~/.config/opencode/global-memory/` if it does not exist.
   - Write session summary to `~/.config/opencode/global-memory/current-session.md` with:
     - Tasks completed
     - Decisions made
     - Files changed
     - Session notes

2. **Append to local project diary:**
   - Create directory `docs/` if it does not exist.
   - Append session entry to `docs/session-diary.md` with:
     - Date and time
     - Project name (use directory name)
     - Status: Auto-saved via memory skill

3. **Append to global work diary:**
   - Target file: `~/.config/opencode/global-memory/work-diary/diary-YYYY-MM.md` (use current year-month).
   - If the file does not exist, create it with a header: `# Work Diary - YYYY-MM` followed by a separator.
   - Append the session summary from `current-session.md` under a dated heading.
   - Include: date, time, project name, and full session summary.

4. **Clear global RAM:**
   - After successful save, clear the contents of `~/.config/opencode/global-memory/current-session.md` (write empty or just the template header).

5. **Refresh project state:**
   - Update `docs/current-state.md` with the latest progress snapshot.

6. **Auto-archive if diary exceeds 1000 lines:**
   - If `diary-YYYY-MM.md` exceeds 1000 lines, move it to `~/.config/opencode/global-memory/work-diary/archive/diary-YYYY-MM-timestamp.md`.

7. **Confirm to user:**
   ```
   Memory saved (local + global).
   ```

---

### @memory show lessons about [topic]

Search past lessons for a given topic.

**Steps:**
1. Read `docs/lessons.md` (project-level) if it exists.
2. Read `~/.config/opencode/global-memory/lessons.md` (global) if it exists.
3. Search both files for lines matching the topic keyword or `#tag`.
4. Present matching lessons with date, agent, symptom, root cause, and fix.

**MANDATORY:** Agents MUST run this before starting any task. If no lessons found, proceed normally. If lessons are ignored, the agent must explain why.

---

### @memory smart-recall [task-description]

Auto-suggest relevant lessons based on task context (no manual topic needed).

**Steps:**
1. Parse the task description for keywords:
   - Agent names (@backend-coder, @frontend-coder, etc.)
   - Topic keywords (auth, database, API, deployment, etc.)
   - Error patterns (timeout, permission, failed, etc.)
2. Read `docs/lessons.md` (project-level).
3. Read `~/.config/opencode/global-memory/lessons.md` (global).
4. Match lessons using keyword scoring:
   - Exact keyword match: +3 points
   - Related tag match: +2 points
   - Partial keyword match: +1 point
5. Sort by score (highest first).
6. Present top 5 lessons with relevance score.

**Output format:**
```
[SMART RECALL]

Task: [task description]
Keywords detected: [keyword1], [keyword2], [keyword3]

Top Relevant Lessons:

1. [Score: 9] Lesson: [title]
   Agent: @agent-name | Date: YYYY-MM-DD
   Symptom: [what went wrong]
   Fix: [solution]
   Tags: #tag1 #tag2

2. [Score: 7] Lesson: [title]
   ...

Action: Review lessons before proceeding? [Y/n]
```

**Auto-trigger:** When orchestration detects a new task, run `@memory smart-recall [task]` automatically.

---

### @memory score-lessons

Rank all lessons by frequency and severity for prioritized viewing.

**Steps:**
1. Read `docs/lessons.md` and `~/.config/opencode/global-memory/lessons.md`.
2. Calculate priority score for each lesson:
   - **Frequency**: How many times this pattern appeared (+2 per occurrence)
   - **Severity**: Impact level (+3 critical, +2 high, +1 medium, +0 low)
   - **Recency**: Within last 7 days (+2), within 30 days (+1)
3. Sort by total score (highest first).
4. Present ranked table.

**Output format:**
```
[LESSON SCORES]

| Rank | Score | Title | Agent | Frequency | Severity | Last Seen |
|------|-------|-------|-------|-----------|----------|-----------|
| 1 | 12 | JWT expiry bug | @backend-coder | 5x | Critical | 2 days ago |
| 2 | 8 | N+1 query | @performance-auditor | 3x | High | 1 week ago |
| ... |

Top 3 Priority Lessons:
1. [title] — [fix summary]
2. [title] — [fix summary]
3. [title] — [fix summary]
```

---

### @memory dream

Scan recent session traces, extract persistent knowledge into project memory, and remove outdated entries.

**Purpose:** Like MiMo-Code's `/dream` — automatically learn from sessions without manual logging.

**Steps:**
1. Read last 5 sessions from `~/.config/opencode/global-memory/work-diary/`.
2. Read `docs/lessons.md` and `docs/DECISIONS.md`.
3. Extract knowledge types:

| Type | Source | Target |
|------|--------|--------|
| **Architecture decisions** | Session traces | `docs/DECISIONS.md` |
| **Recurring patterns** | Multiple sessions | `docs/patterns.md` |
| **Lessons learned** | Failures/challenges | `docs/lessons.md` |
| **Tech stack info** | Project files | `docs/current-state.md` |
| **Outdated entries** | Old sessions | Remove from active files |

4. Merge extracted knowledge with existing files (avoid duplicates).
5. Remove outdated entries (older than 90 days, no longer relevant).
6. Report what was added/removed.

**Output format:**
```
[DREAM COMPLETE]

Sessions scanned: 5
Knowledge extracted:
├─ Architecture decisions: 2 added to DECISIONS.md
├─ Patterns: 3 added to patterns.md
├─ Lessons: 1 added to lessons.md
└─ Outdated: 4 entries removed

Memory updated: docs/ (4 files changed)
```

**Auto-trigger:**
- After 10 sessions: auto-run dream
- Token budget > 80%: run dream to clean up
- Manual: `@memory dream`

---

### @memory distill

Discover repeated manual workflows in recent work and package into reusable skills, subagents, or commands.

**Purpose:** Like MiMo-Code's `/distill` — learn new workflows automatically.

**Steps:**
1. Read last 10 sessions from `~/.config/opencode/global-memory/work-diary/`.
2. Analyze workflow patterns:
   - Same sequence of steps repeated 3+ times
   - Same agent combinations used together
   - Same file operations (create → edit → test → commit)
3. For each pattern found:
   - Calculate confidence score (frequency × consistency)
   - If confidence > 70% → candidate for packaging
4. Present candidates to user for approval.

**Output format:**
```
[DISTILL CANDIDATES]

Scanned: 10 sessions
Patterns found: 3

1. [Score: 85%] "API Endpoint Workflow"
   Pattern: @planner → @backend-coder → @test-coder → @auditor → @git-manager
   Frequency: 8 times
   Suggestion: Create /api-workflow command

2. [Score: 72%] "Bug Fix Workflow"
   Pattern: @research → @coder → @test-coder → @git-manager
   Frequency: 5 times
   Suggestion: Create @bug-fixer subagent

Package as skill/command? [Y/n]
```

**Packaging options:**

| Option | Action |
|--------|--------|
| **Skill** | Create `core/skills/[name]/SKILL.md` with workflow steps |
| **Command** | Create `core/commands/[name].md` with slash command |
| **Subagent** | Create `core/agents/[name].md` with agent config |

**After packaging:**
1. Create the new skill/command/agent file
2. Register in `opencode.json`
3. Update `VERSION.yaml` if adding new components
4. Log in `docs/patterns.md` as documented workflow

---

### @memory checkpoint [save|restore|list]

Auto-save session state when context nears limit. Like MiMo-Code's checkpoint system.

**Purpose:** Prevent context overflow by saving/restoring session state automatically.

#### @memory checkpoint save

Save current session state to checkpoint file.

**Steps:**
1. Capture current session state:
   - Active task (from planner.md)
   - Files being edited
   - Decisions made this session
   - Context loaded (AGENTS.md, current-state.md, etc.)
   - Session history (compressed summary)
2. Write to `~/.config/opencode/global-memory/checkpoint.md`:

```markdown
# Session Checkpoint

**Saved:** 2026-06-16 14:30
**Task:** Build user authentication
**Progress:** 60% complete

## Active Context
- Files: src/auth.ts, src/user.ts, tests/auth.test.ts
- Decisions: JWT over sessions (DEC-001)
- Agent: @backend-coder

## Session Summary
- Created User model
- Implemented JWT login
- Next: Add refresh token

## Files Modified
- src/auth.ts (created)
- src/user.ts (created)
- tests/auth.test.ts (created)
```

3. Confirm to user:
```
Checkpoint saved (14:30)
Task: Build user authentication
Progress: 60%
```

#### @memory checkpoint restore

Restore session from checkpoint.

**Steps:**
1. Read `~/.config/opencode/global-memory/checkpoint.md`.
2. Load context from checkpoint:
   - Read files listed in checkpoint
   - Load decisions from DECISIONS.md
   - Load project state from current-state.md
3. Present summary:
```
[CHECKPOINT RESTORED]

Saved: 2026-06-16 14:30
Task: Build user authentication
Progress: 60%

Resumed context:
├─ Files: 3 loaded
├─ Decisions: 1 active
└─ Next: Add refresh token

Ready to continue!
```

#### @memory checkpoint list

List all available checkpoints.

**Output:**
```
[CHECKPOINTS]

| # | Date | Task | Progress | Files |
|---|------|------|----------|-------|
| 1 | 14:30 | Build auth | 60% | 3 files |
| 2 | 12:15 | Setup DB | 100% | 5 files |
| 3 | 10:00 | Init project | 100% | 2 files |
```

**Auto-checkpoint triggers:**
| Threshold | Action |
|-----------|--------|
| > 80% context | Auto-save checkpoint |
| > 90% context | Save + compress old sessions |
| > 95% context | Save + prompt user to resume later |

**Auto-cleanup:**
- Keep last 5 checkpoints
- Delete checkpoints older than 7 days
- Never delete checkpoint with incomplete task

---

### @memory lesson: [title] -- [what went wrong + fix]

Log a lesson learned.

**Steps:**
1. Open `docs/lessons.md` (create if not exists).
2. Append a lesson entry with this format:

```markdown
## Lesson: [YYYY-MM-DD] [Short Title]

**Agent:** @agent-name
**Task:** [What was being attempted]
**Symptom:** [What went wrong]
**Root Cause:** [Why it happened]
**Fix Applied:** [What resolved it]
**Tags:** #tag1 #tag2
**Related Decisions:** DEC-XXX
```

3. Also append to `~/.config/opencode/global-memory/lessons.md` for cross-project access.

---

### @memory budget

Show estimated token usage for the current context.

**Steps:**
1. Estimate tokens for each active context file (approx 10 tokens per line):
   - `AGENTS.md` (always keep)
   - `planner.md` (always keep)
   - `current-state.md` (always keep)
   - `DECISIONS.md` (always keep)
   - `lessons.md` (always keep)
   - Current code being edited (always keep)
   - Session history (compress if needed)
   - Past session diary (compress when >80% of budget)
2. Present a table showing each component, estimated tokens, and priority level.
3. Suggest compression if total exceeds 80% of context window.

**Priority levels:**
- Always Keep: AGENTS.md, planner.md, DECISIONS.md, current-state.md, active code
- Compress if needed: Current session exchanges, recent output
- Full summary: Past sessions (>3 back), archived diaries

**Auto-triggers:**
| Threshold | Action |
|-----------|--------|
| > 80% of context | Auto-compress low priority items |
| > 90% of context | Light compression on session history |
| > 95% of context | Prompt user for aggressive compression |

---

### @memory compress [level]

Compress session history to save tokens.

**Levels:**
- **light** (default): Compress sessions older than 10 sessions. Keep decisions, preferences, recent sessions. Saves 30-50%.
- **medium**: Compress all except last 5 sessions. Keep decisions, preferences, summaries. Saves 50-70%.
- **aggressive** (or **full**): Keep only decisions and preferences. Compress all session history. Saves 70-80%.

**What is NEVER compressed:**
- `DECISIONS.md`
- `user-profile.md`
- `current-state.md`

**Steps:**
1. Read the target session diary files.
2. For each file, replace detailed session entries with one-line summaries.
3. Keep all decision entries intact.
4. Write the compressed version back.
5. Report space saved.

---

### @memory analyze lessons

Scan the last 10 sessions for recurring issues.

**Steps:**
1. Read `~/.config/opencode/global-memory/lessons.md`.
2. Read the last 10 session entries from `~/.config/opencode/global-memory/work-diary/`.
3. Identify recurring tags, error types, and topics.
4. Present a summary of patterns: which issues appear most frequently, which agents fail most, what fixes are most common.
5. Update `docs/patterns.md` with frequency counts.

---

### @memory analyze patterns

Update patterns documentation with frequency counts.

**Steps:**
1. Read `docs/patterns.md` if it exists.
2. Scan recent session entries and lessons for recurring implementation patterns.
3. Update or create entries for patterns found, including frequency count.
4. Present the updated pattern summary.

---

### @memory update check

Check if the CodeXen repository has updates available.

**Steps:**
1. Run `git remote update` in the CodeXen repository directory.
2. Run `git rev-list HEAD...origin/main --count` to check how many commits behind.
3. If behind, inform user: "CodeXen: [N] commit(s) behind. Update? Load update.md to update."
4. If up to date, confirm: "CodeXen is up to date."

---

### @memory health

Check that all expected agents and skills are reachable.

**Steps:**
1. List all agent files in `~/.config/opencode/agents/`.
2. List all skill directories in `~/.config/opencode/skills/`.
3. Compare against the expected list from `VERSION.yaml`.
4. Report any missing agents or skills.

---

## Memory Files

```
docs/
  current-state.md       # Current project snapshot (from init-project)
  session-diary.md       # Session logs with tags
  DECISIONS.md           # Decision log (managed by @decision-log)
  patterns.md            # Documented patterns (optional)
  lessons.md             # Lessons learned from past failures
  context/               # Modular context (from init-project)
    backend.md
    frontend.md
    database.md
```

Global memory (cross-project):
```
~/.config/opencode/global-memory/
  user-profile.md        # User preferences
  current-session.md      # RAM for current session
  current-goal.md         # Active goal/stop condition
  checkpoint.md           # Latest session checkpoint
  checkpoint/             # Older checkpoints
    checkpoint-YYYY-MM-DD-HHMM.md
  patterns.md             # Patterns across projects
  lessons.md              # Cross-project lessons learned
  agent-performance.md    # Agent success/failure stats
  agent-performance/      # Individual agent history
    @backend-coder.md
    @frontend-coder.md
    ...
  work-diary/
    diary-YYYY-MM.md      # Monthly session log
    archive/               # Archived diaries (>1000 lines)
```

---

## Context Compression

Sessions older than 30 days are automatically summarized when `@memory save` is run.

**Manual triggers:**
- After 20 sessions: offer light compression
- Token budget > 80%: prompt user to compress
- New project start: offer aggressive compression

---

## Start of Session (Auto)

When a session begins, the primary agent should:
1. Read `AGENTS.md` for tech stack
2. Read `docs/current-state.md` for project snapshot
3. Read `DECISIONS.md` for active decisions
4. Run `@memory smart-recall [project-type]` to auto-suggest relevant lessons
5. Run `@memory score-lessons` to see top priority issues
6. Check `docs/patterns.md` for applicable patterns
7. Check `~/.config/opencode/global-memory/agent-performance.md` for agent routing

---

## Guidelines

- Tag all session entries with keywords for easier search
- Log every significant decision via `@decision-log`
- Keep `docs/patterns.md` up to date with recurring patterns
- Compress sessions older than 30 days
- Cross-reference patterns across projects
- Always read files before writing
- Create directories if they do not exist before writing files