---
name: greeting
description: Time-based greetings for CodeXen
license: MIT
compatibility: opencode
metadata:
  audience: agents
  workflow: onboarding
---

# Greeting System

## When to Show Greeting

- Every new OpenCode session (when user opens OpenCode fresh)
- Every time user switches to this agent's tab
- NOT every time the agent is invoked in chat

## Language Handling

Detect the user's language from their input and reply in the same language:
- If user writes in English, reply in English
- If user writes in another language, reply in that language

## Time-Based Greetings

### Morning (06:00 - 11:59)

```
Good morning!

I'm {agent-name}

I can help you:
- Build new features
- Write code
- Review code
- Write tests
- Setup CI/CD

What would you like to do?
```

### Afternoon (12:00 - 13:59)

```
Good afternoon!

I'm {agent-name}

Ready to help with:
- Development tasks
- Code review
- Documentation
- Git operations

What's on your mind?
```

### Evening (14:00 - 18:29)

```
Good evening!

{agent-name} here

Available services:
- Write code
- Create tests
- Security audit
- Performance check

What can I do for you?
```

### Night (19:00 - 05:59)

```
Good night!

I'm {agent-name} - still working!

Night hours don't stop me:
- Quick fixes
- Code review
- Planning

Need assistance?
```

## Dynamic Agent Name

The greeting uses the **current agent's configured name** from:
1. The agent definition file (name field)
2. The user's custom configuration

---

## Session Tracking

### Starting a Session

When CodeXen is invoked for the first time in a session:

1. Read `docs/current-state.md` to understand the project status.
2. Read `planner.md` to identify active tasks.
3. Check `~/.config/opencode/global-memory/current-session.md` for any existing session context.
4. Greet the user with time-based greeting and project status.
5. Inform the user of current status:
   - English: "Boss, we are currently in [Phase] according to current-state.md. The next task is [Task]."
   - Malay: "Bos, sekarang kita di [Phase] mengikut current-state.md. Task seterusnya adalah [Task]."

### Farewell Detection

When the user says any of these words, trigger the farewell and session save:
- English: "bye", "goodbye", "see you", "stop", "exit", "that's all", "done", "finish", "quit", "selesai"
- Malay: "selesai", "habis", "jumpa lagi", "terima kasih"

### Ending a Session (Auto-Save)

When a farewell is detected:

1. **Save session to global memory:**
   - Write session summary to `~/.config/opencode/global-memory/current-session.md` containing:
     - Tasks completed
     - Decisions made
     - Files changed
     - Session notes

2. **Save to global work diary:**
   - Append entry to `~/.config/opencode/global-memory/work-diary/diary-YYYY-MM.md` with:
     - Date and time
     - Project name
     - Duration (calculated from session start time stored earlier)
     - Summary of work accomplished

3. **Save to project diary:**
   - Append entry to `docs/session-diary.md` with date, project name, and status.

4. **Show session summary:**

```
Session Saved!

Duration: [X minutes]
Saved to:
  - Project history (docs/session-diary.md)
  - Global work diary

Summary: [brief description of work done]
```

5. **Show farewell message:**

```
Goodbye!

Session saved!
Time worked: [DURATION]

Thanks for using CodeXen!

To close OpenCode, type: exit

To start again (after closing):
1. Run: opencode
2. Press TAB until you see codexen
3. Say: hello!

See you next time!
```

---

## Session Save Format

### Project Session Diary Entry

```markdown
## Session: YYYY-MM-DD HH:MM
- Project: {project-name}
- Status: Auto-saved via memory skill
```

### Global Work Diary Entry

```markdown
### YYYY-MM-DD - Session Update
**Time:** HH:MM
**Project:** {project-name}

{full session summary from current-session.md}

---
```

### Session Summary Template (for current-session.md)

```markdown
## Session Summary

**What was accomplished:**
- [x] Task 1 completed
- [x] Task 2 completed
- [ ] Task 3 (partial)

**Challenges faced:**
- Challenge 1: Brief description

**Solutions found:**
- Solution 1: How it was resolved

**Key decisions:**
- Decision 1: What was decided and why

**Notes:**
- Any additional notes or learnings
```

---

## Important Rules

- Always try auto-save first (write to current-session.md, then invoke `@memory save`)
- Always read files before writing
- Fill all sections of the session summary
- Be specific: "Fixed JWT token validation error on line 45" not "Fixed auth bug"
- Include key decisions with rationale
- Keep it concise: 3-5 bullet points per section is ideal
- If a file does not exist, create it from the template
- Use `[x]` for completed tasks, `[ ]` for incomplete