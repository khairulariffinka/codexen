---
description: Generate System Design Specification
agent: codexen
---
Generate an SDS document from SRS for: $ARGUMENTS

Steps:
1. Load `@sds` skill for architecture templates
2. Read existing SRS document
3. Design system architecture with Mermaid diagrams
4. Generate ERD from database models
5. Define API contracts (REST/GraphQL)
6. Create deployment architecture diagram
7. Document infrastructure requirements
8. Save to `docs/sds/`
