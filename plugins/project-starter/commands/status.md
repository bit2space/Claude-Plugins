---
description: Show project status - quick overview without full startup flow
allowed-tools: ["Bash", "Read", "Glob", "Grep"]
argument-hint: ""
---

# Project Status Check

## Your Task

Quickly show the current project status without the full interactive startup flow. This is a read-only, fast overview.

### Step 1: Gather Information (in parallel)

Run these checks efficiently using parallel Bash calls:

1. **Current directory:** `pwd`
2. **Git status:** `git status --porcelain 2>/dev/null | wc -l`
3. **Git branch:** `git branch --show-current 2>/dev/null`
4. **Recent commit:** `git log -1 --format="%h %s" 2>/dev/null`

Use Glob to check for key files:
- `CLAUDE.md`
- `README.md`
- `tasks/TODO.md` or `TODO.md`
- `docs/session-notes.md`
- `features.json`

### Step 2: Read TODO Status

If TODO.md exists (prefer `tasks/TODO.md`):
- Count tasks in each section (TODO/IN-PROGRESS/DONE)
- Use Grep to count: `## TODO`, `## IN-PROGRESS`, `## DONE` sections
- Count `- [ ]` (unchecked) and `- [x]` (checked) items

### Step 2.5: Read Feature Status

If features.json exists:
- Count total features
- Count by status: done, in-progress, pending, failed, blocked
- Find current in-progress feature (ID and description)

### Step 3: Present Quick Status

Output a compact status summary:

```
★ Project Status ─────────────────────────────────
PROJECT: [Name from directory]
BRANCH: [branch] | [N] uncommitted changes
LAST COMMIT: [hash] [message]

FEATURES: [X]/[Y] done, [Z] in-progress
→ [FEAT-XXX] [current in-progress description]

TASKS:
→ IN-PROGRESS: [N] tasks
  TODO: [N] tasks | DONE: [N] tasks

FILES:
✓ CLAUDE.md  ✓ README.md  ✓ TODO.md  ✓ features.json
              (or ✗ for missing files)
─────────────────────────────────────────────────────
```

### Step 4: Show In-Progress Tasks (if any)

If there are IN-PROGRESS tasks, list them briefly:

```
CURRENT WORK:
1. [First in-progress task]
2. [Second in-progress task]
```

## Important Guidelines

1. **Read-only**: Do NOT modify any files or ask questions
2. **Fast**: No interactive prompts, no AskUserQuestion
3. **Compact**: Keep output concise, single screen
4. **Graceful**: Handle missing files silently (just show ✗)

## Example Output

```
★ Project Status ─────────────────────────────────
PROJECT: marketplace-platform
BRANCH: feature/payments | 3 uncommitted changes
LAST COMMIT: a1b2c3d Add payment validation

FEATURES: 8/15 done, 1 in-progress
→ [FEAT-009] Implement Stripe payment integration

TASKS:
→ IN-PROGRESS: 2 tasks
  TODO: 5 tasks | DONE: 12 tasks

FILES:
✓ CLAUDE.md  ✓ README.md  ✓ TODO.md  ✓ features.json

CURRENT WORK:
1. Implement Stripe payment integration
2. Write API documentation
─────────────────────────────────────────────────────
```

---

Start by gathering all information in parallel, then present the status.
