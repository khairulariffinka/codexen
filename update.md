# Update CodeXen

```
"load update.md"
```

That's it!

---

## What It Does

| Action | Description |
|--------|-----------|
| Update agents | Copy 23 agents |
| Update skills | Copy 14 skills |
| Update version | Mark as current |

---

## Quick Update

In OpenCode:

```
"load update.md"
```

---

## Version

Current: **0.3.0**

---

## Troubleshooting

If update doesn't work, manually run:

```bash
cp -r core/agents/* ~/.config/opencode/agents/
cp -r core/skills/* ~/.config/opencode/skills/
cp -r templates/skills/* ~/.config/opencode/skills/
```