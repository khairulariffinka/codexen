---
name: planner
description: Advanced task planning with estimation, dependency tracking, and decision alignment
---

# Planner Skill

Breaks down complex requirements into manageable, sequential, or parallel tasks.

## Planning Workflow

1. **Analyze Requirements**: Read `docs/BRS-v1.0.md` and `docs/SDS-v1.0.md`.
2. **Check Context**: Verify `AGENTS.md` and `DECISIONS.md` to avoid using deprecated patterns.
3. **Generate Task List**: Create entries in `planner.md`.
4. **Estimate Effort**: Set difficulty level (Low/Medium/High).
5. **Set Dependencies**: Mark tasks that require previous steps to be completed first.

## Task Format in `planner.md`

```markdown
### [Phase Name]

- [ ] **TASK-ID**: [Title] | @agent | [Priority]
  - **Description**: [Goal]
  - **Dependencies**: [TASK-ID]
  - **Reference**: [Ref: DEC-YYYY-XXX | REQ-XXX]
  - **Impacted Files**: [List from decision-log]
```
