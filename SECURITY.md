# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 0.5.x   | ✅ Active |
| < 0.5   | ❌ No longer supported |

## Reporting a Vulnerability

If you find a security vulnerability in CodeXen:

1. **DO NOT** open a public issue
2. Email the maintainer directly: [odasokmo@gmail.com](mailto:odasokmo@gmail.com)
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

## What to Expect

- **24-48 hours**: Initial acknowledgment
- **5-7 days**: Assessment and fix timeline
- **Coordinated disclosure**: Fix released, then vulnerability announced

## Scope

### What's Covered
- Permission bypass (agents accessing restricted bash/edit)
- Secret leakage (API keys in logs/lessons)
- Token injection via agent prompts

### What's NOT Covered
- Vulnerabilities in OpenCode itself (report to OpenCode)
- Vulnerabilities in third-party AI models
- Misconfiguration by user
