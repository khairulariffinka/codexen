# OpenCode Model Configs

Quick and easy model configuration switching for OpenCode.

## Quick Start (Recommended)

### Use CodeXen Skill

Just tell CodeXen:
```
"switch to free config"
"switch to budget"
"switch to quality"
"switch to optimized"
```

CodeXen will:
1. Delete old config first (to avoid conflicts)
2. Copy selected config to `~/.config/opencode/opencode.json`
3. You restart OpenCode

---

## Config Files

| File | Description |
|------|-------------|
| `config-free.json` | Free models only (big-pickle) |
| `config-budget.json` | Budget-friendly (kimi-k2.5) |
| `config-quality.json` | Best quality (Claude Sonnet) |
| `optimized.json` | Smart hybrid selection |
| `model-presets.md` | Complete model reference |

---

## Manual Copy (Alternative)

```bash
# IMPORTANT: Remove old config first
rm -f ~/.config/opencode/opencode.json

# Example: Switch to budget config
cp templates/config/config-budget.json ~/.config/opencode/opencode.json

# Restart OpenCode
```

---

## Config Options

| Config | Cost/Month | Best For | Models Used |
|--------|-----------|----------|-------------|
| **Free** | $0 | Testing, learning | big-pickle |
| **Budget** | $5-10 | Daily coding, freelance | kimi-k2.5, minimax-m2.5 |
| **Quality** | $30-50 | Professional work | Claude Sonnet, Opus |
| **Optimized** | Mixed | Power users | Smart selection |

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Config not applied | Restart OpenCode |
| Old settings persist | Delete old config first: `rm -f ~/.config/opencode/opencode.json` |
| Model not available | Check your OpenCode subscription |
| Out of credits | Switch to Free config or add more credit |

---

## More Info

See `model-presets.md` for detailed model information.