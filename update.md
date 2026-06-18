# Update CodeXen

> **When user loads this file:** User wants to update CodeXen to latest version.

```
"load update.md"
```

That's it!

---

## Options

| Option | Description |
|--------|-------------|
| (default) | Full update with backup |
| `--dry-run` | Preview only, no changes |

To use, append after command: `"load update.md --dry-run"`

---

## Changelog

### v0.9.0 (Current)
- ADD: Context Monitor Plugin (`core/.opencode/plugin/context-monitor.ts`)
- ADD: `/context` slash command (`core/.opencode/command/context.md`)
- ADD: Checkpoint Writer agent (`core/agents/checkpoint-writer.md`)
- ADD: `@memory read-budgeted` for token-budgeted file reading
- ADD: `@memory auto-dream-check` and `@memory auto-distill-check`
- ADD: Plugin install/update with conflict resolution
- CHANGE: 25 agents (added checkpoint-writer)
- CHANGE: Generic opencode.json for all users

### v0.8.0
- ADD: Token optimization (compress mode with user preferences, compress-file, terse subagent output)
- ADD: Model-picker (task-based model selection)
- CHANGE: Removed default model setting

### v0.7.0
- ADD: 11 custom slash commands (`/audit`, `/test`, `/lint`, `/review`, `/plan`, `/brs`, `/srs`, `/sds`, `/commit`, `/refactor`, `/docker`)
- ADD: Model optimization (`model` + `small_model` for cost savings)
- ADD: LSP integration (`lsp: true` for code intelligence)
- ADD: Auto-formatters (`formatter: true` for Prettier, Ruff, etc.)
- ADD: Auto-compaction (`compaction: auto + prune` to prevent context overflow)
- ADD: Instructions config (multi-file instruction loading)
- ADD: Fine-grained permissions per agent role (coders=edit, auditors=read-only, etc.)
- ADD: `copy_core_commands` in install config
- ADD: Smart Recall — auto-suggest lessons based on task keywords
- ADD: Priority Scoring — rank lessons by frequency/severity/recency
- ADD: Agent Performance Tracking — track success/failure rate per agent
- ADD: Smart Routing — auto-select best agent based on track record
- ADD: Goal/Stop Condition — `/goal` command with judge evaluation
- ADD: Dream & Distill — `/dream` extract knowledge, `/distill` package workflows
- ADD: Auto-Checkpoint — save session state when context nears limit
- ADD: Mandatory Auto-Enforcement — 17 mandatory steps, zero exceptions

### v0.6.0
- REFACTOR: All 17 SKILL.md files standardized with OpenCode-compatible frontmatter
- REFACTOR: All 24 agent .md files standardized with consistent permission format
- REFACTOR: Removed `name:` field from agent frontmatter (OpenCode uses filename)
- ADD: opencode.json now registers all 24 subagents with mode and hidden flags
- ADD: validate.sh enhanced with SKILL.md name validation

### v0.5.0
- ADD: Self-healing orchestration (8 error recovery scenarios)
- ADD: Feedback loop with lessons learned system (lessons.md)
- ADD: CI/CD validation script (scripts/validate.sh, 12 checks)
- ADD: Token budgeting system with auto-triggers and sliding window
- ADD: Guardrails (ask before modify, circuit breaker, rate limit, scope)
- ADD: Open source files (CONTRIBUTING.md, SECURITY.md, CODE_OF_CONDUCT.md)

### v0.4.0
- Initial release with conditional update logic
- Preserve user customizations

---

## Context

When this file is loaded, AI must know:
- User wants to update to latest version
- NOT just reading the file
- AI must execute update steps
- IMPORTANT: Skip copying opencode.json if already exists AND same (preserve user customizations)
- IMPORTANT: Copy only missing global-memory files (never overwrite user data)

## AI Execution

When executing update, use conditional copy:

