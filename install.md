# Install CodeXen

```
"load install.md"
```

That's it!

---

## What It Does

| Action | Location |
|--------|---------|
| Copies 23 agents | `~/.config/opencode/agents/` |
| Copies 17 skills | `~/.config/opencode/skills/` |
| Creates memory templates | `~/.config/opencode/global-memory/` |

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
cp -r templates/global-memory/* ~/.config/opencode/global-memory/
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