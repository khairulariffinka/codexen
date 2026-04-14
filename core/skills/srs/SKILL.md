---
name: srs
description: Software Requirements Specification skill - maps business needs to technical functional requirements
---

# SRS Skill

Refines BRS into actionable functional and non-functional software requirements.

## Functional Mapping

- Break down `REQ-001` (Business) into `FR-001.1`, `FR-001.2` (Software features).
- Define user stories and acceptance criteria.

## Non-Functional Requirements

- **Performance**: Response time < 200ms.
- **Security**: OWASP Top 10 compliance.
- **Availability**: Offline-first logic for PWA (e.g., KiraJe project).

## Traceability Matrix ⭐

Maintain a table linking:
`BRS (REQ) <-> SRS (FR) <-> SDS (API/DB) <-> Code (File)`

## Guidelines

- **Precision**: No ambiguous words like "fast" or "user-friendly". Use "under 2 seconds" or "WCAG compliant".
- **Consistency**: Ensure terminology matches across all documents.
