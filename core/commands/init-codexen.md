---
description: Initialize CodeXen in current project
agent: codexen
---
Initialize CodeXen framework in the current project.

Steps:
1. Load `@init-project` skill
2. Detect project name from directory
3. Create folder structure:
   - `docs/context/`
   - `docs/decisions/`
4. Generate `AGENTS.md` with project index
5. Generate `docs/current-state.md`
6. Generate `planner.md` with empty task list
7. Initialize git if needed
8. Confirm initialization complete
