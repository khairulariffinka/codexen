# Model Rotation Config

Ready-to-use OpenCode configurations for smart model rotation.

---

## Quick Start

Copy one of these configs to your OpenCode config file:
- Global: `~/.config/opencode/opencode.json`
- Project: `./opencode.json`

---

## Preset: Budget-Conscious (~$10-20/month)

Optimized for minimal cost while maintaining quality.

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  
  // Main model for complex tasks
  "model": "opencode/claude-haiku-4-5",
  
  // Cheap model for simple tasks (auto-selected by OpenCode)
  "small_model": "opencode/big-pickle",
  
  // Per-agent model overrides
  "agent": {
    "plan": {
      "model": "opencode/big-pickle"
    },
    "explore": {
      "model": "opencode/big-pickle"
    }
  }
}
```

**Estimated Monthly Cost**: $10-20
**Best For**: Hobby projects, learning, personal use

---

## Preset: Balanced (~$30-50/month)

Best cost-to-quality ratio for professional work.

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  
  "model": "opencode/claude-sonnet-4-6",
  "small_model": "opencode/minimax-m2.5",
  
  "agent": {
    "plan": {
      "model": "opencode/claude-haiku-4-5"
    },
    "explore": {
      "model": "opencode/big-pickle"
    },
    "build": {
      "model": "opencode/claude-sonnet-4-6"
    }
  }
}
```

**Estimated Monthly Cost**: $30-50
**Best For**: Freelance work, small teams

---

## Preset: Quality First (~$50-100/month)

Maximum quality with cost awareness.

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  
  "model": "opencode/claude-opus-4-6",
  "small_model": "opencode/claude-haiku-4-5",
  
  "agent": {
    "plan": {
      "model": "opencode/claude-sonnet-4-6"
    },
    "explore": {
      "model": "opencode/claude-haiku-4-5"
    }
  }
}
```

**Estimated Monthly Cost**: $50-100
**Best For**: Enterprise, critical systems

---

## Preset: Free Only ($0/month)

Use only free models.

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  
  "model": "opencode/big-pickle",
  "small_model": "opencode/big-pickle",
  
  "agent": {
    "plan": { "model": "opencode/big-pickle" },
    "explore": { "model": "opencode/big-pickle" }
  }
}
```

**Estimated Monthly Cost**: $0
**Best For**: Learning, experimentation, limited budgets

---

## Preset: OpenCode Go Only (~$5-10/month)

Use OpenCode Go subscription for cheapest rates.

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  
  "model": "opencode-go/minimax-m2.5",
  "small_model": "opencode-go/minimax-m2.5",
  
  "agent": {
    "plan": { "model": "opencode-go/minimax-m2.5" },
    "explore": { "model": "opencode-go/minimax-m2.5" }
  }
}
```

**Estimated Monthly Cost**: $5-10 (subscription)
**Best For**: High usage, predictable costs

---

## Preset: Hybrid (Zen + Go)

Combine both providers for best value.

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  
  // Use Go for main work (cheap)
  "model": "opencode-go/minimax-m2.5",
  
  // Use Zen free for simple tasks
  "small_model": "opencode/big-pickle",
  
  "agent": {
    "plan": {
      // Use cheap model for planning
      "model": "opencode-go/kimi-k2-5"
    },
    "explore": {
      // Free for exploration
      "model": "opencode/big-pickle"
    }
  }
}
```

**Estimated Monthly Cost**: $5-10 + free tier
**Best For**: Power users, maximum savings

---

## Model ID Reference

### OpenCode Zen

| Model | ID | Cost/1M Input |
|------|-----|---------------|
| Big Pickle | `opencode/big-pickle` | FREE |
| MiniMax M2.5 Free | `opencode/minimax-m2.5-free` | FREE |
| MiMo V2 Flash Free | `opencode/mimo-v2-flash-free` | FREE |
| Nemotron 3 Super Free | `opencode/nemotron-3-super-free` | FREE |
| MiniMax M2.5 | `opencode/minimax-m2.5` | $0.30 |
| Gemini 3 Flash | `opencode/gemini-3-flash` | $0.50 |
| Claude Haiku 4.5 | `opencode/claude-haiku-4-5` | $1.00 |
| GPT 5.1 | `opencode/gpt-5-1` | $1.07 |
| Claude Sonnet 4.6 | `opencode/claude-sonnet-4-6` | $3.00 |
| Claude Opus 4.6 | `opencode/claude-opus-4-6` | $5.00 |
| GPT 5.4 Pro | `opencode/gpt-5-4-pro` | $30.00 |

### OpenCode Go

| Model | ID | Est Cost/Request |
|------|-----|-----------------|
| MiniMax M2.5 | `opencode-go/minimax-m2.5` | $0.01 |
| Kimi K2.5 | `opencode-go/kimi-k2.5` | $0.05 |
| GLM-5 | `opencode-go/glm-5` | $0.08 |

---

## Installation

1. Copy desired preset to `~/.config/opencode/opencode.json`
2. Or add to existing config (settings are merged)
3. Restart OpenCode

---

## Monitoring

Check your usage at:
- **Zen**: https://opencode.ai/auth → Console
- **Go**: https://opencode.ai/auth → Console

Use `/models` command in TUI to see available models.
