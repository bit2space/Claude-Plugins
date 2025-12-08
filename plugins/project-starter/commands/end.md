---
description: End project session - save notes, update TODOs, prepare for next time
allowed-tools: ["Bash", "Read", "Write", "Edit", "Glob", "AskUserQuestion"]
argument-hint: "[session summary]"
---

# Project Session End

## Your Task

You are helping the user end their work session on a project. Follow these steps to wrap up the session, save progress, and prepare for the next work session.

### Step 1: Gather Session Activity

First, analyze what was done during this session:

1. **Check git status:**
   - `git status --porcelain` - Get modified/added/deleted files
   - `git diff --stat` - Get summary of changes
   - `git diff --name-only` - Get list of modified files

2. **Check for TODO.md:**
   - Use Glob to find `tasks/TODO.md` or `TODO.md`
   - If exists: Read it to see current task status

3. **Check for features.json:**
   - If exists: Read it to see feature status
   - Count: total, done, in-progress, pending
   - Note current in-progress feature

4. **Get current directory:**
   - `pwd` - To know which project we're ending session for

Run these checks efficiently (combine in parallel where possible).

### Step 2: Present Session Summary

Show the user what happened during this session:

```
★ Session Summary ─────────────────────────────

PROJECT: [Project name from directory]

SESSION ACTIVITY:
- Modified files: [N files]
- Git changes: [N insertions(+), N deletions(-)]
- Uncommitted changes: [Yes/No]

FILES CHANGED:
[List modified files from git diff --name-only]

CURRENT TODO STATUS:
[If TODO.md exists, show count: X TODO, Y IN-PROGRESS, Z DONE]

FEATURE STATUS:
[If features.json exists: X/Y done, Z in-progress]
→ [FEAT-XXX] [current in-progress feature]

─────────────────────────────────────────────────
```

### Step 3: Update TODO.md (if exists)

**If TODO.md exists:**

1. **Read current TODO.md** to find tasks in IN-PROGRESS or TODO status

2. **Ask user which tasks were completed:**
   - Use AskUserQuestion with multiSelect: true
   - Question: "Which tasks did you complete during this session?"
   - Options: List all IN-PROGRESS and TODO tasks
   - Include option: "None - no tasks completed"

3. **If user selects tasks to complete:**
   - Read the TODO.md file
   - Move selected tasks from TODO or IN-PROGRESS sections to DONE section
   - Add completion date: `- [x] Task description (YYYY-MM-DD)`
   - Use Edit tool to update the file
   - Confirm: "✓ Updated TODO.md: moved N tasks to DONE"

4. **If there are still IN-PROGRESS tasks:**
   - Ask: "You have [N] tasks still in progress. Would you like to add notes about their current state?"
   - If yes: Let user add notes/blockers to those tasks in TODO.md

### Step 3.5: Update features.json (if exists)

**If features.json exists:**

1. **Read current features.json** to find features in `in-progress` status

2. **Ask user which features were completed:**
   - Use AskUserQuestion with multiSelect: true
   - Question: "Which features did you complete during this session?"
   - Options: List all in-progress features by ID and description
   - Include option: "None - no features completed"

3. **If user selects features to complete:**
   - Ask: "Did tests pass for these features?" (important for checkpoint)
   - If yes: Mark `passes: true` and `status: "done"`, add `completed_at: YYYY-MM-DD`
   - If no: Mark `status: "done"`, `passes: false`, add note explaining why
   - Use Edit tool to update features.json
   - Confirm: "✓ Updated features.json: [N] features marked as done"

4. **Suggest checkpoint commit:**
   If any features were marked done with `passes: true`:
   ```
   ★ Checkpoint Ready ─────────────────────────────

   Completed features:
   - [FEAT-XXX] [description]

   Suggested commit:
     feat(FEAT-XXX): [description]

   Would you like to commit this checkpoint?
   ─────────────────────────────────────────────────
   ```

5. **If there are still in-progress features:**
   - Ask: "You have [FEAT-XXX] still in progress. Add a note about current state?"
   - If yes: Update the feature's `notes` field in features.json