```bash
# Check for dry-run mode
DRY_RUN=false
if [[ "$*" == *"--dry-run"* ]]; then
  DRY_RUN=true
  echo "🔍 DRY-RUN MODE: No changes will be made"
  echo ""
fi

# Create backup before update (unless dry-run)
if [ "$DRY_RUN" = false ]; then
  BACKUP_DIR="$HOME/.config/opencode.backup-$(date +%Y-%m-%d-%H%M)"
  if [ -d ~/.config/opencode ]; then
    cp -r ~/.config/opencode "$BACKUP_DIR" && echo "✅ Backup created: $BACKUP_DIR"
  fi
fi

# Function to update or preview with conflict resolution
update_or_skip() {
  local source="$1"
  local dest="$2"
  local name="$3"

  if [ ! -f "$dest" ]; then
    [ "$DRY_RUN" = true ] && echo "[DRY-RUN] Would add: $name" || cp "$source" "$dest" && echo "Added: $name"
  elif ! diff -q "$source" "$dest" > /dev/null 2>&1; then
    # File exists and is different - ask user
    if [ "$DRY_RUN" = true ]; then
      echo "[DRY-RUN] Would update: $name (CONFLICT - user has custom version)"
      echo "         Run without --dry-run to resolve"
    else
      echo ""
      echo "⚠️  CONFLICT: $name differs from CodeXen version"
      echo "    [1] Keep mine (custom) - skip update"
      echo "    [2] Use CodeXen version - overwrite"
      echo "    [3] Show diff - see differences"
      read -p "Choice [1]: " choice
      case "$choice" in
        2)
          cp "$source" "$dest" && echo "Updated: $name"
          ;;
        3)
          echo "--- Your version ---"
          head -20 "$dest"
          echo "--- CodeXen version ---"
          head -20 "$source"
          echo ""
          read -p "Choose [1=keep mine, 2=use codexen]: " choice2
          case "$choice2" in
            2) cp "$source" "$dest" && echo "Updated: $name" ;;
            *) echo "Keeping your version" ;;
          esac
          ;;
        *)
          echo "Keeping your version"
          ;;
      esac
    fi
  else
    echo "Skipping: $name (unchanged)"
  fi
}

echo ""
echo "=== Updating Agents ==="
mkdir -p ~/.config/opencode/agents

# Find user's primary agent (mode: primary)
primary_agent_file=$(ls ~/.config/opencode/agents/*.md 2>/dev/null | xargs -I{} grep -l "^mode: primary" {} 2>/dev/null | head -1)

if [ -n "$primary_agent_file" ]; then
  # User has primary agent - update content but preserve name and mode
  primary_agent_name=$(basename "$primary_agent_file" .md)
  echo "Found primary agent: $primary_agent_name"
  if diff -q core/agents/codexen.md "$primary_agent_file" > /dev/null 2>&1; then
    echo "Skipping: $primary_agent_name (unchanged)"
  else
    echo "⚠️  CONFLICT: $primary_agent_name differs from CodeXen version"
    echo "    [1] Keep mine (custom) - skip update"
    echo "    [2] Use CodeXen version - overwrite (preserves name & mode)"
    read -p "Choice [1]: " choice
    if [ "$choice" = "2" ]; then
      cp core/agents/codexen.md "$primary_agent_file"
      sed -i 's/^name: codexen$/name: '"$primary_agent_name"'/' "$primary_agent_file"
      sed -i 's/^mode: subagent/mode: primary/' "$primary_agent_file"
      echo "Updated: $primary_agent_name"
    else
      echo "Keeping your version"
    fi
  fi
else
  # No primary agent - create default
  echo "No primary agent found, creating codexen.md"
  update_or_skip "core/agents/codexen.md" "$HOME/.config/opencode/agents/codexen.md" "codexen"
fi

echo ""
echo "=== Updating Subagents ==="
for f in core/agents/*.md; do
  agent_name=$(basename "$f")
  dest=~/.config/opencode/agents/"$agent_name"
  update_or_skip "$f" "$dest" "$agent_name"
done

echo ""
echo "=== Updating Skills ==="
for f in core/skills/*/*.md; do
  skill_name=$(basename "$f")
  skill_dir=$(basename "$(dirname "$f")")
  dest=~/.config/opencode/skills/"$skill_dir"/"$skill_name"
  mkdir -p ~/.config/opencode/skills/"$skill_dir"
  update_or_skip "$f" "$dest" "$skill_dir"
done

echo ""
echo "=== Updating Plugins (.opencode) ==="
mkdir -p ~/.config/opencode/plugin
mkdir -p ~/.config/opencode/command

# Update plugins
for f in core/.opencode/plugin/*.ts; do
  if [ -f "$f" ]; then
    fname=$(basename "$f")
    dest=~/.config/opencode/plugin/"$fname"
    update_or_skip "$f" "$dest" "plugin/$fname"
  fi
done

# Update commands
for f in core/.opencode/command/*.md; do
  if [ -f "$f" ]; then
    fname=$(basename "$f")
    dest=~/.config/opencode/command/"$fname"
    update_or_skip "$f" "$dest" "command/$fname"
  fi
done

# Update package.json (with conflict resolution)
if [ -f core/.opencode/package.json ]; then
  dest_pkg=~/.config/opencode/package.json
  if [ ! -f "$dest_pkg" ]; then
    [ "$DRY_RUN" = true ] && echo "[DRY-RUN] Would add: package.json" || cp core/.opencode/package.json "$dest_pkg" && echo "Added: package.json"
  elif ! diff -q core/.opencode/package.json "$dest_pkg" > /dev/null 2>&1; then
    if [ "$DRY_RUN" = true ]; then
      echo "[DRY-RUN] Would update: package.json (CONFLICT - user has custom package.json)"
    else
      echo ""
      echo "⚠️  CONFLICT: package.json differs from CodeXen version"
      echo "    [1] Keep mine - skip (RECOMMENDED)"
      echo "    [2] Use CodeXen version - overwrite"
      echo "    [3] Merge - add new dependencies"
      read -p "Choice [1]: " choice
      case "$choice" in
        2) cp core/.opencode/package.json "$dest_pkg" && echo "Updated: package.json" ;;
        3)
          if command -v jq >/dev/null 2>&1; then
            jq -s '.[0] * .[1]' "$dest_pkg" core/.opencode/package.json > "$dest_pkg.tmp" && \
            mv "$dest_pkg.tmp" "$dest_pkg" && \
            echo "Merged: package.json"
          else
            echo "jq not found - keeping your config. Install jq for merge."
          fi
          ;;
        *) echo "Keeping your config" ;;
      esac
    fi
  else
    echo "Skipping: package.json (unchanged)"
  fi
fi

echo ""
echo "=== Updating Config ==="
# opencode.json - merge to preserve user settings
if [ -f ~/.config/opencode/opencode.json ]; then
  if ! diff -q core/opencode.json ~/.config/opencode/opencode.json > /dev/null 2>&1; then
    # User has custom config - prompt with merge option
    if [ "$DRY_RUN" = true ]; then
      echo "[DRY-RUN] Would update: opencode.json (CONFLICT - user has custom config)"
    else
      echo ""
      echo "⚠️  CONFLICT: opencode.json differs from CodeXen version"
      echo "    [1] Keep mine - skip, don't change (RECOMMENDED)"
      echo "    [2] Merge - add CodeXen settings to mine"
      echo "    [3] Show diff - see before deciding"
      read -p "Choice [1]: " choice
      case "$choice" in
        2)
          # Merge JSON - CodeXen adds new keys, keeps user values
          if command -v jq >/dev/null 2>&1; then
            jq -s '.[0] * .[1]' ~/.config/opencode/opencode.json core/opencode.json > ~/.config/opencode/opencode.json.tmp && \
            mv ~/.config/opencode/opencode.json.tmp ~/.config/opencode/opencode.json && \
            echo "Merged opencode.json (your settings kept + new CodeXen settings added)"
          else
            # No jq - fallback to keeping user config
            echo "jq not found - keeping your config (install jq for merge)"
          fi
          ;;
        3)
          echo "--- Your config ---"
          cat ~/.config/opencode/opencode.json
          echo "--- CodeXen config ---"
          cat core/opencode.json
          echo ""
          read -p "Choose [1=keep mine, 2=merge]: " choice2
          case "$choice2" in
            2)
              if command -v jq >/dev/null 2>&1; then
                jq -s '.[0] * .[1]' ~/.config/opencode/opencode.json core/opencode.json > ~/.config/opencode/opencode.json.tmp && \
                mv ~/.config/opencode/opencode.json.tmp ~/.config/opencode/opencode.json && \
                echo "Merged opencode.json"
              else
                echo "jq not found - keeping your config"
              fi
              ;;
            *) echo "Keeping your config" ;;
          esac
          ;;
        *)
          echo "Keeping your config"
          ;;
      esac
    fi
  else
    echo "Skipping opencode.json (unchanged)"
  fi
else
  [ "$DRY_RUN" = true ] && echo "[DRY-RUN] Would add: opencode.json" || cp core/opencode.json ~/.config/opencode/opencode.json && echo "Copied opencode.json"
fi

# global-memory - copy missing files only
echo ""
echo "=== Updating Global Memory ==="
gm_dir="$HOME/.config/opencode/global-memory"
mkdir -p "$gm_dir/work-diary/archive"
for f in "$SCRIPT_DIR"/templates/global-memory/*; do
  fname=$(basename "$f")
  dest="$gm_dir/$fname"
  if [ -f "$f" ]; then
    if [ ! -f "$dest" ]; then
      [ "$DRY_RUN" = true ] && echo "[DRY-RUN] Would add: $fname" || { cp "$f" "$dest" && echo "Added: $fname"; }
    else
      echo "Skipping: $fname (already exists)"
    fi
  fi
done
# Also copy work-diary template if missing
if [ ! -f "$gm_dir/work-diary/diary-YYYY-MM.md" ]; then
  [ "$DRY_RUN" = true ] && echo "[DRY-RUN] Would add: work-diary/diary-YYYY-MM.md" || { cp "$SCRIPT_DIR/templates/global-memory/work-diary/diary-YYYY-MM.md" "$gm_dir/work-diary/" && echo "Added: work-diary/diary-YYYY-MM.md"; }
fi

# validation script
echo ""
echo "=== Installing Validation Script ==="
mkdir -p ~/.config/opencode/scripts
update_or_skip "scripts/validate.sh" "$HOME/.config/opencode/scripts/validate.sh" "validate.sh"

echo ""
[ "$DRY_RUN" = true ] && echo "🔍 DRY-RUN complete. Run without --dry-run to apply." || echo "✅ Update complete!"
```

## What It Does

| Action | Description |
|--------|-----------|
| Update agents (compare first) | Copy 24 agents |
| Update skills (compare first) | Copy 19 skills |
| Update global-memory (missing files only) | Copy templates if missing |
| Update opencode.json (if different) | Preserve user customizations |
| Update memory templates (if empty) | Skip if exists |
| Update validation script | Copy to ~/.config/opencode/scripts/ |
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

Current: **0.8.0**

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

# Copy missing global-memory templates
for f in templates/global-memory/*; do
  fname=$(basename "$f")
  dest=~/.config/opencode/global-memory/"$fname"
  if [ -f "$f" ] && [ ! -f "$dest" ]; then
    cp "$f" "$dest" && echo "Added: $fname"
  fi
done
[ ! -f ~/.config/opencode/global-memory/work-diary/diary-YYYY-MM.md ] && mkdir -p ~/.config/opencode/global-memory/work-diary && cp templates/global-memory/work-diary/diary-YYYY-MM.md ~/.config/opencode/global-memory/work-diary/ && echo "Added: work-diary/diary-YYYY-MM.md"
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