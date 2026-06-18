# CodeXen Tutorials

> New here? Sit down, I'll teach you. 🪑

---

## What Is This Thing?

CodeXen = A team of 25 AI agents working for you.

You type a command, CodeXen handles everything. From writing code to reviewing it — all done automatically.

---

## Getting Started (3 Simple Steps)

### 1. Install

```bash
git clone https://github.com/khairulariffinka/codexen.git
cd codexen
"load install.md"
```

Press `TAB` until you see `codexen`.

### 2. Type a Command

```
build a login page
```

### 3. Done.

Seriously, that's it.

---

## Daily Use Examples

### Morning (Start Work)

```
review yesterday's progress
```

CodeXen shows what you did yesterday, what's pending, what's next.

### Build New Feature

```
create API for user registration
```

What happens:
1. @planner lists all tasks
2. @backend-coder writes the API
3. @test-coder writes tests
4. @auditor reviews the code
5. @git-manager commits (if you approve)

All automatic. You type once.

### Found a Bug

```
debug: login returns 500 error
```

CodeXen finds the cause, suggests a fix, and applies it. You just review.

### Review Code

```
review file UserController.php
```

@auditor checks security, performance, code style — all at once.

### Done for the Day

```
bye
```

Auto-saves everything. Pick up where you left off tomorrow.

---

## Most Important Commands

### Coding

| Type | What Happens |
|------|--------------|
| `build [anything]` | CodeXen creates it |
| `review [file]` | Checks code quality |
| `debug [error]` | Finds & fixes bugs |
| `test [module]` | Writes tests |

### Memory

| Type | What Happens |
|------|--------------|
| `save` | Save progress now |
| `bye` / `done` | Auto-save & exit |
| `search [topic]` | Find past work |

### Git

| Type | What Happens |
|------|--------------|
| `commit` | Commit code |
| `push` | Push to GitHub |

---

## 6 Modes (How CodeXen Works)

| Mode | Type | Use When |
|------|------|----------|
| **Dev** | `build [task]` | Normal, full workflow |
| **Quick** | `quick, [task]` | In a hurry, skip audits |
| **Review** | `review, [file]` | Check only, no changes |
| **Refactor** | `refactor, [file]` | Improve old code |
| **Debug** | `debug, [error]` | Find bugs |
| **Test** | `test, [module]` | Write tests only |

### Examples

```
# Normal (full workflow)
build API for products

# Quick (skip audit)
quick, build simple API

# Review only
review, check auth module

# Bug found
debug, payment return 500

# Write tests
test, write tests for UserService
```

---

## Who Works Here? (25 Agents)

CodeXen has 25 "workers". Each one has a specialty.

### Coders (Write Code)

| Agent | Does What |
|-------|-----------|
| `@backend-coder` | APIs, databases, server |
| `@frontend-coder` | UI, components, styling |
| `@test-coder` | Writes tests |
| `@devops-coder` | Docker, CI/CD |
| `@refactor-expert` | Improves old code |
| `@database-expert` | Database design |
| `@api-designer` | Designs APIs |

### Auditors (Review Code)

| Agent | Does What |
|-------|-----------|
| `@auditor` | Reviews everything |
| `@security-auditor` | Checks security |
| `@performance-auditor` | Checks speed |
| `@style-auditor` | Checks code style |

### Planners (Plan Work)

| Agent | Does What |
|-------|-----------|
| `@planner` | Organizes tasks |
| `@research` | Studies codebase |

### Memory (Remembers Things)

| Agent | Does What |
|-------|-----------|
| `@memory` | Remembers everything |
| `@decision-log` | Saves decisions |

### Utility (Other Stuff)

| Agent | Does What |
|-------|-----------|
| `@git-manager` | Git operations |
| `@docs-manager` | Writes docs |
| `@doc-scout` | Finds library docs |

### Spec (Documents)

| Agent | Does What |
|-------|-----------|
| `@brs-manager` | Business requirements |
| `@srs-manager` | Software requirements |
| `@sds-manager` | System design |

---

## Memory System (CodeXen Remembers Everything)

### What Gets Saved

| Thing | Example |
|-------|---------|
| **Decisions** | "We use JWT, not sessions" |
| **Patterns** | "This project uses Repository pattern" |
| **Lessons** | "Don't forget to add index on foreign key" |
| **Progress** | "Task 3/10 complete" |

### Memory Commands

```
@memory, save                      # Save now
@memory, show lessons about auth   # See past lessons
@memory, budget                    # Check token usage
@memory, compress                  # Save tokens
```

### Auto-Save

CodeXen auto-saves when:
- Context 80% full → auto-checkpoint
- You type `bye` / `done` → save & exit

---

## Context Monitor (New in v0.9.0)

CodeXen monitors how many "tokens" you've used. Like a data plan.

### Thresholds

| % | Action |
|---|--------|
| 70% | Warning |
| 80% | Auto-checkpoint |
| 90% | Compress data |
| 95% | Critical alert |

### Check Context

```
/context
```

Shows how many tokens used, how many left.

---

## Tips & Tricks

### 1. Be Specific

❌ `build feature` (too vague)
✅ `build API for CRUD users with JWT auth` (specific)

### 2. Use Modes

In a hurry? Use `quick,`
Want review? Use `review,`
Found a bug? Use `debug,`

### 3. Don't Be Afraid to Try

CodeXen won't break your code. Everything has backups.

### 4. Check Lessons

Before starting a new task, CodeXen auto-checks past lessons. So you don't repeat mistakes.

### 5. Save Often

```
save
```

Save little by little. No harm done.

---

## Full Workflow Example

```
# 1. Start session
(review yesterday's progress)

# 2. Build new feature
(build e-commerce checkout page)

# 3. CodeXen works
@planner → Lists 8 tasks
@backend-coder → Builds checkout API
@frontend-coder → Builds checkout UI
@test-coder → Writes tests
@auditor → Reviews everything
@security → Scans for vulnerabilities

# 4. Review
(commit ready, want to check first?)

# 5. Happy with it
(commit, push)

# 6. Done for the day
(bye)
```

---

## Troubleshooting

### CodeXen Did Something Wrong

```
[3] ❌ Wrong
```

Give a rating, CodeXen learns. Won't repeat next time.

### Context Almost Full

```
/context
```

If almost full:
```
@memory, compress
```

### Want to Start Fresh

```
@memory, compress aggressive
```

Removes everything except decisions & preferences.

---

## FAQ

**Q: Is CodeXen free?**
A: CodeXen is free. You pay for the API key (OpenAI, Claude, etc.).

**Q: What languages can I use?**
A: English, Malay, mix — whatever. CodeXen understands.

**Q: What frameworks are supported?**
A: All of them. React, Vue, Laravel, Django, Express, Next.js, etc.

**Q: Do I need to be online?**
A: Yes, because it uses AI APIs.

**Q: Is my code shared?**
A: No. Your code stays on your computer.

---

## Shortcut Table

| Want To | Type |
|---------|------|
| Build feature | `build [description]` |
| Review code | `review [file]` |
| Fix bug | `debug [error]` |
| Write tests | `test [module]` |
| Commit | `commit` |
| Save | `save` |
| Exit | `bye` / `done` |
| Check context | `/context` |
| Find past work | `search [topic]` |

---

**Last Updated:** 2026-06-18
**Version:** 0.9.0

> Got a question? Just type it. CodeXen doesn't judge. 😄
