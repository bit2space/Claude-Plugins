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

## Tool Call Examples

**IMPORTANT:** This command is READ-ONLY. Never use Write, Edit, or AskUserQuestion.

### Example: All Parallel Status Checks

**Tool Calls (ALL run in parallel for speed):**
```
Bash: pwd
Bash: git status --porcelain 2>/dev/null | wc -l
Bash: git branch --show-current 2>/dev/null
Bash: git log -1 --format="%h %s" 2>/dev/null
Glob: {CLAUDE.md,README.md,TODO.md,tasks/TODO.md,features.json,docs/session-notes.md}
```

**Expected Results:**
```
pwd → /Users/kamil/Projects/marketplace-platform
git status | wc -l → 3
git branch → feature/payments
git log -1 → a1b2c3d Add payment validation
Glob → [CLAUDE.md, README.md, tasks/TODO.md, features.json]
```

### Example: Reading features.json for Status

**Tool Call:**
```
Read: features.json
```

**Extract counts only:**
- Done: count where `status === "done" && passes === true`
- In-progress: count where `status === "in-progress"`
- Current: find feature where `status === "in-progress"`

### Example: Counting TODO Items

**Tool Call:**
```
Grep: pattern="- \[ \]" file=tasks/TODO.md
Grep: pattern="- \[x\]" file=tasks/TODO.md
```

Or read file and count sections manually.

---

## Context Budget Guidelines

### READ-ONLY Constraints
- **Allowed:** Bash, Read, Glob, Grep
- **Forbidden:** Write, Edit, AskUserQuestion, Task

### Output Limits
- **Status output:** Single screen (< 30 lines)
- **No full file contents:** Only counts and summaries
- **No interaction:** Fast, silent execution

### Aggregation Rules
```
FEATURES: 8/15 done, 1 in-progress     ← counts only
TASKS: 5 TODO, 2 IN-PROGRESS, 12 DONE  ← counts only
FILES: ✓ ✓ ✓ ✗                         ← existence only
```

---

Start by gathering all information in parallel, then present the status.
