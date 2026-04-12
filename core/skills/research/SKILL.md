---
name: research
description: Analyze codebase and gather context before planning
---

# Research Skill

Analyze codebase to understand existing patterns, tech stack, and context.

## Language Detection

- **CRITICAL**: Detect user's language and respond in the same language
- If user uses **Bahasa Melayu (Malay)**, respond entirely in **Bahasa Melayu Malaysia**
- If user uses **English**, respond entirely in **English**
- **NEVER mix both languages in the same response** - use ONE language consistently

---

## Purpose

Before planning or coding, research the codebase to:
- Understand existing patterns and architecture
- Identify relevant files and components
- Gather technical context
- Find similar implementations for reference

## When to Use

- New feature implementation
- Bug investigation
- Refactoring tasks
- Any task requiring codebase understanding

## Primary Functions

| Function | Description |
|----------|-------------|
| **ANALYZE** | Understand tech stack and structure |
| **EXPLORE** | Find relevant files and patterns |
| **DOCUMENT** | Summarize research findings |
| **RECOMMEND** | Provide actionable guidance |

---

## Workflow

### Step 1: Analyze Request
- What does the user want to achieve?
- What is the scope?
- Any constraints or requirements?

### Step 2: Explore Codebase
Search for:
- Tech stack files (package.json, requirements.txt, etc.)
- Configuration files
- Similar features or implementations
- Patterns used in the project

### Step 3: Document Findings
Structure the research:
```
## Tech Stack
## Project Structure  
## Relevant Files
## Existing Patterns
## Recommendations
```

### Step 4: Provide Context
- Pass findings to planner/coder
- Highlight important patterns to follow
- Flag potential issues or considerations

---

## Research Areas

### 1. Tech Stack Detection
Check for:
- `package.json`, `requirements.txt`, `go.mod`, `Cargo.toml`
- Framework files (e.g., `app/`, `src/`)
- Database configs

### 2. Project Structure
- Main directories
- Entry points
- Configuration locations

### 3. Code Patterns
- Naming conventions
- Error handling
- Validation approach
- Authentication/authorization
- Testing setup

### 4. Similar Implementations
- Look for related features
- Find reusable components
- Identify patterns to follow

---

## Output Format

### Research Summary Template
```markdown
# Research: [Feature Name]

## Context
[What we're trying to achieve]

## Tech Stack Detected
- Framework: [e.g., Express.js, React]
- Language: [e.g., TypeScript, Python]
- Database: [e.g., PostgreSQL, MongoDB]
- API Style: [REST, GraphQL]

## Project Structure
```
src/
├── controllers/
├── models/
├── routes/
└── middleware/
```

## Relevant Files
| File | Purpose |
|------|---------|
| src/models/User.ts | User model |
| src/routes/auth.ts | Auth routes |

## Existing Patterns
- **Validation**: express-validator
- **Error Handling**: custom error class
- **Auth**: JWT with refresh tokens
- **Testing**: Jest with supertest

## Recommendations
1. Use existing JWT pattern from auth module
2. Follow validation style from controllers
3. Reuse User model for relationships

## Potential Issues
- [Issue 1 and how to handle]
- [Issue 2 and how to handle]
```

---

## Guidelines

1. **Be Thorough** - Don't skip important details
2. **Be Focused** - Stay relevant to the task
3. **Be Practical** - Look for patterns to reuse
4. **Be Clear** - Write actionable recommendations
5. **Be Proactive** - Flag potential issues early

---

## Integration with CodeXen

### Full Workflow

```
1. RESEARCH (@research) → Analyze codebase
2. PLAN (planner) → Create implementation plan
3. EXECUTE (coders) → Implement changes
4. COMMIT (git-manager) → Commit with permission
5. REVIEW (auditors) → Verify implementation
```

### How It Works

1. **User describes feature**
2. **@research** analyzes codebase → provides context
3. **planner** creates plan based on research
4. **coders** implement following patterns found
5. **auditors** verify against conventions
6. **git-manager** commits (with permission)

---

## Example

### Input
```
@research, I need to add a payment feature to our e-commerce app
```

### Output
```
# Research: Payment Feature

## Context
Add payment processing to e-commerce app

## Tech Stack Detected
- Backend: Node.js + Express
- Database: PostgreSQL + Prisma
- Auth: JWT
- API: REST

## Relevant Files
- src/services/payment/ - existing payment service
- src/models/Order.ts - order model
- src/routes/checkout.ts - checkout routes

## Existing Patterns
- Service layer pattern
- Transaction-based DB operations
- Webhook handlers for async processing

## Recommendations
1. Follow service layer pattern from payment/
2. Use Prisma transactions for order + payment
3. Add webhook handler for payment callbacks
4. Reuse existing error handling from services/
```
