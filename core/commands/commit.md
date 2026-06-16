---
description: Smart git commit with conventional format
agent: codexen
---
Create a well-formatted git commit for staged changes.

Steps:
1. Run `git diff --staged` to see all staged changes
2. Analyze the changes to determine commit type:
   - feat: new feature
   - fix: bug fix
   - refactor: code restructuring
   - docs: documentation only
   - test: adding tests
   - chore: maintenance
   - perf: performance improvement
   - ci: CI/CD changes
3. Generate conventional commit message with scope
4. Include body explaining what and why (not how)
5. Run `git commit` with the generated message
