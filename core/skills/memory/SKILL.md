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
  patterns.md             # Patterns across projects
  lessons.md              # Cross-project lessons learned
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
4. Run `@memory show lessons about [project-type]` to check past mistakes
5. Check `docs/patterns.md` for applicable patterns

---

## Guidelines

- Tag all session entries with keywords for easier search
- Log every significant decision via `@decision-log`
- Keep `docs/patterns.md` up to date with recurring patterns
- Compress sessions older than 30 days
- Cross-reference patterns across projects
- Always read files before writing
- Create directories if they do not exist before writing files