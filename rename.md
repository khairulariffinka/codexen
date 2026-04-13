# Rename Protocol

> **When user loads this file:** User wants to rename their primary agent.

AI-assisted protocol to rename the primary agent from "codexen" to a custom name.

**Works for:** OpenCode

## Context

When this file is loaded, AI harus tahu:
- User nak rename agent CodeXen
- Current name: `codexen`
- AI perlu tanya user nak rename kepada apa

## Usage

```
User: "Load rename.md"
AI: "What would you like to rename 'codexen' to?"
User: "nova"
AI: [Execute rename steps]
```

## Rename Steps

Execute these steps when user provides their chosen name:

### Step 1: Validate Name

```
Rules for valid name:
- Lowercase letters and numbers only
- Hyphens allowed between words
- No spaces, underscores, or special characters
- Must be 1-64 characters
- Cannot start or end with hyphen

Valid examples: nova, my-agent, code-helper-123
Invalid examples: My Agent, nova_v2, agent!
```

If invalid, ask user for a different name.

### Step 2: Check Current Agent

```
Check which platforms have codexen installed:

OpenCode:  ~/.config/opencode/agents/codexen.md
```

### Step 3: Rename Agent File

```
mv ~/.config/opencode/agents/codexen.md ~/.config/opencode/agents/{new-name}.md
```

### Step 4: Update Agent File Content

Edit the renamed agent file:

```yaml
# Change this line:
name: codexen

# To:
name: {new-name}
```

Also update any references to "codexen" in the file content to "{new-name}".

### Step 4: Rename Skill Folder

```
# Skills folder structure - no codexen folder exists
# Skip this step - skills are referenced directly, not as folder
```

### Step 5: Update Skill File Content

Skill files are referenced directly from core/skills/. No separate skill folder to rename. Skip this step.

### Step 6: Verify Rename

```
Check that all files are correctly renamed:

~/.config/opencode/
├── agents/
│   └── {new-name}.md         ← Renamed ✓
└── skills/
    └── (skills are unchanged) ← No codexen folder
```

### Step 7: Complete

```
✅ Rename Complete!

Old name: codexen
New name: {new-name}

Files updated:
- agents/{new-name}.md

Test your renamed agent:
Say: "{new-name}, hello!"
```

## Example Session

```
User: Load rename.md

AI: I'll help you rename your agent.
    Current name: codexen

User: nova

AI: Validating name... ✓
    Renaming codexen → nova...

    OpenCode:
    1. Renaming agent file... ✓
    2. Updating agent content... ✓

    ✅ Rename Complete!
    Your agent is now "nova"

    Test it: "nova, hello!"
```

## Reverting

To revert to the default name:

```
User: Load rename.md
AI: What name?
User: codexen
AI: [Reverts to default]
```

## Important Notes

- **ONLY edit files in ~/.config/opencode/** - NEVER edit source files in project folder
- This only renames the primary agent (codexen)
- Core subagents (memory, planner, coder, etc.) are NOT renamed
- The rename ONLY affects:
  - ~/.config/opencode/agents/codexen.md → {new-name}.md
- Skills are referenced directly from core/skills/ - no separate folder
- Original source files in the project folder remain unchanged
- If you reinstall (load install.md), it will restore default "codexen" name