### Step 4: Save Session Notes

Offer to save session notes for next time:

1. **Ask: "Would you like to save session notes?"**
   - Options:
     - "Yes, save notes" - "Create session notes with what was accomplished and next steps"
     - "No, skip" - "End session without saving notes"

2. **If user chooses to save notes:**

   Create/update `docs/session-notes.md` in the project directory (create `docs/` directory if it doesn't exist):

   ```markdown
   # Session Notes - [Project Name]

   ## [Date] - Session End

   ### What Was Accomplished
   [Brief summary based on git changes and completed tasks]

   ### Files Modified
   - [List files from git diff]

   ### Completed Tasks
   - [List tasks marked as done]

   ### Current State
   [User's input about current state]

   ### Blockers / Issues
   [User's input about any blockers]

   ### Next Steps
   [User's input about what to do next]

   ---
   ```

   Ask user to provide:
   - Brief description of what was accomplished
   - Any blockers or issues encountered
   - What should be worked on next session

   Use Write or Edit to save the file.

### Step 5: Suggest Next Session Start

Based on TODO.md status and session notes:

1. **If there are IN-PROGRESS tasks:**
   - "Next session: Continue with [first IN-PROGRESS task]"

2. **If there are TODO tasks but nothing IN-PROGRESS:**
   - "Next session: Start [first TODO task]"

3. **If TODO.md doesn't exist or is empty:**
   - "Next session: Use /project-starter:start to plan your next tasks"

### Step 6: Final Summary

Show a final wrap-up message:

```
★ Session Complete ────────────────────────────

SAVED:
✓ TODO.md updated - [N] tasks completed
✓ features.json updated - [N] features completed
✓ Session notes saved to docs/session-notes.md

CURRENT STATUS:
- TODO: [N] tasks
- IN-PROGRESS: [N] tasks
- DONE: [N] tasks (+[N] this session)
- FEATURES: [X]/[Y] done (+[N] this session)

NEXT SESSION:
→ [Suggested next feature or task]
  [FEAT-XXX] [next pending feature description]

GIT STATUS:
[N] uncommitted changes
[Tip: Consider committing your work]

─────────────────────────────────────────────────

Great work! Use /project-starter:start when you're ready to begin your next session.
```

## Important Guidelines

1. **Non-destructive**: Always ask before modifying TODO.md or creating files
2. **Graceful degradation**: Work even if TODO.md doesn't exist
3. **Be specific**: Use real data from git and files, not placeholders
4. **Date format**: Use YYYY-MM-DD for consistency
5. **Preserve structure**: When editing TODO.md, maintain the TODO/IN-PROGRESS/DONE sections
6. **Session notes location**: Always save to `docs/session-notes.md` (canonical path)

## Edge Cases

**No git repository:**
- Skip git-related summaries
- Focus on TODO.md updates and session notes

**No TODO.md:**
- Skip TODO updates
- Focus on session notes and git summary
- Suggest creating TODO.md for next session

**No changes detected:**
- Confirm: "No files were modified during this session. Is this correct?"
- Still offer to save session notes (maybe research/reading was done)

**Empty git diff (all changes committed):**
- Congratulate: "All changes committed ✓"
- Still process TODO.md and session notes

## Example Interaction

```
★ Session Summary ─────────────────────────────
PROJECT: marketplace-platform

SESSION ACTIVITY:
- Modified files: 5 files
- Git changes: 127 insertions(+), 43 deletions(-)
- Uncommitted changes: Yes

FILES CHANGED:
- src/auth/middleware.ts
- src/api/payments.ts
- tests/auth.test.ts
- docs/api.md
- README.md

CURRENT TODO STATUS:
5 TODO, 2 IN-PROGRESS, 12 DONE
─────────────────────────────────────────────────

Which tasks did you complete during this session?
[Show AskUserQuestion with IN-PROGRESS tasks...]

✓ Updated TODO.md: moved 2 tasks to DONE

Would you like to save session notes?
[Show AskUserQuestion...]

[Collect session notes from user...]

✓ Session notes saved to docs/session-notes.md

★ Session Complete ────────────────────────────
SAVED:
✓ TODO.md updated - 2 tasks completed
✓ Session notes saved

NEXT SESSION:
→ Continue with: Write API documentation for payment endpoints

GIT STATUS:
5 uncommitted changes
Tip: Consider committing your work
─────────────────────────────────────────────────
```

---

## Tool Call Examples

These examples show exact tool invocations with expected outputs.

### Example: Git Analysis (Step 1 - parallel)

**Tool Calls (run in parallel):**
```
Bash: git status --porcelain
Bash: git diff --stat
Bash: git diff --name-only
Bash: pwd
```

**Expected Results:**
```
git status --porcelain →
 M src/auth/middleware.ts
 M src/api/payments.ts
?? tests/new-test.ts

git diff --stat →
 2 files changed, 127 insertions(+), 43 deletions(-)

git diff --name-only →
src/auth/middleware.ts
src/api/payments.ts

pwd →
/Users/kamil/Projects/marketplace-platform
```

### Example: Updating features.json (Step 3.5)

**Before (Read features.json):**
```json
{"id": "FEAT-002", "status": "in-progress", "passes": false, "description": "Payment integration"}
```

**Edit Call (include feature ID for safety):**
```
Edit: features.json
old_string: {"id": "FEAT-002", "status": "in-progress", "passes": false
new_string: {"id": "FEAT-002", "status": "done", "passes": true, "completed_at": "2025-12-08"
```

**Why include feature ID:** Generic matches like `"status": "in-progress"` could match the wrong feature if multiple exist.

### Example: AskUserQuestion with multiSelect (Step 3)

**Tool Call:**
```json
AskUserQuestion: {
  "questions": [{
    "question": "Which tasks did you complete during this session?",
    "header": "Completed",
    "options": [
      {"label": "Implement Stripe integration", "description": "Payment processing setup"},
      {"label": "Write API documentation", "description": "Payment endpoints docs"},
      {"label": "None", "description": "No tasks completed this session"}
    ],
    "multiSelect": true
  }]
}
```

### Example: Updating TODO.md (Step 3)

**Moving a task requires two edits:**

**Step 1 - Remove from IN-PROGRESS (include enough context for unique match):**
```
Edit: tasks/TODO.md
old_string: ## IN-PROGRESS
- [ ] Implement Stripe integration

## TODO
new_string: ## IN-PROGRESS

## TODO
```

**Step 2 - Add to DONE section:**
```
Edit: tasks/TODO.md
old_string: ## DONE
new_string: ## DONE
- [x] Implement Stripe integration (2025-12-08)
```

**Note:** Always include surrounding context (like section headers) to ensure unique matches.

### Example: Creating Session Notes (Step 4)

**Write Call:**
```
Write: docs/session-notes.md
content: |
  # Session Notes - marketplace-platform

  ## 2025-12-08 - Session End

  ### What Was Accomplished
  - Completed Stripe payment integration
  - Added error handling for failed transactions

  ### Files Modified
  - src/api/payments.ts
  - src/auth/middleware.ts

  ### Next Steps
  - Test payment flow end-to-end
  - Add webhook handling
```

---

## Context Budget Guidelines

### Large Output Handling
- **Git diff > 20 files:** Show `git diff --stat` summary only
- **TODO.md > 50 tasks:** Count by section, list only IN-PROGRESS
- **features.json > 30 features:** Show counts and current feature only

### Result Summarization Pattern

**Instead of full git output:**
```
SESSION ACTIVITY:
- Modified files: 5 files
- Git changes: 127 insertions(+), 43 deletions(-)
- Uncommitted changes: Yes

Key files: src/api/payments.ts, src/auth/middleware.ts
```

### Session Notes - Keep Concise
- What Was Accomplished: 2-3 bullet points max
- Files Modified: List only, no content
- Next Steps: 1-2 actionable items

---

Start by gathering session activity as described above.
