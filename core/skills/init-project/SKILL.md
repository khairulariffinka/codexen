---
name: init-project
description: Initialize new project with essential files - integrates with CodeXen (generic for any language)
trigger: init project | new project | setup project
---

## Init Project Skill

Auto-generate essential files untuk new project.
Integrates dengan CodeXen's global memory system.

---

## When to Use

- New project folder (empty or just created)
- First time setting up project for CodeXen

---

## Workflow

```
1. User: "init project"
2. Skill: Auto-create all files in current folder
3. Skill: Ask user to update AGENTS.md
4. Ready untuk develop!
```

---

<!-- @exec -->

## Execute

```bash
mkdir -p docs

AGENTS_FILE="AGENTS.md"
if [ -f "$AGENTS_FILE" ]; then
  echo "AGENTS.md dah ada, skip..."
else
cat > AGENTS.md << 'AGENTS_EOF'
# Project: PROJECT_NAME

## Status
- [ ] Initial setup

## Tech Stack
- **Language:**
- **Framework:**
- **Database:**
- **Hosting:**

## Project Mode
**Description:**

## Core Features (MVP)

### 1. Feature Name
- Description

## Architecture
```
project/
├── src/
├── components/
└── tests/
```

## Decisions Log
- DATE: Initial setup - Pending tech stack decision

---
**Last Updated:** DATE
**Status:** IN PROGRESS
AGENTS_EOF

sed -i "s/PROJECT_NAME/$(basename "$PWD")/g" AGENTS.md
sed -i "s/DATE/$(date +%Y-%m-%d)/g" AGENTS.md
fi

cat > docs/current-state.md << 'EOF'
# PROJECT_NAME - Current State

> **Last Updated:** DATE
> **Status:** IN PROGRESS

---

## Project Overview

| Field | Value |
|-------|-------|
| **Project Name** | PROJECT_NAME |
| **Status** | In Progress |
| **Started** | DATE |

---

## Implemented Features

### Core Features
- [ ] Feature 1

### Infrastructure
- [ ] Basic setup

---

## File Structure

```
PROJECT_NAME/
├── src/
├── docs/
└── tests/
```

---

## Configuration

User perlu update sendiri based on tech stack.

---

## How to Run

B depends on tech stack. User will update based on AGENTS.md.

---

## Notes

- Initial setup completed
- Add features as you build

---

**Version 1.0** - DATE - Initial setup
EOF

sed -i "s/PROJECT_NAME/$(basename "$PWD")/g" docs/current-state.md
sed -i "s/DATE/$(date +%Y-%m-%d)/g" docs/current-state.md

cat > docs/session-diary.md << 'EOF'
# Session Diary - Development Log

> Log setiap session development.

---

## Session Summary

| Metric | Value |
|--------|-------|
| Total Sessions | 1 |
| First Session | DATE |
| Last Session | DATE |
| Git Commits | 0 |
| Status | IN PROGRESS |

---

## DATE - Session #1 (Initial Setup)

**Time:** TIME
**Duration:** ~
**Project:** PROJECT_NAME

### Tasks Done

1. **Project Initialization**:
   - Created project structure
   - Initialized git repository
   - Created AGENTS.md
   - Created docs/current-state.md
   - Created docs/session-diary.md

### Status
- ✅ COMPLETE - INITIAL SETUP DONE

---

*Add new sessions above this line*
EOF

sed -i "s/DATE/$(date +%Y-%m-%d)/g" docs/session-diary.md
sed -i "s/TIME/$(date +"%H:%M")/g" docs/session-diary.md
sed -i "s/PROJECT_NAME/$(basename "$PWD")/g" docs/session-diary.md

cat > docs/AI-AGENT-PROTOCOL.md << 'EOF'
# AI Agent Documentation Protocol

> **Purpose:** Standard protocol for AI agents
> **Usage:** After completing any development session

---

## Session End Protocol

### Step 1: Update AGENTS.md
- [ ] Mark feature yang siap
- [ ] Update Decisions Log
- [ ] Update "Last Updated"

### Step 2: Update docs/current-state.md
- [ ] Update "Last Updated"
- [ ] Update feature list

### Step 3: Update docs/session-diary.md
- Add new entry at TOP

### Step 4: Update Work Diary (Global Memory)
```bash
WORK_DIARY_DIR="$HOME/.config/opencode/global-memory/work-diary"
mkdir -p "$WORK_DIARY_DIR"
WORK_DIARY="$WORK_DIARY_DIR/diary-$(date +%Y-%m).md"

if [ ! -f "$WORK_DIARY" ]; then
  cp "$HOME/.config/opencode/global-memory/work-diary/diary-YYYY-MM.md" "$WORK_DIARY" 2>/dev/null || true
fi

if [ -f "$WORK_DIARY" ]; then
  SESSION_DATE=$(date +%Y-%m-%d)
  SESSION_TIME=$(date +"%H:%M")
  PROJECT_NAME=$(basename "$PWD")
  
  sed -i "1i\\
### $SESSION_DATE - Session #\\
**Time:** $SESSION_TIME\\
**Project:** $PROJECT_NAME\\
**Duration:** ~\\
\\
**Summary:**\\
- Initial setup\\
\\
**Tasks:**\\
- [x] Project initialization\\
\\
---\\
" "$WORK_DIARY"
fi
```

### Step 5: Git Commit
```bash
git add -A
git commit -m "feat: description"
```

---

## Quick Reference

| File | Purpose |
|------|---------|
| `AGENTS.md` | AI context |
| `docs/current-state.md` | Snapshot |
| `docs/session-diary.md` | Log |

---

**Version:** 1.0
EOF

cat > .gitignore << 'EOF'
node_modules/
__pycache__/
*.pyc
.env
.env.local
dist/
build/
.vscode/
.idea/
*.swp
*.swo
.DS_Store
Thumbs.db
*.log
npm-debug.log*
yarn-error.log
pnpm-debug.log*
logs/
coverage/
tmp/
temp/
*.tmp
*.egg-info/
.pytest_cache/
vendor/
EOF

if [ ! -f ".env.example" ] && [ -f ".env" ]; then
cp .env .env.example
fi

if [ -f "package.json" ] || [ -f "requirements.txt" ] || [ -f "go.mod" ] || [ -f "Cargo.toml" ]; then
:
else
echo "# Dependencies and package files will be created by user"
fi

if [ ! -d .git ]; then
git init
fi

echo ""
echo "=========================================="
echo "  INIT PROJECT COMPLETE!"
echo "=========================================="
echo ""
echo "Files created:"
echo "  ├── AGENTS.md"
echo "  ├── docs/"
echo "  │   ├── current-state.md"
echo "  │   ├── session-diary.md"
echo "  │   └── AI-AGENT-PROTOCOL.md"
echo "  ├── .gitignore"
if [ -f .env.example ]; then
echo "  └── .env.example"
fi
echo ""
echo "=========================================="
echo ""
```

---

## Output

```
✅ INIT PROJECT COMPLETE!

Files created:
├── AGENTS.md
├── docs/
│   ├── current-state.md
│   ├── session-diary.md
│   └── AI-AGENT-PROTOCOL.md
└── .gitignore

Next steps:
1. Update AGENTS.md with your tech stack
2. Add your package files (package.json, requirements.txt, etc.)
3. Start: "build [feature]"
```

---

## Integration with CodeXen

After init, CodeXen will:
1. Read `AGENTS.md` for tech stack
2. Use it for all subsequent work
3. Update `docs/session-diary.md` at end of each session