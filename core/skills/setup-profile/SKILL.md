---
name: setup-profile
description: Interactive setup wizard to configure user profile for global memory
---

## When to Use

- User says: "setup profile", "setup-profile", "configure profile"
- First session detected (no user-profile.md filled in)

## What It Does

1. Checks if user-profile.md exists
2. If not complete, prompts user to fill in
3. Opens the profile file for editing
4. Confirms when complete

## How It Works

### Step 1: Check Profile Status

Read `~/.config/opencode/global-memory/user-profile.md`:

Check if these fields are filled:
- Name (not empty)
- Language (English / Bahasa Melayu)

### Step 2: If Not Complete

Prompt user with examples:

```
👋 Welcome! Let's set up your profile.

Just fill in 2 fields:
- Name: [your name]
- Language: [English / Bahasa Melayu]

Optional (skip if want):
- Response Style: Brief / Detailed
- Emoji: Yes / No

Examples how you'll sound:
| Style | You get |
|-------|---------|
| Brief, No emoji | "Done. File at src/auth.ts" |
| Brief, Yes emoji | "Done! ✅ File at src/auth.ts" |
| Detailed | "I've added login because..." |

Say "done" when finished.
```

Then open: `~/.config/opencode/global-memory/user-profile.md`

### Step 3: If Complete

```
✅ Profile: [Name]
Language: [Language]

Update anytime: "setup profile"
```

## Commands

| Trigger | Action |
|---------|--------|
| "setup profile" | Start/updates profile |
| "show profile" | Display current profile |

## Notes

- Only 2 fields required: Name + Language
- Others auto-detect from your project
- Profile is GLOBAL - all projects