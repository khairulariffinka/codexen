# Uninstall CodeXen

> **When user loads this file:** User wants to uninstall CodeXen from their system.

---

## Context

When this file is loaded, AI must know:
- User wants to uninstall/remove CodeXen
- NOT just reading the file
- AI must execute uninstall steps

## Confirm

**Are you sure you want to uninstall CodeXen?**

This will remove ALL CodeXen data:
- All agents (24 files)
- All skills (17 folders)
- All commands (12 files)
- Config (opencode.json)
- Global memory (user profile, work diary, knowledge library)

**Choose your option:**

- `confirm` - Proceed with complete uninstallation
- `cancel` - Abort uninstallation

```
AI: Are you sure you want to uninstall CodeXen?
     This will remove ALL agents, skills, and global memory.

     Type "confirm" to proceed or "cancel" to abort.
```

---

## Run Uninstall

When you load this file, run the following commands:

```bash
# ============================================
# Remove skills folder
# ============================================
rm -rf ~/.config/opencode/skills

# ============================================
# Remove agents folder
# ============================================
rm -rf ~/.config/opencode/agents

# ============================================
# Remove commands folder
# ============================================
rm -rf ~/.config/opencode/commands

# ============================================
# Remove global memory folder
# ============================================
rm -rf ~/.config/opencode/global-memory
```

---

## Verify Uninstallation

Restart terminal/CLI and type:

```
codexen
```

If you get "Agent not found" or error - uninstall successful!

---

## Notes

This will remove everything CodeXen installed:
- Skills folder: 17 skills
- Agents folder: 24 agents
- Commands folder: 12 commands
- Config: opencode.json
- Global memory folder: user profile, work diary, knowledge library

**After uninstall, you will need to run the setup again to use CodeXen.**
