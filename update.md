# Update CodeXen

> **When user loads this file:** User wants to update CodeXen to latest version.

```
"load update.md"
```

That's it!

---

## Context

When this file is loaded, AI must know:
- User wants to update to latest version
- NOT just reading the file
- AI must execute update steps
- IMPORTANT: Skip copying opencode.json if already exists AND same (preserve user customizations)
- IMPORTANT: Skip copying global-memory if it already contains files

## AI Execution

When executing update, use conditional copy:

```bash
# Compare and update opencode.json if different (preserve user customizations)
if [ -f ~/.config/opencode/opencode.json ]; then
  if ! diff -q core/opencode.json ~/.config/opencode/opencode.json > /dev/null 2>&1; then
    cp core/opencode.json ~/.config/opencode/opencode.json && echo "Updated opencode.json"
  else
    echo "Skipping opencode.json (already up-to-date)"
  fi
else
  cp core/opencode.json ~/.config/opencode/opencode.json && echo "Copied opencode.json"
fi

# Copy global-memory if directory is empty
[ -z "$(ls -A ~/.config/opencode/global-memory 2>/dev/null)" ] && cp -r templates/global-memory/* ~/.config/opencode/global-memory/ || echo "Skipping global-memory (already exists)"
```

## What It Does

| Action | Description |
|--------|-----------|
| Update agents | Copy 23 agents |
| Update skills | Copy 17 skills |
| Update opencode.json (if different) | Preserve user customizations |
| Update memory templates (if not exists) | Skip if exists |
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
# Compare and update opencode.json (preserve user customizations)
if [ -f ~/.config/opencode/opencode.json ]; then
  if ! diff -q core/opencode.json ~/.config/opencode/opencode.json > /dev/null 2>&1; then
    cp core/opencode.json ~/.config/opencode/opencode.json && echo "Updated opencode.json"
  else
    echo "Skipping opencode.json (already up-to-date)"
  fi
else
  cp core/opencode.json ~/.config/opencode/opencode.json && echo "Copied opencode.json"
fi
# Only copy global-memory if directory is empty
[ -z "$(ls -A ~/.config/opencode/global-memory 2>/dev/null)" ] && cp -r templates/global-memory/* ~/.config/opencode/global-memory/ || echo "Skipping global-memory (already exists)"
```

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