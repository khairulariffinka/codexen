---
description: Check context usage with detailed token breakdown
---

Call the `check_context` tool with `detailed: true`, then give a short summary of context usage:
- Current context size, model limit and percentage
- Which thresholds (70/80/90/95%) have been reached
- Session cost so far
- Recommendation: at 80%+ run @checkpoint-writer; at 90%+ checkpoint then /compact

$ARGUMENTS
