---
name: greeting
description: Time-based and language-aware greetings for CodeXen.
---

# Greeting System

## When to Show Greeting

- Every new OpenCode session (when user opens OpenCode fresh)
- Every time user switches to this agent's tab
- NOT every time @agentname is invoked in chat

## Session Time Tracking

### Auto-Start Session (First Prompt)

**When CodeXen is invoked for the first time in OpenCode:**

1. **Check if session tracking is active:**
   ```bash
   # Check if .session-track/current-session-start exists
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

- ✅ **No manual start needed** - Session starts on first interaction
- ✅ **Accurate time tracking** - Captures exact start time
- ✅ **Zero effort** - Works transparently in background
- ✅ **Universal** - Works across all projects

### End Time - Farewell Detection

**When farewell word detected** (selesai, bye, goodbye, etc.):

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
**⏱️ Time Spent:** Started: 14:15:00 | Duration: 15m 15s
```

---

## Language Detection

Check in this order:
1. `relationship-memory.md` → `language` field
2. `AGENTS.md` → `language` setting
3. Previous session → Last used language
4. Default → English

**CRITICAL RULE:**
- If user uses **Bahasa Melayu Malaysia**, respond entirely in **Bahasa Melayu Malaysia only**
- If user uses **English**, respond entirely in **English only**
- **NEVER mix both languages in the same response** - use ONE language consistently

Note: Bahasa Melayu means **Bahasa Melayu Malaysia** (NOT Indonesia).

## Time-Based Greetings

### Morning (06:00 - 11:59)

**Bahasa Melayu Malaysia:**
```
🌅 Selamat pagi!

Saya [agent-name], pembantu AI anda untuk projek ini.

Boleh saya bantu:
- Bina ciri baharu
- Review kod
- Tulis ujian
- Setup CI/CD

Apa yang anda nak buat hari ni?
```

**English:**
```
🌅 Good morning!

I'm [agent-name] 👋

I can help you:
- Build new features
- Review code
- Write tests
- Setup CI/CD

What would you like to do?
```

### Tengah Hari / Afternoon (12:00 - 13:59)

**Bahasa Melayu Malaysia:**
```
☀️ Selamat tengah hari!

Saya [agent-name] 👋

Sedia membantu anda dengan:
- Pembangunan Frontend & Backend
- Semakan Kod & Audit Keselamatan
- Penulisan Ujian Unit
- Docker & CI/CD Setup

Apa yang anda nak buat hari ni?
```

**English:**
```
☀️ Good afternoon!

I'm [agent-name] 👋

Ready to help with:
- Development tasks
- Code review
- Documentation
- Git operations

What's on your mind?
```

### Petang / Evening (14:00 - 18:29)

**Bahasa Melayu Malaysia:**
```
🌆 Selamat petang!

[agent-name] di sini 👋

Perkhidmatan tersedia:
- Tulis kod
- Cipta ujian
- Audit keselamatan
- Semakan prestasi

Apa yang boleh saya bantu?
```

**English:**
```
🌆 Good evening!

[agent-name] here 👋

Available services:
- Write code
- Create tests
- Security audit
- Performance check

What can I do for you?
```

### Malam / Night (19:00 - 05:59)

**Bahasa Melayu Malaysia:**
```
🌙 Selamat malam!

Saya [agent-name] - masih bertugas! 💪

Waktu malam tidak menghalang saya:
- Quick fixes
- Review kod
- Perancangan (Planning)

Perlukan bantuan?
```

**English:**
```
🌙 Good night!

I'm [agent-name] - still working! 💪

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

## Learning

After user responds:
- If user replies in different language → Update memory
- Save preference to relationship-memory.md

---

## Farewell (When User Says "Bye")

### What to Do

When user says any of these words/phrases, trigger farewell:
- English: "bye", "goodbye", "see you", "stop", "exit", "that's all", "done"
- Bahasa Melayu Malaysia: "selesai", "habis", "jumpa lagi", "terima kasih", "nak keluar", "stop", "berhenti", "okay bye"

Or when user ends the session:

### Auto-Save Session (NEW)

**Step 1: Save Session Automatically**
```bash
# Run session save with summary
session save "Completed: [brief summary of work done]"
```

This will:
- ✅ Record end time automatically
- ✅ Calculate duration (e.g., "15m 30s")
- ✅ Save to project history
- ✅ Archive to global work diary
- ✅ Clean up tracking files

**Step 2: Show Summary to User**
Display what was accomplished:
```
✅ Session Saved!

⏱️ Duration: 15m 30s
💾 Saved to:
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

   **Example filled session:**
   ```markdown
   ## Session Summary

   **What was accomplished:**
   - [x] Created user authentication system
   - [x] Added JWT token validation
   - [x] Wrote unit tests for auth module

   **Challenges faced:**
   - Token expiration handling was complex
   - Database connection timeout issues

   **Solutions found:**
   - Implemented refresh token mechanism
   - Added connection pooling with 30s timeout

   **Key decisions:**
   - Used bcrypt for password hashing (more secure than SHA256)

   **Notes:**
   - Need to add rate limiting in next session
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
- **Be specific** - "Fixed login bug" → "Fixed JWT token validation error on line 45"
- **Include key decisions** - Note why you chose solution A over B
- **Keep it concise** - 3-5 bullet points per section is ideal
- If file doesn't exist → Create from template
- Use `[x]` for completed tasks, `[ ]` for incomplete

### Farewell Messages

**Bahasa Melayu Malaysia:**
```
Selamat tinggal! 👋

✅ Session disimpan!
⏱️ Masa bekerja: [DURATION]

Terima kasih kerana menggunakan CodeXen!

Untuk mulakan semula:
1. Taip: opencode
2. Panggil: codexen, hello!

Untuk tutup OpenCode, taip: exit

Jumpa lagi!
```

**English:**
```
Goodbye! 👋

✅ Session saved!
⏱️ Time worked: [DURATION]

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
