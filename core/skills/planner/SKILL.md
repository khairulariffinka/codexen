---
name: planner
description: Generate, organize ideas, and create structured project plans - works with any tech stack
---

# Planner Skill

Generate task breakdowns from requirements.

## When to Use

- Create plan for new project
- Break down big task into smaller tasks
- Organize ideas or requirements
- Identify dependencies between tasks

## Framework

### 1. Understand
- Clarify goals and objectives
- Identify constraints (timeline, budget, tech stack)
- Determine stakeholders
- Use SWOCE for comprehensive analysis

### 2. Brainstorm
- List all possible tasks/features
- Group related items
- Note assumptions

### 3. Structure
- Arrange tasks in logical order
- Identify dependencies
- Set priorities (P0/P1/P2)

### 4. Document
Output in this format:

```markdown
## Project: [Name]
**Goal:** [1-2 sentences]

### Milestones
1. **[Phase 1] - Foundation**
   - [ ] Task 1

2. **[Phase 2] - Core Features**
   - [ ] Task 2

### Risks & Mitigations
| Risk | Impact | Mitigation |
|------|--------|------------|
|      |        |            |

### Next Steps
1. [First action]
```

## Alternative Frameworks

### Agile/Scrum
```
Sprint Goal: [Goal]
Duration: [X weeks]

#### User Stories
| ID | Story | Points | Priority |
|----|-------|--------|----------|
| US1 | [Description] | [X] | Must Have |
```

### OKR
```
## Objectives & Key Results

### Objective 1: [Title]
**Key Results:**
- [ ] KR1: [Metric] - Target: [X%]
```

### SWOCE Analysis
```
## SWOCE Analysis
### Strengths
-
### Weaknesses
-
### Opportunities
-
### Constraints
-
### Expectations
-
```

## Templates

- Technical specs template
- API design template
- Database schema template
- UI/UX planning template

## Estimation Guidelines

### T-Shirt Sizing
| Size | Points | Description |
|------|--------|-------------|
| XS | 1-2 | Very small, trivial |
| S | 3-5 | Small, well understood |
| M | 8-13 | Medium, requires thought |
| L | 21-34 | Large, complex |
| XL | 55-89 | Very large, needs breakdown |

## Quality Checks

- Goal clearly defined (SMART)
- All stakeholders identified
- Dependencies identified
- Priorities assigned
- Risks identified
- Testing strategy included

## Guidelines

- Ask clarifying questions if requirements unclear
- Keep plans actionable and specific
- Consider technical debt
- Include testing strategy
- Suggest iterative approach

## AUTO-CREATE AGENTS.md

After creating the plan, ALWAYS auto-update AGENTS.md:

### When to Create
- When planner.md is created for a NEW project
- When AGENTS.md doesn't exist yet

### What to Include
Extract from the plan:

```markdown
# Project: [Name]

## Tech Stack
- Frontend: [Detected or ask user]
- Backend: [Detected or ask user]
- Database: [Detected or ask user]

## PRD
### Features
- [Feature 1 from plan]
- [Feature 2 from plan]

### Requirements
- [Requirement from plan]

## Project Structure
```
[Auto-detect or use default structure]
```

## Decisions
- [Major decisions will be logged here by decision-log agent]
- See DECISIONS.md for detailed decision history

## Coding Conventions
- Variables: camelCase
- Constants: UPPER_SNAKE_CASE
- Classes: PascalCase
- Files: kebab-case
- Commit messages: Conventional commits

---

## Workflow

1. **Understand** - Get requirements from user
2. **Plan** - Create planner.md with milestones
3. **AUTO-CREATE** - If AGENTS.md doesn't exist, create it with tech stack + plan
4. **Confirm** - Tell user "Created planner.md and AGENTS.md"

### Example Output
```
[PLANNER] Creating plan for your project...

[PLAN CREATED] planner.md

[AGENTS AUTO-CREATED] AGENTS.md
- Tech stack detected: Laravel + React + MySQL
- Features from plan added to PRD

Ready to start coding!
```
