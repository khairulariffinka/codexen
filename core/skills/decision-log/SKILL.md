---
name: decision-log
description: Decision logging system - tracks design decisions with rationale for future reference
---

# Decision Log Skill



## Purpose

Capture design decisions during development with full context:
- **Context** - What was being decided?
- **Options considered** - What alternatives were evaluated?
- **Decision** - What was chosen?
- **Rationale** - Why this choice was made?
- **Implications** - Future impact and trade-offs

---

## Primary Functions

| Function | Description |
|----------|-------------|
| **DETECT** | Identify when a significant decision is being made |
| **LOG** | Record decision with full context |
| **QUERY** | Search past decisions for reference |
| **LINK** | Connect related decisions and files |

---

## Decision Storage

Store decisions in project root: `DECISIONS.md`

---

## When to Log

Log a decision when:

1. **Architecture choices** - "Use JWT vs Sessions"
2. **Tech stack decisions** - "Use PostgreSQL vs MongoDB"
3. **Pattern selections** - "Use Repository pattern vs Active Record"
4. **API design** - "REST vs GraphQL"
5. **Trade-offs** - "Speed vs Memory trade-off"
6. **Team conventions** - "Git flow strategy"

---

## Decision Format

```markdown
## DEC-2026-001: [Title]

**Date:** 2026-03-10
**Status:** Active | Deprecated | Superseded

### Context
[What problem or question was being addressed?]

### Options Considered

| Option | Pros | Cons |
|--------|------|------|
| A: JWT | Stateless, scales well | Complex to implement |
| B: Sessions | Simple, familiar | Server state, less scalable |
| C: OAuth | Industry standard | Overkill for simple app |

### Decision
**Chosen:** Option A: JWT

### Rationale
[Detailed explanation - "because X" not "because it's better"]
- Primary reason 1
- Primary reason 2

### Implications

**Positive:**
- Stateless authentication scales horizontally
- Industry standard, familiar to developers

**Trade-offs:**
- Need to implement token refresh mechanism
- Slightly more complex client implementation

### Related
- Related: DEC-2026-002
- Files: src/auth/, config/jwt.ts
```

---

## Decision ID System

Format: `DEC-YYYY-NNN`

```
DEC-2026-001  → First decision in 2026
DEC-2026-002  → Second decision in 2026
DEC-2026-010  → Tenth decision in 2026
```

---

## Workflow

### 1. Detect Decision Point
Recognize when a design choice is being made:
- "Should we use X or Y?"
- "What's the best approach for..."
- "How should we handle..."

### 2. Capture Context
Before implementing, ask/log:
- What problem are we solving?
- What constraints do we have?
- What are the alternatives?

### 3. Log the Decision
Use this format:
```
## DEC-2026-XXX: [Title]

**Context:** [Problem being solved]
**Decision:** [What was chosen]
**Rationale:** [Why this choice]
**Implications:** [Future impact]
```

### 4. Query Past Decisions
When facing similar decisions:
```
Search DECISIONS.md for:
- "authentication" → Past auth decisions
- "database" → Past DB decisions
- Related: [Previous DEC ID]
```

---

## AGENTS.md Integration (IMPORTANT)

After logging a major decision, **ALWAYS update AGENTS.md**:

### When to Update AGENTS.md
- Tech stack changes (database, framework, language)
- Architecture decisions (API style, auth method)
- Project conventions (naming, structure)
- New integrations (external services)

### How to Update AGENTS.md

```markdown
## Decisions

### DEC-2026-001: Use JWT for Authentication
**Date:** 2026-03-10
**Status:** Active

Decided to use JWT because it's stateless and scales horizontally.

### DEC-2026-002: Use PostgreSQL Database
**Date:** 2026-03-10
**Status:** Active

Chose PostgreSQL over MongoDB for relational data integrity.
```

### Workflow Update

```
1. **Detect** - Decision point identified
2. **Log** - Record in DECISIONS.md
3. **UPDATE** - Add to AGENTS.md under "Decisions" section
4. **Confirm** - Tell user "Decision logged and AGENTS.md updated"
```

---

## Query Examples

### Search by Keyword
```
grep -i "authentication" DECISIONS.md
grep -i "database" DECISIONS.md
```

### Find Related
- Look at "Related" section of each decision
- Search by file paths mentioned

---

## Guidelines

1. **Log proactively** - Document decisions during development, not after
2. **Be specific** - "because X" not "because it's better"
3. **Include trade-offs** - What are we giving up?
4. **Link related** - Connect decisions to each other
5. **Mark deprecated** - If a decision is superseded, update status
6. **Keep it searchable** - Use clear titles and keywords
7. **UPDATE AGENTS.md** - Always sync major decisions to AGENTS.md

---

## Integration with CodeXen

When implementing significant features:

1. **Pause** - Before major implementation
2. **Log** - Record in DECISIONS.md
3. **UPDATE AGENTS.md** - Add decision to AGENTS.md under "Decisions"
4. **Implement** - Proceed with full context
5. **Reference** - Future decisions can query this

This creates a searchable knowledge base for the team.
