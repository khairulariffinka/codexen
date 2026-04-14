---
name: sds
description: System Design Specification skill - architecture design, ERD generation, and API contract management
---

# SDS Skill

Handles the technical blueprinting of the system.

## Key Components

### 1. Architecture Design

- Define stack components (e.g., HATA Stack: HTMX, Alpine, Tailwind, Alpine).
- Document infrastructure (Cloud, VPS, or WSL).

### 2. Database Modeling

- Generate Mermaid ERD diagrams.
- Define indexing and normalization strategies.
- **Auto-Sync ⭐**: If `@database-expert` changes a table, SDS MUST be updated.

### 3. API & Service Contracts

- Define endpoint structures (Method, Path, Request, Response).
- Document middleware and auth protocols (JWT/Sanctum).

## Logic Rules

- **N+1 Prevention**: Every database design must be audited for N+1 query risks.
- **Impact Tracking**: Every technical choice in SDS must be logged as a `DEC` in `DECISIONS.md`.
- **Component Linking**: Every API endpoint must reference a `REQ-ID` from the BRS.

## Guidelines

- **Scalability**: Design for modular growth (Service Pattern).
- **Security**: Include CORS, Rate Limiting, and Data Encryption specs in the design.
