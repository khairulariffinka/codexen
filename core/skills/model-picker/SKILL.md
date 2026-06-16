---
name: model-picker
description: Interactive model selection based on task type, budget, and quality needs
license: MIT
compatibility: opencode
metadata:
  audience: agents
  workflow: configuration
---

# Model Picker Skill

Interactive model selection based on task type, budget, and quality requirements.

## When to Use

- User asks to change model
- User asks about available models
- User wants cost optimization
- User starts a new project (suggest best model)

## Available Models

### Free Tier ($0/month)

| Model | Provider | Best For |
|-------|----------|----------|
| big-pickle | opencode | Simple tasks, exploration, style checks |

### Budget Tier ($5-10/month)

| Model | Provider | Best For |
|-------|----------|----------|
| kimi-k2.5 | opencode-go | Daily coding, backend work |
| minimax-m2.5 | opencode-go | Planning, documentation |

### Premium Tier ($30-50/month)

| Model | Provider | Best For |
|-------|----------|----------|
| claude-sonnet-4-6 | opencode | Complex coding, architecture |
| claude-opus-4-6 | opencode | Security audits, critical systems |
| claude-haiku-4-5 | opencode | Fast responses, simple tasks |

### Ultra Tier ($100+/month)

| Model | Provider | Best For |
|-------|----------|----------|
| gpt-5.1-codex | opencode | Maximum capability |
| gemini-2.5-pro | opencode | Large context, multi-modal |

## Task-to-Model Mapping

| Task Type | Recommended Model | Why |
|-----------|-------------------|-----|
| Exploration/Research | big-pickle | Free, fast |
| Style/Format Check | big-pickle | Free, sufficient |
| Simple Bug Fix | kimi-k2.5 | Cheap, good quality |
| Feature Implementation | claude-sonnet-4-6 | Best coding quality |
| Security Audit | claude-opus-4-6 | Thorough analysis |
| Architecture Planning | claude-sonnet-4-6 | Strong reasoning |
| Documentation | minimax-m2.5 | Good, affordable |
| Quick Questions | claude-haiku-4-5 | Fast response |

## How to Use

### Step 1: Ask User Context

Determine what user needs:

```
What are you working on?
1) Quick fix / exploration
2) Feature implementation
3) Security review
4) Architecture planning
5) Documentation
```

### Step 2: Check Budget

Ask about budget constraints:

```
What's your budget preference?
1) Free only (no cost)
2) Budget ($5-10/month)
3) Quality ($30-50/month)
4) No limit
```

### Step 3: Recommend & Apply

Based on task + budget, recommend a model:

```
Recommended: [model-name]
Cost: [price]
Why: [reason]

Apply this model? (y/n)
```

If yes, update the config:

1. Read current `~/.config/opencode/opencode.json`
2. Update `model` key with selected model
3. Optionally set per-agent models for specific tasks
4. Tell user to restart OpenCode

### Step 4: Quick Switch

For immediate use without questions:

```
/pick free      → big-pickle
/pick budget    → kimi-k2.5
/pick quality   → claude-sonnet-4-6
/pick premium   → claude-opus-4-6
```

## Config Updates

When applying a model, update `~/.config/opencode/opencode.json`:

### Basic (single model for all tasks)

```json
{
  "model": "opencode/claude-sonnet-4-6"
}
```

### Advanced (per-agent models)

```json
{
  "small_model": "opencode/big-pickle",
  "agent": {
    "coder": { "model": "opencode/claude-sonnet-4-6" },
    "planner": { "model": "opencode/claude-haiku-4-5" },
    "security": { "model": "opencode/claude-opus-4-6" },
    "explore": { "model": "opencode/big-pickle" }
  }
}
```

## Cost Optimization Tips

1. **Use free tier for exploration** — big-pickle handles most research tasks
2. **Reserve premium for critical work** — security audits, production code
3. **Set small_model for lightweight tasks** — title generation, simple edits
4. **Per-agent config** — different models for different job types

## Important Notes

- Always ask before changing model
- Explain cost implications
- Recommend restart after config change
- Never set secrets or API keys in config
