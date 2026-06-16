# Versioning Policy

CodeXen uses **Semantic Versioning** (SemVer 2.0): `MAJOR.MINOR.PATCH`

## Rules

| Bump | When | Example |
|------|------|---------|
| **MAJOR** | Breaking changes to agent API, permission model, or core workflow | `0.5.0` → `1.0.0` |
| **MINOR** | New features, new agents, new guardrails (backward compatible) | `0.7.0` → `0.8.0` |
| **PATCH** | Bug fixes, documentation, validation improvements | `0.7.0` → `0.7.1` |

## Breaking Changes (MAJOR)

These require a MAJOR bump:
- Removing or renaming an agent file
- Changing permission model (edit/bash allow/deny)
- Changing routing table format
- Removing a guardrail
- Changing install/update script behavior

## Backward Compatible (MINOR)

These only need MINOR bump:
- Adding new agents
- Adding new guardrails
- Adding new self-learning features
- New validation checks

## Changelog

All changes documented in `install.md` and `update.md` changelog sections.
