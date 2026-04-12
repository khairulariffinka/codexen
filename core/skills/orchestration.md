# Orchestration

Workflow management and subagent coordination for CodeXen.

## Subagent Registry

### Coder Subagents
- `backend-coder` - APIs, databases, server-side logic
- `frontend-coder` - UI components, React/Vue, styling
- `test-coder` - Unit, integration, E2E tests
- `devops-coder` - Docker, CI/CD, deployment

### Auditor Subagents
- `security-auditor` - OWASP Top 10, secrets detection
- `performance-auditor` - Optimization, N+1 queries
- `style-auditor` - Code style, naming conventions

### Planner Subagents
- `planner` - Hierarchical planning, risk assessment
- `research` - Codebase analysis and context gathering

### Memory Subagents
- `memory` - Semantic search, decision tracking
- `decision-log` - Design decision logging with rationale

### Utility Subagents
- `git-manager` - Git operations, commits
- `docs-manager` - Documentation generation

## Intelligent Subagent Selection

Based on task type, automatically select optimal subagents:

```
Task: "Create user API endpoint"
├── Research: research (analyze codebase)
├── Planner: planner
├── Coders (Parallel):
│   ├── backend-coder (primary)
│   └── test-coder (secondary)
└── Auditors (Parallel):
    ├── security-auditor
    └── performance-auditor
```

## Structured Development Workflow

### Phase 1: Research
```
@research → Analyze codebase
- Understand existing patterns
- Find relevant files
- Document tech stack
- Provide recommendations
```

### Phase 2: Plan
```
planner → Create implementation plan
- Hierarchical task breakdown
- Risk assessment
- Parallel grouping
```

### Phase 3: Execute
```
coders → Implement changes
- Read AGENTS.md first
- Follow discovered patterns
- Mark tasks complete
```

### Phase 4: Commit
```
git-manager → Commit changes
- Generate commit message
- Get user permission ⚠️
- Push (with permission)
```

### Phase 5: Review
```
auditors → Verify implementation
- Check AGENTS.md conventions
- Security audit
- Code quality check
```

## Parallel Execution Engine

### Parallel Groups
Tasks that can run simultaneously are grouped:

```
Group 1 (No dependencies):
├── backend-coder: Create User model
└── frontend-coder: Create login form

Group 2 (Depends on Group 1):
├── backend-coder: Create auth API
└── frontend-coder: Integrate API

Group 3 (Final):
├── test-coder: Write tests
└── security-auditor: Security audit
```

### Execution Flow
1. Identify all tasks from planner
2. Map dependencies
3. Group into parallel batches
4. Execute batch 1 (parallel)
5. Wait for completion
6. Execute batch 2 (parallel)
7. Continue until complete

## Context-Aware Decision Making

Before executing, check:

1. **Project Knowledge** - "Have I worked on this project before?"
2. **Similar Tasks** - "Did similar task in Project X"
3. **User Preferences** - "User prefers X → adapt accordingly"
4. **Risk Assessment** - High-risk task? Add extra audits

## Error Recovery

### Failure Scenarios

```
Scenario: Coder fails
├── Retry with more context
├── Try alternative approach
└── Escalate to user

Scenario: Auditor fails
├── Return to coder for fixes
├── Add debug mode
└── Escalate if persistent

Scenario: Parallel task fails
├── Continue independent tasks
├── Re-queue failed task
└── Report partial success
```

## Adaptive Workflow

Workflow adapts based on:

| Factor | Adaptation |
|--------|------------|
| File size | Large → thorough audit, small → quick |
| File type | Config → skip audit, logic → full audit |
| Project phase | Prototype → skip checks, production → full |
| User history | User prefers X → adapt accordingly |
| Error rate | Many failures → slow down, add debugging |

---

## Smart Model Rotation

Automatically selects optimal model based on task complexity for cost optimization.

### Quick Reference

| Task | Model Tier | Examples |
|------|------------|----------|
| **Discovery** | Tier 1 (Free) | glob, grep, read small files |
| **Simple** | Tier 2 (~$0.30/1M) | quick edits, basic refactoring |
| **Medium** | Tier 3 (~$1-3/1M) | planning, features, tests |
| **Complex** | Tier 4 (~$5+/1M) | security, debugging, architecture |

### Model Selection by Task

```
Simple Tasks (Tier 1-2):
├── research: Read files → Tier 1
├── glob/grep: Search → Tier 1
└── simple-edit: Fix typo → Tier 2

Medium Tasks (Tier 3):
├── planner: Create plan → Tier 3
├── backend-coder: Feature → Tier 3
├── test-coder: Write tests → Tier 3
└── docs-manager: Generate docs → Tier 3

Complex Tasks (Tier 4):
├── security-auditor: Scan → Tier 4
├── complex-debug: Fix bug → Tier 4
└── performance-auditor: Optimize → Tier 4
```

### Mode-Based Model Selection

| Mode | Simple | Medium | Complex |
|------|--------|--------|---------|
| dev | Tier 2 | Tier 3 | Tier 4 |
| quick | Tier 1 | Tier 2 | Tier 3 |
| review | Tier 2 | Tier 3 | Tier 4 |
| debug | Tier 2 | Tier 3 | Tier 4 |
| refactor | Tier 2 | Tier 3 | Tier 3 |
| test | Tier 2 | Tier 3 | Tier 3 |

### Cost Optimization Tips

1. **Use Tier 1 for discovery** - Always free for glob, grep, file reads
2. **Quick mode uses cheaper models** - Ideal for prototyping
3. **Reserve Tier 4 for security** - Security auditing always uses premium
4. **Monitor with /status** - Check cost tracking during session

See switch-config skill or use `/config` command for model configuration.
