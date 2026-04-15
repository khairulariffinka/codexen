# Install CodeXen

> **When user loads this file:** User wants to install/copy CodeXen files to their system.

```
"load install.md"
```

That's it!

---

## Context

When this file is loaded, AI must know:
- User wants to install/copy files to ~/.config/opencode/
- NOT just reading the file
- AI must execute install steps
- IMPORTANT: Skip copying opencode.json if already exists
- IMPORTANT: Skip copying global-memory if it already contains files

## AI Execution

When executing install, use conditional copy:

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

| Action | Location |
|--------|---------|
| Updates 24 agents (compare first) | `~/.config/opencode/agents/` |
| Updates 17 skills (compare first) | `~/.config/opencode/skills/` |
| Copies opencode.json (if different) | `~/.config/opencode/opencode.json` |
| Creates memory templates (if empty) | `~/.config/opencode/global-memory/` |
| **Preserves user's custom agents/skills** | Unchanged |

---

## Quick Start

```bash
git clone https://github.com/khairulariffinka/codexen.git
cd codexen
opencode
```

Then in OpenCode:

```
"load install.md"
```

---

## After Install

1. Restart OpenCode
2. Say: `codexen, hello!`

---

## Troubleshooting

If something goes wrong, manually run:

```bash
mkdir -p ~/.config/opencode/agents ~/.config/opencode/skills ~/.config/opencode/global-memory

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

## Development

To push changes, use a separate branch and create a PR. ALWAYS ask before pushing to main:

```bash
git checkout -b feature/your-feature
git add -A
git commit -m "your message"
git push -u origin feature/your-feature
```

Then create a Pull Request on GitHub.