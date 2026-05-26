---
name: srs
description: Software Requirements Specification skill - maps business needs to technical functional requirements
license: MIT
compatibility: opencode
metadata:
  audience: agents
  workflow: specification
---

# SRS Skill

Refines BRS into actionable functional and non-functional software requirements.

## Functional Mapping

- Break down `REQ-001` (Business) into `FR-001.1`, `FR-001.2` (Software features)
- Define user stories using "As a [user], I want [goal], so that [benefit]"
- Define acceptance criteria for each FR using Given/When/Then format

## FR Template

```markdown
### FR-01.X: [Title]
**Description:** [What the system shall do]
**Priority:** MUST / SHOULD / COULD
**Implements:** BRS REQ-XXX
**Use Case:** UC-XX

**Sub-requirements:**
- FR-01.1: [Detail]
- FR-01.2: [Detail]

**Acceptance Criteria:**
- GIVEN [context] WHEN [action] THEN [result]
- GIVEN [context] WHEN [action] THEN [result]
```

## Non-Functional Requirements

| Category | Examples |
|----------|----------|
| **Performance** | Response time < 200ms, 95th percentile |
| **Security** | OWASP Top 10 compliance, data at rest encryption |
| **Availability** | 99.9% uptime, offline-first for PWA |
| **Scalability** | 10,000 concurrent users, auto-scaling |
| **Maintainability** | Code documentation, modular architecture |
| **Accessibility** | WCAG 2.1 AA compliance |
| **Portability** | Cross-browser support, mobile-responsive |

## Traceability Matrix

Maintain a table linking all stages:

```markdown
| BRS (REQ) | SRS (FR) | SDS (API/DB) | Code |
|-----------|----------|--------------|------|
| REQ-001 | FR-01.1, FR-01.2 | POST /api/auth/login | AuthController.php |
| REQ-002 | FR-02.1 | GET /api/products | ProductController.php |
```

## SRS Document Structure (6 Sections)

1. **Introduction** - Purpose, scope, definitions
2. **Overall Description** - Product perspective, user classes, environment
3. **Functional Requirements** - All FRs with sub-requirements and acceptance criteria
4. **External Interface Requirements** - UI, hardware, software, communication
5. **Non-Functional Requirements** - Performance, security, availability, etc.
6. **Use Cases & User Stories** - Flow descriptions with actors and preconditions

## Use Case Template

```markdown
### UC-XX: [Title]
**Actor:** [User role]
**Precondition:** [State before flow]
**Main Flow:**
1. [Step 1]
2. [Step 2]
3. [Step 3]
**Alternative Flow:**
- [If error / edge case]: [Alternative step]
```

## Changelog & Versioning

Every SRS document must include a changelog section:

```markdown
## Changelog

| Version | Date | Changes | CR Reference |
|---------|------|---------|--------------|
| 1.0 | [Date] | Initial SRS from BRS v1.0 | — |
| 1.1 | [Date] | Added FR-03: Payment integration | CR-001 |
| 1.2 | [Date] | Modified FR-01.2: Changed lockout to 3 attempts | CR-002 |
```

### Change Request Handling

When BRS changes, SRS must be updated:

```
1. Read updated BRS (detect new version or CR-XXX)
2. Identify affected FRs (which FRs reference changed REQs?)
3. Update/add/remove affected FRs
4. Bump SRS version
5. Log change in changelog
6. Call @sds-manager to sync SDS
7. Call @planner to update task plan
```

### Version Rules

- SRS version matches BRS major.minor
- Each CR bumps minor version (e.g., v1.0 → v1.1)
- Major restructure bumps major (e.g., v1.0 → v2.0)
- Changelog entries link to CR-XXX documents

## Guidelines

- **Precision**: No ambiguous words like "fast" or "user-friendly". Use "under 2 seconds" or "WCAG compliant".
- **Consistency**: Ensure terminology matches across all documents.
- **BRS → SRS → SDS Chain**: Every SRS item must trace back to a BRS requirement.
