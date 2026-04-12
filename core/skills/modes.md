# Operating Modes

CodeXen supports multiple operating modes for different workflows.

## Mode Overview

| Mode | Description | Best For |
|------|-------------|----------|
| **dev** | Full workflow with all audits | Production code |
| **quick** | Skip audits, fast iteration | Prototyping |
| **review** | Audit-only mode | Code reviews |
| **refactor** | Focus on refactoring | Improving existing code |
| **debug** | Verbose logging, step-by-step | Troubleshooting |
| **test** | Test-first development | TDD workflow |

## Mode-Specific Workflows

### Dev Mode (Default)
```
[MODE: dev] Full workflow enabled

1. [MEMORY] Loading context...
2. [PLANNER] Creating hierarchical plan...
3. [PARALLEL GROUP 1]
   ├─ [BACKEND-CODER] Task 1 ✓
   └─ [FRONTEND-CODER] Task 2 ✓
4. [PARALLEL GROUP 2]
   ├─ [BACKEND-CODER] Task 3 ✓
   └─ [FRONTEND-CODER] Task 4 ✓
5. [PARALLEL AUDIT]
   ├─ [SECURITY-AUDITOR] ✓
   ├─ [PERFORMANCE-AUDITOR] ✓
   └─ [STYLE-AUDITOR] ✓
6. [GIT-MANAGER] Commit (with permission)
7. [MEMORY] Update history

✓ Complete!
```

### Quick Mode
```
[MODE: quick] Skipping audits

Skip: Audits (unless critical files)
Focus: Speed of delivery
Best for: Prototypes, spikes, experiments

[EXECUTE]
├─ backend-coder: Creating... ✓
└─ frontend-coder: Creating... ✓

✓ Complete! (Time: ~15s)
```

### Review Mode
```
[MODE: review]

Skip: Coding
Focus: Only audits
Best for: PR reviews, code audits

[AUDIT - Parallel]
├─ security-auditor: 2 issues found
├─ performance-auditor: ✅ Passed
└─ style-auditor: 3 minor issues

[REPORT]
Risk Score: 6.5/10 (MEDIUM)
```

### Refactor Mode
```
[MODE: refactor]

Enhanced: Planner (refactoring plan)
Focus: Code improvement
Best for: Technical debt, upgrades

[ANALYZE]
├─ Code structure: analyzed
├─ Dependencies: mapped
└─ Opportunities: identified

[REFACTOR]
├─ backend-coder: Refactoring... ✓
└─ frontend-coder: Refactoring... ✓
```

### Debug Mode
```
[MODE: debug]

Enhanced: Verbose logging
Focus: Step-by-step execution
Best for: Troubleshooting failures

[DEBUG MODE] Verbose logging enabled

[STEP 1] Analyzing error context...
File: src/auth/login.ts:42
Error: Cannot read property 'compare' of undefined

[STEP 2] Checking dependencies...
- bcrypt imported ✓
- password field: undefined ❌

[STEP 3] Root cause identified:
- User model password field is optional
- Login handler doesn't validate password exists

[FIX] Proposed solution:
- Add null check: if (!user.password)

Apply fix? [y/N]:
```

### Test Mode
```
[MODE: test]

Enhanced: Test-first approach
Focus: TDD workflow
Best for: Test-driven development

[PLAN]
├─ Define test cases
├─ Write failing tests
├─ Implement code
└─ Verify tests pass

[EXECUTE]
├─ test-coder: Writing tests... ✓
└─ backend-coder: Implementing... ✓
```

## Selecting Mode

Include mode in your request:

```
build user auth           → dev mode (default)
quick, build test API    → quick mode
review, audit this module → review mode
debug, fix this error    → debug mode
refactor, improve code   → refactor mode
test, write tests        → test mode
```

## Default Behavior

Most of the time, you don't need to specify mode. Just tell CodeXen what you want and it will:
- Use dev mode for production tasks
- Automatically detect when quick mode is appropriate
- Suggest different mode if needed
