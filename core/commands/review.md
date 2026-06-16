---
description: Code review for recent changes
agent: codexen
---
Review the most recent code changes in the repository.

Steps:
1. Run `git diff HEAD~1` or `git diff --staged` to see recent changes
2. Load `@auditor` skill for quality checks
3. Load `@security` skill for security checks
4. Analyze each changed file for:
   - Bug risks
   - Security vulnerabilities
   - Performance issues
   - Code style violations
   - Missing tests
5. Provide actionable feedback per file
6. Suggest improvements with code examples
