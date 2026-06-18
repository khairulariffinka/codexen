---
name: compress-file
description: >
  Compress natural language memory files (AGENTS.md, planner.md, DECISIONS.md, etc.)
  into terse format to save input tokens. Preserves code, URLs, file paths exactly.
  Compressed version overwrites original. Backup saved as FILE.original.md.
  Trigger: "compress file FILEPATH" or "compress memory file"
license: MIT
compatibility: opencode
metadata:
  audience: all
  workflow: compress-file
---

Compress natural language files to terse format. Save input tokens every session.

## Trigger

`/compress-file <filepath>` or when user asks to compress a memory file.

## Process

1. Read the target file
2. Backup original: `cp FILE FILE.original.md`
3. Apply compression rules
4. Overwrite original with compressed version
5. Report: `Compressed FILE: X tokens → Y tokens (Z% saved)`

## Compression Rules

### Remove
- Articles: a, an, the
- Filler: just, really, basically, actually, simply, essentially
- Pleasantries: "sure", "certainly", "of course", "happy to", "I'd recommend"
- Hedging: "it might be worth", "you could consider"
- Redundant phrasing: "in order to" → "to", "make sure to" → "ensure"
- Connective fluff: "however", "furthermore", "additionally"

### Preserve EXACTLY (never modify)
- Code blocks (``` fenced and indented)
- Inline code (`backtick content`)
- URLs and links
- File paths
- Commands (npm install, git commit, etc.)
- Technical terms (library names, API names)
- Proper nouns
- Dates, version numbers, numeric values
- Environment variables

### Preserve Structure
- All markdown headings
- Bullet point hierarchy
- Numbered lists
- Tables (compress cell text, keep structure)
- Frontmatter/YAML headers

### Compress
- Short synonyms: "big" not "extensive", "fix" not "implement a solution for"
- Fragments: "Run tests before commit" not "You should always run tests before committing"
- Drop "you should", "make sure to", "remember to"
- Merge redundant bullets
- Keep one example where multiple show same pattern

## CRITICAL RULE

Anything inside ``` ... ``` must be copied EXACTLY. Do not:
- remove comments
- remove spacing
- reorder lines
- shorten commands
- simplify anything

Inline code (`...`) must be preserved EXACTLY.

## Pattern

Original:
> You should always make sure to run the test suite before pushing any changes to the main branch. This is important because it helps catch bugs early and prevents broken builds from being deployed to production.

Compressed:
> Run tests before push to main. Catch bugs early, prevent broken prod deploys.

## Boundaries

- ONLY compress natural language files (.md, .txt)
- NEVER modify: .py, .js, .ts, .json, .yaml, .yml, .toml, .env, .lock, .css, .html, .xml, .sql, .sh
- If file has mixed content, compress ONLY prose sections
- Original backed up as FILE.original.md before overwriting
- Never compress FILE.original.md
