# Quick Start Guide

**5 minutes to your first AI coding assistant**

---

## Step 1: Clone / Download

```bash
git clone https://github.com/khairulariffinka/codexen.git
cd codexen
```

---

## Step 2: Install

Load the install documentation:

```
"Load install.md"
```

Select option `3` for both platforms, or your preferred option:
- `1` = OpenCode
- `2` = Gemini CLI  
- `3` = Both

Done!

---

## Step 3: Setup Profile (Optional but Recommended)

```
"setup profile"
```

This sets up your global profile so CodeXen knows:
- Your name
- Preferred language (English / Bahasa Melayu)
- Response style preference

Just fill in the fields and say "done" when finished.

## Step 4: Test It Works

Restart your terminal, then type:

```
codexen, hello!
```

You should get a greeting back. If you do, you're ready to go!

---

## Step 3: Build Something

Just tell CodeXen what you want:

```
codexen, build a login page
```

CodeXen will:
1. Research your project
2. Create a plan
3. Write the code
4. Run security checks
5. Offer to commit

That's it! No need to manage 23 subagents - CodeXen handles everything.

---

## Quick Examples

| What you type | What happens |
|---------------|--------------|
| `build a REST API` | Full API with routes, models, tests |
| `create a React component` | Component with props, styling |
| `review my code` | Security & performance audit |
| `debug: login error` | Finds and fixes the bug |
| `write tests for auth` | Unit & integration tests |

---

## Professional Projects: BRS → SRS → SDS

For formal projects, use the specification chain:

```bash
@brs-manager create BRS      # 1. Business requirements
@srs-manager create SRS      # 2. Technical requirements (NEW!)
@sds-manager create SDS     # 3. System design
@planner create plan        # 4. Implementation tasks
```

| Stage | Agent | Creates |
|-------|-------|---------|
| Business | @brs-manager | docs/BRS-v1.0.md |
| Software | @srs-manager | docs/SRS-v1.0.md |
| Design | @sds-manager | docs/SDS-v1.0.md |
| Plan | @planner | planner.md |

**Example:**
```
@brs-manager create BRS
( paste meeting notes: "Client wants inventory system, RM50K budget" )

@srs-manager create SRS
( auto-generates FR-01, NFR-01, use cases from BRS )
```

---

## Modes (Optional)

Most of the time, you don't need modes. But if you want:

| Mode | Use when |
|------|----------|
| `quick, build API` | Fast, skip audits |
| `review, check code` | Security/performance check |
| `debug, fix error` | Troubleshooting |

Start with default mode - it does everything!

---

## Problems?

See [setup-guide.md](./setup-guide.md) or [README.md](./README.md) for full documentation.

---

**Ready to code! 🚀**
