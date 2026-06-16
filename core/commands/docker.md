---
description: Setup Docker for the project
agent: codexen
---
Setup Docker configuration for the project.

Steps:
1. Analyze project structure and tech stack
2. Generate optimized `Dockerfile` with:
   - Multi-stage build
   - Proper base image selection
   - Layer caching optimization
   - Security best practices (non-root user)
3. Generate `docker-compose.yml` for local development
4. Generate `.dockerignore`
5. Add health check endpoints if applicable
6. Document usage in README
