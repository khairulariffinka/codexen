---
description: Set, show or clear a goal the agent must satisfy before it stops (/goal "condition" | /goal | /goal clear)
agent: codexen
---
Manage the active goal using the **Goal / Stop Condition** protocol in the `orchestration` skill (load it if not loaded).

Goal file: `~/.config/opencode/global-memory/current-goal.md`

Argument: `$ARGUMENTS`

- **Empty** → show the active goal and its checklist from the goal file, or say no goal is set.
- **`clear`** → delete the goal file and confirm; normal stop behaviour resumes.
- **Anything else** → treat it as the goal condition:
  1. If it is vague, ask one question to make it specific and measurable.
  2. Break it into a checklist of verifiable items (tests, audits, files, commands to run).
  3. Write the goal file in the protocol's format (Set time, Goal, Status: In Progress, Checklist, Evaluation Log).
  4. Confirm the goal and checklist to the user in one short message.

From now on, before saying a task is done, run the Goal Evaluation, append the result to the Evaluation Log, and keep working on any ❌ items.
