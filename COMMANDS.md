# CodeXen Commands Reference

Complete reference for all CodeXen commands and operations.

---

## Table of Contents

1. [Basic Commands](#basic-commands)
2. [Slash Commands (OpenCode Native)](#slash-commands-opencode-native)
3. [Development Commands](#development-commands)
4. [Operating Modes](#operating-modes)
5. [Subagent Commands](#subagent-commands)
6. [Setup Commands](#setup-commands)
7. [Exit Commands](#exit-commands)

---

## Basic Commands

### How to Access CodeXen

#### Primary Agent (Tab Key)
Press **TAB** to cycle through primary agents. CodeXen is configured with `mode: all`, making it accessible in the Tab cycle:

```
[TAB] cycles: Build → Plan → codexen → Build...
```

Once selected, give your task directly:

```bash
build user authentication system
```

#### Subagent (@ Mention)
You can also invoke CodeXen as a subagent from any other agent:

```bash
@codexen, review this code
```

---

### `hello` / `hi`
Greeting command to start interaction with CodeXen.

```bash
codexen, hello!
```

### `help`
Display all available commands with descriptions.

```bash
help
```

### `status`
Show current project status including:
- Project name and path
- Git status (if in a git repository)
- Recent files modified
- Active tasks
- Session information

```bash
status
```

### `save`
Save current work session to memory.

```bash
save
```

---

## Slash Commands (OpenCode Native)

CodeXen provides slash commands that work directly in OpenCode's TUI. Type `/` followed by the command name.

| Command | Description | Example |
|---------|-------------|---------|
| `/audit` | Full security + quality audit | `/audit` |
| `/test` | Run tests with coverage report | `/test` |
| `/lint` | Lint and auto-fix code issues | `/lint` |
| `/review` | Code review recent changes | `/review` |
| `/plan` | Create implementation plan | `/plan user auth` |
| `/brs` | Generate Business Requirements | `/brs e-commerce system` |
| `/srs` | Generate Software Requirements | `/srs from BRS` |
| `/sds` | Generate System Design | `/sds from SRS` |
| `/commit` | Smart git commit (conventional) | `/commit` |
| `/refactor` | Refactor with SOLID principles | `/refactor UserService` |
| `/init-codexen` | Initialize CodeXen in project | `/init-codexen` |
| `/docker` | Setup Docker configuration | `/docker` |

### OpenCode Built-in Commands

| Command | Description |
|---------|-------------|
| `/init` | Create/update AGENTS.md |
| `/connect` | Add provider API keys |
| `/models` | List available models |
| `/new` | Start new session |
| `/undo` | Undo last message + file changes |
| `/redo` | Redo undone message |
| `/share` | Share current session |
| `/compact` | Compact session context |
| `/editor` | Open external editor |
| `/export` | Export session to Markdown |
| `/help` | Show help dialog |
| `/themes` | List available themes |

---

## Development Commands

### `build [feature]`
Build a new feature with full workflow (plan → code → audit → commit).

```bash
build a user authentication system
build a login page with email and password
```

### `create [thing]`
Create APIs, components, or other project elements.

```bash
create a REST API for products
create a login form component
create Docker configuration
```

### `plan [task]`
Create an implementation plan without executing it.

```bash
plan user authentication feature
plan database schema for e-commerce
```

### `review [module]`
Review existing code for issues and improvements.

```bash
review the auth module
review src/utils/helpers.ts
```

### `debug [problem]`
Troubleshoot errors with verbose logging.

```bash
debug: login returns 500 error
debug: Cannot read property 'x' of undefined
```

### `refactor [code]`
Improve existing code structure and quality.

```bash
refactor the user service
refactor: improve error handling
```

### `test [feature]`
Write tests for a feature or module.

```bash
test the payment module
test user authentication
```

### `commit`
Help with git commit operations.

```bash
commit
```

### `audit`
Run comprehensive code audit (security, performance, style).

```bash
audit
```

---

## Operating Modes

Modes change how CodeXen processes your request.

### `dev` (Default)
Full workflow with planning, coding, testing, and audits.

```bash
dev, build user auth
dev, create API endpoint
```

### `quick`
Fast delivery mode - skips audits for prototyping.

```bash
quick, build test API
quick, create a simple form
```

### `review`
Audit-only mode for code reviews without coding.

```bash
review, audit this module
review the authentication code
```

### `debug`
Verbose logging mode for troubleshooting.

```bash
debug, fix this error
debug: API returns 404
```

### `refactor`
Code improvement mode with enhanced planning.

```bash
refactor, improve this code
refactor the database queries
```

### `test`
Test-first development mode (TDD workflow).

```bash
test, write tests for auth
test the payment processing
```

---

## Subagent Commands

Invoke specific subagents directly with `@` mention.

### Coder Subagents

| Command | Description | Example |
|---------|-------------|---------|
| `@backend-coder` | Backend development | `@backend-coder, create POST /api/users` |
| `@frontend-coder` | Frontend development | `@frontend-coder, build login form` |
| `@coder` | Full-stack / generic coding | `@coder, build login page` |
| `@refactor-expert` | Code refactoring | `@refactor-expert, clean up UserController` |
| `@test-coder` | Test writing | `@test-coder, write unit tests for auth` |
| `@devops-coder` | DevOps tasks | `@devops-coder, setup Docker` |

### Auditor Subagents

| Command | Description | Example |
|---------|-------------|---------|
| `@security-auditor` | Security audit | `@security-auditor, scan src/auth` |
| `@performance-auditor` | Performance check | `@performance-auditor, check for N+1 queries` |
| `@style-auditor` | Code style review | `@style-auditor, review naming conventions` |
| `@auditor` | General audit | `@auditor, review this code` |

### Planner & Research

| Command | Description | Example |
|---------|-------------|---------|
| `@planner` | Create plans | `@planner, plan user auth feature` |
| `@research` | Analyze codebase | `@research, analyze existing patterns` |

### Memory & Decision

| Command | Description | Example |
|---------|-------------|---------|
| `@memory` | Manage memory | `@memory, update AGENTS.md` |
| `@memory, show lessons about [topic]` | Check past mistakes | `@memory, show lessons about auth` |
| `@memory, smart-recall [task]` | Auto-suggest relevant lessons | `@memory, smart-recall create API endpoint` |
| `@memory, score-lessons` | Rank lessons by priority | `@memory, score-lessons` |
| `@memory, dream` | Extract knowledge from sessions | `@memory, dream` |
| `@memory, distill` | Package workflows into skills | `@memory, distill` |
| `@memory, checkpoint save` | Save session checkpoint | `@memory, checkpoint save` |
| `@memory, checkpoint restore` | Restore from checkpoint | `@memory, checkpoint restore` |
| `@memory, lesson: [title] — [desc]` | Log a lesson | `@memory, lesson: JWT expiry — forgot to check` |
| `@memory, analyze lessons` | Scan sessions for patterns | `@memory, analyze lessons` |
| `@memory, analyze patterns` | Update patterns.md | `@memory, analyze patterns` |
| `@memory, budget` | Check token usage | `@memory, budget` |
| `@memory, agent-report [agent]` | View agent performance stats | `@memory, agent-report @backend-coder` |
| `@memory, update check` | Check CodeXen updates | `@memory, update check` |
| `@decision-log` | Log decisions | `@decision-log, record why we chose JWT` |
| `@decision-log, find [topic]` | Search decisions | `@decision-log, find decisions about auth` |
| `@decision-log, show active` | List active decisions | `@decision-log, show active` |

### Utility Subagents

| Command | Description | Example |
|---------|-------------|---------|
| `@git-manager` | Git operations | `@git-manager, commit changes` |
| `@docs-manager` | Documentation | `@docs-manager, write API docs` |
| `@doc-scout` | Fetch docs | `@doc-scout, fetch React docs for hooks` |
| `@database-expert` | Database tasks | `@database-expert, optimize this query` |
| `@api-designer` | API design | `@api-designer, design REST API for users` |

### Security Subagents

| Command | Description | Example |
|---------|-------------|---------|
| `@security` | Full security scan (with bash) | `@security, scan for vulnerabilities` |
| `@security-auditor` | Quick read-only security audit | `@security-auditor, check auth code` |

### Specification Subagents

| Command | Description | Example |
|---------|-------------|---------|
| `@brs-manager` | Business requirements | `@brs-manager, create BRS` |
| `@srs-manager` | Software requirements | `@srs-manager, create SRS from BRS` |
| `@sds-manager` | System design | `@sds-manager, create SDS` |

### Validator Subagents

| Command | Description | Example |
|---------|-------------|---------|
| `@auditor` | General code audit | `@auditor, review this code` |
| `@performance-auditor` | Performance check | `@performance-auditor, check for N+1 queries` |
| `@style-auditor` | Code style review | `@style-auditor, review naming conventions` |

---

## Setup Commands

### `setup profile`
Set up user profile with name and preferences.

```bash
setup profile
```

### `show profile`
Display current user profile.

```bash
show profile
```

### `update profile`
Update user profile information.

```bash
update profile
```

### `init project`
Initialize new project with essential files (AGENTS.md, docs/, etc).

```bash
init project
```

Creates:
- AGENTS.md
- docs/current-state.md
- docs/session-diary.md
- docs/context/ (modular context directory)
- .gitignore
- .env.example

---

## Guardrails (Safety)

CodeXen has 13 built-in safety rules. Manage them via:

```
@memory, guardrails status   → Show active guardrails
@memory, guardrails list     → List all 13 with descriptions
```

Key guardrails:
- Ask before modify existing file
- Circuit breaker (3 fails = stop)
- Rate limit (5 dispatches per msg)
- Scope enforcement
- Delete file confirmation
- Command preview
- Network call guard
- Large code generation warning
- Environment detection
- Dependency guard
- Execution dry-run
- Secret scan (git)
- Message validation (git)

---

## Exit Commands

These commands end the session and automatically save work:

- `bye`
- `goodbye`
- `done`
- `selesai` (Malay)
- `keluar` (Malay)
- `habis` (Malay)

```bash
bye
```

---

## Usage Examples

### Building a Complete Feature
```bash
codexen, build a user authentication system with:
- Email/password login
- JWT tokens
- Password reset
- Session management
```

### Quick Prototype
```bash
quick, create a simple API endpoint for /api/products
```

### Code Review
```bash
review, audit the authentication module for security issues
```

### Direct Subagent Usage
```bash
@backend-coder, create a new API endpoint POST /api/orders
@security-auditor, scan src/auth for vulnerabilities
@planner, create implementation plan for payment integration
```

### Debug Mode
```bash
debug: Login returns 500 error after password reset
Error message: Cannot read property 'compare' of undefined
```

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────────┐
│                    CODEXEN COMMANDS                          │
├─────────────────────────────────────────────────────────────┤
│ BASIC                                                        │
│   hello, help, status, save, bye                            │
├─────────────────────────────────────────────────────────────┤
│ SLASH COMMANDS (OpenCode Native)                             │
│   /audit /test /lint /review /plan /commit /refactor        │
│   /brs /srs /sds /init-codexen /docker                      │
├─────────────────────────────────────────────────────────────┤
│ DEVELOPMENT                                                  │
│   build, create, plan, review, debug, refactor, test        │
├─────────────────────────────────────────────────────────────┤
│ MODES                                                        │
│   dev (default), quick, review, debug, refactor, test       │
├─────────────────────────────────────────────────────────────┤
│ SUBAGENTS                                                    │
│   @backend-coder, @frontend-coder, @test-coder              │
│   @security-auditor, @performance-auditor                   │
│   @planner, @research, @git-manager, @memory                │
├─────────────────────────────────────────────────────────────┤
│ SETUP                                                        │
│   setup profile, show profile, update profile               │
└─────────────────────────────────────────────────────────────┘
```

---

## See Also

- [README.md](./README.md) - Main documentation
- [TUTORIALS.md](./TUTORIALS.md) - Detailed tutorials for each subagent
- [install.md](./install.md) - Installation guide
