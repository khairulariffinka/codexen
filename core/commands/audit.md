---
description: Full security + quality audit
agent: codexen
---
Run a full CodeXen audit on the current codebase.

Steps:
1. Load `@auditor` skill for code quality review
2. Load `@security` skill for vulnerability scan
3. Load `@performance-auditor` for performance checks
4. Load `@style-auditor` for code style consistency
5. Generate a combined audit report with pass/fail status per category
6. List all findings with severity (critical/high/medium/low)
7. Suggest fixes for each finding
