# Setup Guide

Complete guide to setting up CodeXen with OpenCode.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Post-Install](#post-install)
4. [Customization](#customization)
5. [Testing](#testing)
6. [Troubleshooting](#troubleshooting)

## Prerequisites

### Required

| Requirement | How to Check | Install |
|-------------|--------------|---------|
| OpenCode CLI | `opencode --version` | [opencode.ai](https://opencode.ai) |

**Note:** OpenCode is required.

## Installation

### Step 1: Download CodeXen

```bash
# Option A: Clone with Git
git clone https://github.com/khairulariffinka/codexen.git
cd codexen

# Option B: Download ZIP
# Download from GitHub, extract, then:
cd codexen
```

### Step 2: Run Installation

Load the install documentation:

```
"Load install.md"
```

The installation will automatically:
1. Create necessary directories
2. Copy core agents
3. Copy core skills
4. Set up global memory templates

### Step 3: Restart OpenCode

```bash
# Restart OpenCode to load new agents
opencode
```

Or reload configuration if your OpenCode version supports it.

## Post-Install

### Verify Installation

Check that files are in place:

```
~/.config/opencode/  (for OpenCode)
├── agents/
│   ├── codexen.md    ← Primary agent
│   ├── memory.md     ← Memory subagent
│   ├── planner.md    ← Planning subagent
│   ├── coder.md      ← Coding subagent
│   └── ... (other subagents)
└── skills/
├── greeting.md   ← Greeting system
├── modes.md      ← Operating modes
    └── ... (other skills)
```

### Test Basic Functionality

```
User: "codexen, hello!"

CodeXen: [LOADING] Hello! I am CodeXen...
              [MEMORY] Loading context...
              Ready to help you build!
```

## Customization

### Rename the Agent

To personalize your agent:

```
User: "Load rename.md"
AI: "What would you like to rename 'codexen' to?"
User: "nova"
AI: ✅ Renamed to "nova"
```

**Valid names:**
- `nova`
- `my-agent`
- `code-helper-123`

**Invalid names:**
- `My Agent` (no spaces)
- `nova_v2` (no underscores)
- `agent!` (no special characters)

### Supported Languages

CodeXen responds in your language:

| Your Language | Agent Response |
|---------------|----------------|
| English | English |
| Bahasa Melayu | Bahasa Melayu Malaysia |

```
User: "codexen, tolong explain kod ni"
CodeXen: Baik! Saya akan terangkan kod ini...
```

## Testing

### Test 1: Basic Response
```
"codexen, hello!"
```
Expected: Agent responds with greeting

### Test 2: Planning
```
"codexen, plan a login feature"
```
Expected: Agent creates a hierarchical plan

### Test 3: Coding
```
"codexen, create a simple hello world function"
```
Expected: Agent writes code

### Test 4: Memory
```
"codexen, remember that I prefer TypeScript"
```
Expected: Agent acknowledges and stores preference

### Test 5: Language Detection
```
"codexen, apa khabar?"
```
Expected: Agent responds in Bahasa Melayu Malaysia

## Troubleshooting

### "Agent not found"

**Cause:** OpenCode hasn't loaded the new agents.

**Solution:**
1. Restart OpenCode
2. Or reload configuration
3. Verify files exist in `~/.config/opencode/agents/`

### "Permission denied"

**Cause:** Write permissions issue.

**Solution:**
```bash
# Linux/macOS
chmod -R u+w ~/.config/opencode/

# Windows
# Run as Administrator or check folder permissions
```

### "Files already exist"

**Cause:** Previous installation.

**Solution:**
- Use `update.md` to update existing installation
- Or backup and remove old files:
  ```bash
  mv ~/.config/opencode ~/.config/opencode.backup
  ```

### "Skill not loading"

**Cause:** SKILL.md file issues.

**Solution:**
1. Check file is named exactly `SKILL.md` (uppercase)
2. Check YAML frontmatter is valid
3. Restart OpenCode

### "Rename failed"

**Cause:** Invalid name or file locked.

**Solution:**
1. Use only lowercase letters, numbers, hyphens
2. Close any programs using the files
3. Try again with a different name

## Uninstallation

To remove CodeXen:

```
"Load uninstall.md"
```

The uninstallation will automatically remove all agents, skills, and version files.

## Next Steps

After installation:

1. **Read the README.md** for full feature documentation
2. **Try the examples** to learn the workflow
3. **Customize the agent name** to personalize it
4. **Start building!**

## Getting Help

- **Documentation:** README.md
- **Issues:** GitHub Issues
- **OpenCode Docs:** [opencode.ai/docs](https://opencode.ai/docs)

---

**Version**: 1.0.0
