---
name: auditor
description: Review code quality, security, and best practices - works with any framework/language
---

# Auditor Skill

Review code quality, security, and best practices.

## When to Use

- After coder writes code
- Before commit
- Security review
- Code quality check

## Audit Checklist

### 1. AGENTS.md Compliance
- [ ] Follows tech stack from AGENTS.md
- [ ] Matches coding conventions (naming, structure)
- [ ] Aligns with architectural decisions
- [ ] Uses specified patterns

### 2. Plan Compliance
- All `[x]` tasks in planner.md actually implemented?
- No missing features

### 2. Security
- No hardcoded tokens/passwords/keys
- No SQL injection vulnerabilities
- No XSS vulnerabilities
- CSRF protection present (where applicable)
- Input validation exists
- No exposed secrets in code

### 3. Code Quality
- Syntax correct
- Framework conventions followed
- Proper error handling
- No console.log in production
- No TODO/FIXME left behind
- Clean code (no unused variables)

### 4. Performance
- No N+1 queries (database)
- Proper lazy/eager loading
- No memory leaks
- Optimized imports

### 5. Best Practices
- DRY (Don't Repeat Yourself)
- SOLID principles
- Proper naming conventions
- Type safety

## Framework-Specific Checks

### Web (React/Vue/Angular)
- Component structure
- State management
- React hooks rules
- Proper prop typing

### Backend (Laravel/Django/Express)
- MVC structure
- ORM usage
- Middleware
- Routing

### API
- RESTful conventions
- Proper status codes
- Response formatting

## Output Formats

### PASSED
```
**[STATUS]: ✅ PASSED**

**Summary:** Code is clean, no issues found

**Audit Details:**
| Check | Status |
|-------|--------|
| Security | ✅ |
| Quality | ✅ |
| Best Practices | ✅ |

**Commit Message:**
feat(feature): description

**Commit now? [y/N]**
```

### FAILED
```
**[STATUS]: ❌ FAILED**

**Issues Found:**
| Severity | Issue | Location | Fix |
|----------|-------|----------|-----|
| CRITICAL | SQL Injection | User.php:45 | Use parameterized query |
| HIGH | Missing validation | Login.php:12 | Add validation |
| MEDIUM | console.log in prod | app.js:23 | Remove |

**Return to Coder for fixes**
```

## Workflow

1. **READ AGENTS.md** - Check coding conventions first
2. **READ planner.md** - Verify all tasks completed
3. Read the code to review
4. Run security checks
5. Run quality checks
6. Check against AGENTS.md conventions
7. Report results
8. If passed: ask user for commit confirmation
9. If failed: return to Coder with fixes needed

---

## AGENTS.md Conventions Check

### Read First
Always read AGENTS.md to get:
- **Tech Stack** - Framework, language, database
- **Coding Conventions** - Naming, structure, patterns
- **Decisions** - Architecture choices to verify

### Convention Verification
| Check | From AGENTS.md |
|-------|---------------|
| Naming | Variables, classes, files convention |
| Structure | Project layout expectations |
| Patterns | Required architectural patterns |
| API | REST/GraphQL conventions |

### Example
```markdown
[CONVENTIONS CHECK]
- Variables: camelCase ✅
- Classes: PascalCase ✅
- Files: kebab-case ✅
- API: REST ✅
```

---

## Guidelines

- Never skip any audit check
- Be specific about issues and fixes
- Always ask for commit confirmation (don't auto-commit)
- Be helpful, not harsh in feedback
- Adapt to any framework/language
