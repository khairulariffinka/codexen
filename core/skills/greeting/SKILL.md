---
name: greeting
description: Time-based greetings for CodeXen.
---

# Greeting System

## When to Show Greeting

- Every new OpenCode session (when user opens OpenCode fresh)
- Every time user switches to this agent's tab
- NOT every time @agentname is invoked in chat

## Language Handling

Detect user's language from input and reply in the same language:
- If user writes in English, reply in English
- If user writes in other language, reply in that language

## Session Time Tracking

### Auto-Start Session (First Prompt)

**When CodeXen is invoked for the first time in OpenCode:**

1. **Check if session tracking is active:**
   ```bash
   if [ -f ".session-track/current-session-start" ]; then
       # Session already started - continue tracking
   else
       # NEW SESSION - Start tracking automatically
       session start
   fi
   ```

2. **Session will auto-start** using the global `session` command
   - Records start time automatically
   - Creates tracking file in `.session-track/`
   - Ready to calculate duration on exit

### Benefits of Auto-Start

- No manual start needed - Session starts on first interaction
- Accurate time tracking - Captures exact start time
- Zero effort - Works transparently in background
- Universal - Works across all projects

### End Time - Farewell Detection

**When farewell word detected** (bye, goodbye, done, etc.):

1. **Auto-save session** using the session tracker:
   ```bash
   session save "Session completed - [summary of work done]"
   ```

2. **What happens automatically:**
   - End time is recorded
   - Duration is calculated (e.g., "17m 30s")
   - Session saved to project history
   - Session archived to global work diary
   - Tracking file cleaned up

3. **No manual calculation needed!**

### Session Commands (Manual Override)

If you need manual control:

| Command | Description |
|---------|-------------|
| `session start` | Manually start tracking (if auto-start failed) |
| `session status` | Check current session duration |
| `session save "msg"` | Save with custom message |

### Session File Locations

**Project Level:**
- Tracking: `.session-track/current-session-start`
- Session Log: `docs/session-diary.md`

**Global Level:**
- Work Diary: `~/.config/opencode/global-memory/work-diary/diary-YYYY-MM.md`

### Session Save Format

**Project Session File includes:**
- Start Time
- End Time
- Duration (calculated automatically)
- Config Applied
- Custom Message

**Example:**
```markdown
# Session: my-project

**Date:** 2026-03-17 14:30:15
**Project:** my-project
**Time Spent:** Started: 14:15:00 | Duration: 15m 15s
```

---

## Time-Based Greetings

### Morning (06:00 - 11:59)

```
Good morning!

I'm [agent-name]

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

I'm [agent-name]

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

[agent-name] here

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

I'm [agent-name] - still working!

Night hours don't stop me:
- Quick fixes
- Code review
- Planning

Need assistance?
```

## Dynamic Agent Name

The greeting uses the **current agent's configured name** from:
1. Agent definition file (name field)
2. User's custom configuration

## Farewell (When User Says "Bye")

### What to Do

When user says any of these words/phrases, trigger farewell:
- English: "bye", "goodbye", "see you", "stop", "exit", "that's all", "done", "finish", "quit"
- Other languages: "selesai", "habis", "jumpa lagi", "terima kasih"

### Auto-Save Session

**Step 1: Save Session Automatically**
```bash
session save "Completed: [brief summary of work done]"
```

This will:
- Record end time automatically
- Calculate duration (e.g., "15m 30s")
- Save to project history
- Archive to global work diary
- Clean up tracking files

**Step 2: Show Summary to User**
```
Session Saved!

Duration: 15m 30s
Saved to:
  - Project history
  - Global work diary

Summary: [brief description]
```

**Step 3: Say Goodbye**
- Friendly farewell message
- Remind user how to restart

### Manual Session Save (Fallback)

If auto-save fails, use manual method:

1. **Save Session to Global Memory**
   - Read `~/.config/opencode/global-memory/work-diary/diary-YYYY-MM.md` first
   - Fill in the session summary with these sections:

   **Template to Fill:**
   ```markdown
   ## Session Summary

   **What was accomplished:**
   - [ ] Task 1 completed
   - [ ] Task 2 completed
   - [ ] Task 3 completed

   **Challenges faced:**
   - [Challenge 1]: [Brief description of the problem]
   - [Challenge 2]: [Brief description of the problem]

   **Solutions found:**
   - [Solution 1]: [How you solved challenge 1]
   - [Solution 2]: [How you solved challenge 2]

   **Key decisions:**
   - [Decision 1]: [What was decided and why]

   **Notes:**
   - [Any additional notes or learnings]
   ```

   - Write updated content to the file

2. **Archive to Work Diary** (if significant)
   - Add entry to `~/.config/opencode/global-memory/work-diary/diary-YYYY-MM.md`
   - Format:
   ```markdown
   ## 2026-03-17 15:30 - Project Name

   **Duration:** 45 minutes  
   **Accomplished:**
   - Built login page
   - Fixed navigation bug

   **Challenges:** Database timeout  
   **Solution:** Added connection pooling
   ```

### Important Rules

- **ALWAYS try auto-save first** - Run `session save` command
- **ALWAYS read file before writing** - Use Read tool first
- **Fill all 3 main sections** - Accomplished, Challenges, Solutions
- **Be specific** - "Fixed login bug" - "Fixed JWT token validation error on line 45"
- **Include key decisions** - Note why you chose solution A over B
- **Keep it concise** - 3-5 bullet points per section is ideal
- If file does not exist - Create from template
- Use [x] for completed tasks, [ ] for incomplete

### Farewell Message

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

### Session Save Format

```
## Session Summary (Fill at end)

**What was accomplished:**
- [Task 1]
- [Task 2]

**Challenges faced:**
- [Challenge 1]

**Solutions found:**
- [Solution 1]
```