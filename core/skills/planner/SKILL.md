---
name: planner
description: Advanced task planning with estimation, dependency tracking, and decision alignment
---

# Planner Skill

Breaks down complex requirements into manageable, sequential, or parallel tasks.

## Planning Workflow

1. **Analyze Requirements** - Read `docs/BRS-v1.0.md` and `docs/SDS-v1.0.md`.
2. **Check Context** - Verify `AGENTS.md` and `DECISIONS.md` to avoid using deprecated patterns.
3. **Generate Task List** - Create entries in `planner.md` with hierarchical breakdown.
4. **Estimate Effort** - Set difficulty level (Low/Medium/High).
5. **Set Dependencies** - Mark tasks that require previous steps to be completed first.
6. **Define Parallel Groups** - Group independent tasks that can run simultaneously.
7. **Assign Agents** - Tag each task with the appropriate `@agent`.
8. **Review & Iterate** - Update plan as requirements change.

## Task Format in `planner.md`

```markdown
### [Phase Name]

- [ ] **TASK-ID**: [Title] | @agent | [Priority]
  - **Description**: [Goal]
  - **Dependencies**: [TASK-ID]
  - **Effort**: [Low/Medium/High]
  - **Parallel Group**: [1/2/3...]
  - **Reference**: [Ref: DEC-YYYY-XXX | REQ-XXX]
  - **Impacted Files**: [List from decision-log]
```

## Effort Estimation Criteria

| Level | Hours | Task Examples |
|-------|-------|---------------|
| **Low** | < 2h | Create model, add route, simple UI tweak |
| **Medium** | 2-8h | Full CRUD endpoint, form with validation |
| **High** | 8-24h | Payment integration, complex business logic |

## Parallel Grouping Rules

| Condition | Action |
|-----------|--------|
| No shared dependencies | Same parallel group |
| Frontend + Backend for same feature | Different groups (backend first) |
| DB schema change needed | Blocked until migration complete |
| Multiple UI components, same API | Same group (parallel) |

## Re-planning Workflow

When scope changes:
1. Identify impacted tasks in planner.md
2. Update effort estimates if needed
3. Recalculate dependencies
4. Log change in planner.md change log
5. Notify affected agents
