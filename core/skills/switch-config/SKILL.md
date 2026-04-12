---
name: switch-config
description: Switch between different OpenCode model configurations (Free, Budget, Quality, Optimized). Creates or replaces ~/.config/opencode/opencode.json.
---

# Switch Config Skill

Switch between different OpenCode model configurations to optimize costs and quality.

## Config Options

### Free Config ($0/month)

**Model:** big-pickle

```json
{
  "model": "opencode/big-pickle",
  "agent": {
    "build": { "model": "opencode/big-pickle" },
    "plan": { "model": "opencode/big-pickle" },
    "backend-coder": { "model": "opencode/big-pickle" }
  }
}
```

**Best for:**
- Learning OpenCode
- Small projects
- Testing CodeXen
- No budget

**Pros:** Free, unlimited requests  
**Cons:** Less powerful

---

### Budget Config ($5-10/month)

**Model:** kimi-k2.5, minimax-m2.5

```json
{
  "model": "opencode-go/kimi-k2.5",
  "agent": {
    "build": { "model": "opencode-go/kimi-k2.5" },
    "plan": { "model": "opencode-go/minimax-m2.5" },
    "backend-coder": { "model": "opencode-go/kimi-k2.5" }
  }
}
```

**Best for:**
- Daily development work
- Freelance projects
- Predictable monthly cost

**Pros:** Affordable, good quality, fast  
**Cons:** Requires OpenCode Go subscription ($10/month)

**Subscribe:** https://opencode.ai/go

---

### Quality Config ($30-50/month)

**Model:** Claude Sonnet, Claude Opus

```json
{
  "model": "opencode/claude-sonnet-4-6",
  "agent": {
    "build": { "model": "opencode/claude-sonnet-4-6" },
    "plan": { "model": "opencode/claude-haiku-4-5" },
    "security-auditor": { "model": "opencode/claude-opus-4-6" }
  }
}
```

**Best for:**
- Enterprise projects
- Critical systems
- Complex architecture
- Maximum code quality

**Pros:** Best quality, excellent reasoning  
**Cons:** Higher cost, pay-per-use

**Subscribe:** https://opencode.ai/zen (add $20+ credit)

---

### Optimized Config (Mixed Cost)

**Models:** Smart selection per task

Uses different models for different tasks:
- **Research/Explore:** big-pickle (free)
- **Backend/Build:** kimi-k2.5 ($0.05/request)
- **Security Audit:** claude-sonnet-4.5 (premium)
- **Style Check:** big-pickle (free)

```json
{
  "model": "opencode/claude-sonnet-4-5",
  "small_model": "opencode/big-pickle",
  "agent": {
    "build": { "model": "opencode-go/kimi-k2.5" },
    "plan": { "model": "opencode-go/minimax-m2.5" },
    "explore": { "model": "opencode/big-pickle" },
    "security-auditor": { "model": "opencode/claude-sonnet-4-5" },
    "style-auditor": { "model": "opencode/big-pickle" }
  }
}
```

**Best for:**
- Power users
- Cost-conscious professionals
- Mixed task workloads

**Pros:** Optimized cost, task-appropriate models  
**Cons:** More complex setup

---

## How to Switch Config

### Step 1: Ask User Which Config

Ask user to choose:

```
Which config would you like to use?

1) Free ($0) - Testing, learning
2) Budget ($5-10) - Daily coding
3) Quality ($30-50) - Professional work
4) Optimized - Smart selection
```

Wait for user to reply with number (1-4) or config name.

### Step 2: Create Config File

After user selects:

1. Create directory if needed:
   ```bash
   mkdir -p ~/.config/opencode
   ```

2. Write the selected config to `~/.config/opencode/opencode.json`

### Step 3: Confirm & Restart

Tell user:

```
✓ Config switched to [Config Name]
✓ File saved to: ~/.config/opencode/opencode.json

⚠️ Please restart OpenCode for changes to take effect:
   1. Close OpenCode (Ctrl+C)
   2. Run: opencode
```

---

## Decision Guide

Use this to help user choose:

| User Scenario | Recommended Config |
|--------------|-------------------|
| Just learning / testing | Free ($0/month) |
| Daily coding / freelance | Budget ($10/month) |
| Professional / enterprise | Quality ($30-50/month) |
| Want to optimize costs per task | Optimized (Mixed) |

---

## Important Notes

1. **Always ask first** - Never switch without user confirmation
2. **Restart required** - Changes only take effect after restarting OpenCode
3. **Backup optional** - User can backup old config if they want
4. **File replacement** - If opencode.json exists, replace it with new config
