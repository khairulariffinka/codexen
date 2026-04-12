# CodeXen Commands Reference

Complete reference for all CodeXen commands and operations.

---

## Table of Contents

1. [Basic Commands](#basic-commands)
2. [Development Commands](#development-commands)
3. [Operating Modes](#operating-modes)
4. [Subagent Commands](#subagent-commands)
5. [Setup Commands](#setup-commands)
6. [Exit Commands](#exit-commands)

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
| `@decision-log` | Log decisions | `@decision-log, record why we chose JWT` |

### Utility Subagents

| Command | Description | Example |
|---------|-------------|---------|
| `@git-manager` | Git operations | `@git-manager, commit changes` |
| `@docs-manager` | Documentation | `@docs-manager, write API docs` |
| `@doc-scout` | Fetch docs | `@doc-scout, fetch React docs for hooks` |
| `@database-expert` | Database tasks | `@database-expert, optimize this query` |
| `@api-designer` | API design | `@api-designer, design REST API for users` |

### Specification Subagents

| Command | Description | Example |
|---------|-------------|---------|
| `@brs-manager` | Business requirements | `@brs-manager, create BRS` |
| `@srs-manager` | Software requirements | `@srs-manager, create SRS from BRS` |
| `@sds-manager` | System design | `@sds-manager, create SDS` |

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
- docs/AI-AGENT-PROTOCOL.md
- .gitignore
- .env.example
- package.json (if not exists)

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
