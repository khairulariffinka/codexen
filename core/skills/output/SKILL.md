---
name: output
description: Standardized output formats for CodeXen.
---

# Output Format

## Progress Display

### Starting Task
```
CodeXen 🚀 Starting Task: [Task Name]
[MODE: dev] Full workflow

⏳ Planning...
```

### Creating Plan
```
✓ Plan created ([count] tasks, [count] parallel groups)
```

### Executing Parallel Group
```
⏳ Executing Parallel Group 1/[count]...
  ├─ agent: Task description ✓
  └─ agent: Task description ✓
```

### Running Audit
```
⏳ Parallel Audit...
  ├─ security-auditor: ✅ Passed
  ├─ performance-auditor: ✅ Passed
  └─ style-auditor: ⚠️ Minor issues
```

### Completing
```
⏳ Finalizing...
✓ Committed: [commit message]
✓ Memory updated

🎉 Task Complete!
   Files: [count] created
   Tests: [count] added
   Time: [duration]
```

## Task Output Format

### Backend Task
```
**Backend Task:** [Task Name]

**Files Created:**
1. [path/to/file1.ext]
2. [path/to/file2.ext]

**API Endpoints:**
- POST /api/resource - Create
- GET /api/resource/{id} - Read
- PUT /api/resource/{id} - Update
- DELETE /api/resource/{id} - Delete

[x] Task completed
```

### Frontend Task
```
**Frontend Task:** [Task Name]

**Files Created:**
1. [path/to/component.vue]
2. [path/to/styles.css]

**Components:**
- [ComponentName] - Description

[x] Task completed
```

### Audit Result
```
**Audit:** [Target]

**Results:**
| Category | Status | Issues |
|----------|--------|--------|
| Security | ✅ Passed | 0 |
| Performance | ⚠️ Warning | 2 |
| Style | ❌ Failed | 5 |

**Risk Score:** [score]/10 ([level])

[Details...]
```

### Research Result
```
**Research:** [Topic]

**Findings:**
- Tech stack: [detected stack]
- Project structure: [structure overview]
- Patterns found: [list of patterns]

**Recommendations:**
1. [Recommendation 1]
2. [Recommendation 2]
```

## Error Output

### Standard Error
```
[ERROR] [Description]
├─ Location: [file:line]
├─ Cause: [why it happened]
└─ Suggestion: [how to fix]
```

### Multi-Error
```
[ERRORS] Multiple issues found

1. [Issue 1]
   ├─ File: [path]
   └─ Fix: [suggestion]

2. [Issue 2]
   ├─ File: [path]
   └─ Fix: [suggestion]
```

## Session Summary

### Completed Session
```
📊 Session Summary

Tasks Completed: [count]
├─ Task 1: ✅
├─ Task 2: ✅
└─ Task 3: ⚠️ Partial

Files Modified: [count]
Lines Changed: [count]

Decisions Made:
- [DEC-001]: [Decision]
- [DEC-002]: [Decision]

Time: [total duration]
```
