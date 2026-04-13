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
| Update skills | Copy 17 skills |
| Update version | Mark as current |

---

## Quick Update

In OpenCode:

```
"load update.md"
```

---

## Version

Current: **0.4.0**

---

## Troubleshooting

If update doesn't work, manually run:

```bash
cp -r core/agents/* ~/.config/opencode/agents/
cp -r core/skills/* ~/.config/opencode/skills/
cp -r templates/global-memory/* ~/.config/opencode/global-memory/
```

### Important: Preserve Custom Names

If you renamed `codexen.md` to a custom name (e.g., `myagent.md`), the update will restore it to the original name. To preserve your custom name:

1. After updating, rename the file manually:

```bash
mv ~/.config/opencode/agents/codexen.md ~/.config/opencode/agents/myagent.md
```

2. Or use the rename feature before updating:

---

## Development Workflow

For contributors - NEVER push directly to main. ALWAYS ask before pushing. Use branches:

```bash
# Create a new branch
git checkout -b feature/your-feature

# Make changes and commit
git add -A
git commit -m "feat: your feature"

# Push and create PR
git push -u origin feature/your-feature
# Then create Pull Request on GitHub

# IMPORTANT: Ask before pushing to main
```