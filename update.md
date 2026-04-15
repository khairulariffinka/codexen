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
# Compare and update opencode.json if different
if [ -f ~/.config/opencode/opencode.json ]; then
  if ! diff -q core/opencode.json ~/.config/opencode/opencode.json > /dev/null 2>&1; then
    cp core/opencode.json ~/.config/opencode/opencode.json && echo "Updated opencode.json"
  else
    echo "Skipping opencode.json (already up-to-date)"
  fi
else
  cp core/opencode.json ~/.config/opencode/opencode.json && echo "Copied opencode.json"
fi

# Update OUR agents only, preserve user's custom agents
for f in core/agents/*.md; do
  agent_name=$(basename "$f")
  if [ -f ~/.config/opencode/agents/"$agent_name" ]; then
    if ! diff -q "$f" ~/.config/opencode/agents/"$agent_name" > /dev/null 2>&1; then
      cp "$f" ~/.config/opencode/agents/"$agent_name" && echo "Updated: $agent_name"
    else
      echo "Skipping: $agent_name (unchanged)"
    fi
  else
    cp "$f" ~/.config/opencode/agents/ && echo "Added: $agent_name"
  fi
done

# Update OUR skills only, preserve user's custom skills
for f in core/skills/*/*.md; do
  skill_name=$(basename "$f")
  skill_dir=$(dirname "$f" | xargs basename)
  if [ -f ~/.config/opencode/skills/"$skill_dir"/"$skill_name" ]; then
    if ! diff -q "$f" ~/.config/opencode/skills/"$skill_dir"/"$skill_name" > /dev/null 2>&1; then
      cp "$f" ~/.config/opencode/skills/"$skill_dir"/"$skill_name" && echo "Updated: $skill_name"
    else
      echo "Skipping: $skill_name (unchanged)"
    fi
  else
    mkdir -p ~/.config/opencode/skills/"$skill_dir"
    cp "$f" ~/.config/opencode/skills/"$skill_dir"/ && echo "Added: $skill_name"
  fi
done

# Copy global-memory if directory is empty
[ -z "$(ls -A ~/.config/opencode/global-memory 2>/dev/null)" ] && cp -r templates/global-memory/* ~/.config/opencode/global-memory/ || echo "Skipping global-memory (already exists)"
```

## What It Does

| Action | Description |
|--------|-----------|
| Update agents (compare first) | Copy 24 agents |
| Update skills (compare first) | Copy 17 skills |
| Update opencode.json (if different) | Preserve user customizations |
| Update memory templates (if empty) | Skip if exists |
| **Preserves user's custom agents/skills** | Unchanged |
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
# Update OUR agents only, preserve user's custom agents
for f in core/agents/*.md; do
  agent_name=$(basename "$f")
  if [ -f ~/.config/opencode/agents/"$agent_name" ]; then
    if ! diff -q "$f" ~/.config/opencode/agents/"$agent_name" > /dev/null 2>&1; then
      cp "$f" ~/.config/opencode/agents/"$agent_name" && echo "Updated: $agent_name"
    fi
  else
    cp "$f" ~/.config/opencode/agents/ && echo "Added: $agent_name"
  fi
done

# Update OUR skills only, preserve user's custom skills
for f in core/skills/*/*.md; do
  skill_name=$(basename "$f")
  skill_dir=$(dirname "$f" | xargs basename)
  mkdir -p ~/.config/opencode/skills/"$skill_dir"
  if [ -f ~/.config/opencode/skills/"$skill_dir"/"$skill_name" ]; then
    if ! diff -q "$f" ~/.config/opencode/skills/"$skill_dir"/"$skill_name" > /dev/null 2>&1; then
      cp "$f" ~/.config/opencode/skills/"$skill_dir"/"$skill_name" && echo "Updated: $skill_name"
    fi
  else
    cp "$f" ~/.config/opencode/skills/"$skill_dir"/ && echo "Added: $skill_name"
  fi
done

# Compare and update opencode.json
if [ -f ~/.config/opencode/opencode.json ]; then
  if ! diff -q core/opencode.json ~/.config/opencode/opencode.json > /dev/null 2>&1; then
    cp core/opencode.json ~/.config/opencode/opencode.json && echo "Updated opencode.json"
  fi
else
  cp core/opencode.json ~/.config/opencode/opencode.json && echo "Copied opencode.json"
fi

# Copy global-memory if directory is empty
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