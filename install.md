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

# Copy global-memory if directory is empty
[ -z "$(ls -A ~/.config/opencode/global-memory 2>/dev/null)" ] && cp -r templates/global-memory/* ~/.config/opencode/global-memory/ || echo "Skipping global-memory (already exists)"
```

## What It Does

| Action | Location |
|--------|---------|
| Copies 23 agents | `~/.config/opencode/agents/` |
| Copies 17 skills | `~/.config/opencode/skills/` |
| Copies opencode.json config | `~/.config/opencode/opencode.json` |
| Creates memory templates (if not exists) | `~/.config/opencode/global-memory/` |

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
cp -r core/agents/* ~/.config/opencode/agents/
cp -r core/skills/* ~/.config/opencode/skills/
# Compare and update opencode.json
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

## Development

To push changes, use a separate branch and create a PR. ALWAYS ask before pushing to main:

```bash
git checkout -b feature/your-feature
git add -A
git commit -m "your message"
git push -u origin feature/your-feature
```

Then create a Pull Request on GitHub.