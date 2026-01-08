---
description: End project session - save notes, update TODOs, prepare for next time
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - AskUserQuestion
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

### Step 1.5: Check for Missing Files (Offer to Create)

After gathering data, check which tracking files are missing and offer to create them:

1. **Check which files exist:**
   - Use Glob to find: `PROGRESS.md`, `features.json`, `CLAUDE.md`
   - Track which are missing

2. **For each missing file, ask user if they want to create it:**

   **If no PROGRESS.md:**
   ```
   AskUserQuestion:
   Question: "No PROGRESS.md found. Would you like to create one for future sessions?"
   Options:
   1. "Yes, create PROGRESS.md" - "Initialize with current session summary"
   2. "No, use session-notes.md" - "Fall back to docs/session-notes.md"
   ```
   If yes: Will create PROGRESS.md in Step 4 with session summary

   **If no features.json:**
   ```
   AskUserQuestion:
   Question: "No features.json found. Feature tracking helps link work across sessions. Set it up?"
   Options:
   1. "Yes, initialize features" - "Run /init-features after this session ends"
   2. "No, skip" - "Continue without feature tracking"
   ```
   If yes: Remind user at end to run `/project-starter:init-features`

   **If no CLAUDE.md:**
   ```
   AskUserQuestion:
   Question: "No CLAUDE.md found. This file stores project status and goals. Create one?"
   Options:
   1. "Yes, create CLAUDE.md" - "Create with basic template (Status, Last Updated, Priority)"
   2. "No, skip" - "Continue without project config"
   ```
   If yes: Create CLAUDE.md with template:
   ```markdown
   # [Project Name]

   **Status**: in-progress
   **Last Updated**: [today's date YYYY-MM-DD]
   **Priority**: medium

   ## Project Goal

   [To be filled in]
   ```

**Note:** Group all missing file prompts together in one interaction if multiple files are missing. Don't ask about each file separately.

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
   - **Try to match each task to a feature** (if features.json exists):
     - For each completed task, search features.json for matching feature
     - Check if task description is substring of feature description (case-insensitive)
     - Check if feature description is substring of task description
     - If match found, append feature ID to the task
   - Move selected tasks from TODO or IN-PROGRESS sections to DONE section
   - Add completion date with optional feature ID:
     - With match: `- [x] Implement Stripe integration [FEAT-002] (YYYY-MM-DD)`
     - Without match: `- [x] Write unit tests (YYYY-MM-DD)`
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

5. **Try to match completed features to TODO tasks** (if TODO.md exists):
   - For each completed feature, search TODO.md DONE section for matching task
   - Use same bidirectional substring matching as Step 3 (case-insensitive)
   - If match found: Note the linkage for Step 4 session summary
   - If no match found: Flag for Step 5.5 consistency validation

6. **If there are still in-progress features:**
   - Ask: "You have [FEAT-XXX] still in progress. Add a note about current state?"
   - If yes: Update the feature's `notes` field in features.json

### Step 3.75: Update CLAUDE.md Status (if exists)

**If CLAUDE.md exists and has a Status field:**

1. **Read current status** from CLAUDE.md header
   - Look for pattern: `**Status**: [value]`
   - Common values: `planning`, `in-progress`, `blocked`, `completed`, `paused`

2. **Ask user if status should change:**
   ```
   AskUserQuestion:
   Question: "Project status is '[current status]'. Would you like to update it?"
   Options:
   1. "Keep as [current]" - "No change needed"
   2. "Mark as completed" - "Project finished"
   3. "Mark as blocked" - "Stuck on something"
   4. "Mark as paused" - "Taking a break"
   ```

3. **If user changes status:**
   - Use Edit tool to update Status field in CLAUDE.md
   - Always update `**Last Updated**: YYYY-MM-DD` to today's date
   - Confirm: "✓ CLAUDE.md status updated to [new status]"

**Edit pattern for CLAUDE.md:**
```
Edit: CLAUDE.md
old_string: **Status**: in-progress
**Last Updated**: 2025-12-01
new_string: **Status**: completed
**Last Updated**: 2025-12-09
```

**Note:** Include both Status and Last Updated lines together to ensure unique match.

### Step 4: Update PROGRESS.md (Unified Session Document)

PROGRESS.md is the unified working document. Ask user what to do with it FIRST, then update accordingly.

**If PROGRESS.md exists:**

1. **Read current PROGRESS.md contents**
   - Count completed vs remaining checklist items
   - Show summary:
     ```
     PROGRESS.md STATUS:
     ✓ 3/5 checklist items completed
     Remaining: Step 4, Step 5
     ```

2. **Ask user what to do with PROGRESS.md FIRST:**
   ```
   AskUserQuestion:
   Question: "What would you like to do with PROGRESS.md?"
   Options:
   1. "Keep for next session" - "Continue working - append session summary"
   2. "Archive and delete" - "Task complete - archive to session-notes.md"
   3. "Delete without archiving" - "Abandon task - discard without saving"
   ```

3. **Based on user choice:**

   **If "Keep for next session":**
   - Append session summary to PROGRESS.md:
     ```markdown
     ## Session: YYYY-MM-DD

     ### Completed This Session
     - [FEAT-002] Implement Stripe integration (passes: true)
     - Fixed typo in README (no feature)

     ### Files Modified
     - src/api/payments.ts
     - src/auth/middleware.ts

     ### Notes
     [User's input about session]
     ```
   - Include feature IDs from completed tasks/features (from Steps 3 and 3.5)
   - Confirm: "✓ PROGRESS.md updated with session summary"

   **If "Archive and delete":**
   - First append session summary to PROGRESS.md (same format as above)
   - Then append entire PROGRESS.md content to `docs/session-notes.md` under today's date
   - Delete PROGRESS.md after archiving
   - Confirm: "✓ Progress archived to docs/session-notes.md, PROGRESS.md deleted"

   **If "Delete without archiving":**
   - Delete PROGRESS.md without appending session data
   - Confirm: "✓ PROGRESS.md deleted (session data not saved)"
   - Note: Session summary will be saved to session-notes.md in Step 4.5 fallback

**If PROGRESS.md doesn't exist but user chose to create one in Step 1.5:**

Create new PROGRESS.md with session summary:
```markdown
# Progress: [Task from session]

**Started:** YYYY-MM-DD
**Status:** 🔄 In Progress

## Session: YYYY-MM-DD

### Completed This Session
- [List completed items with feature IDs]

### Files Modified
- [List from git diff]

### Notes
[User's session notes]
```

### Step 4.5: Save Session Notes (Fallback)

**Only if PROGRESS.md doesn't exist and user didn't want to create one:**

Offer to save session notes to `docs/session-notes.md`:

1. **Ask: "Would you like to save session notes?"**
   - Options:
     - "Yes, save notes" - "Create session notes with what was accomplished"
     - "No, skip" - "End session without saving notes"

2. **If user chooses to save notes:**

   Create/update `docs/session-notes.md` (create `docs/` directory if needed):

   ```markdown
   # Session Notes - [Project Name]

   ## YYYY-MM-DD - Session End

   ### What Was Accomplished
   - [FEAT-XXX] Feature description (if features.json exists)
   - [Brief summary based on git changes]

   ### Files Modified
   - [List files from git diff]

   ### Completed Tasks
   - [List tasks marked as done with feature IDs]

   ### Next Steps
   [User's input about what to do next]

   ---
   ```

   Note: "Consider using /project-starter:start next time for PROGRESS.md tracking"

### Step 5: Suggest Next Session Start

Based on TODO.md status and session notes:

1. **If there are IN-PROGRESS tasks:**
   - "Next session: Continue with [first IN-PROGRESS task]"

2. **If there are TODO tasks but nothing IN-PROGRESS:**
   - "Next session: Start [first TODO task]"

3. **If TODO.md doesn't exist or is empty:**
   - "Next session: Use /project-starter:start to plan your next tasks"

### Step 5.5: Validate Cross-File Consistency

**If both TODO.md and features.json exist:**

Check for consistency between the two tracking systems:

1. **Check completed features have corresponding DONE tasks:**
   - For each feature marked `"status": "done"` in features.json
   - Search TODO.md DONE section for matching task (substring match)
   - Flag if feature is done but no matching TODO found

2. **Check IN-PROGRESS tasks have matching in-progress features:**
   - For each task in TODO.md IN-PROGRESS section
   - Search features.json for feature with `"status": "in-progress"` and matching description
   - Flag if task is in-progress but no matching feature found

3. **If mismatches found, show warning:**
   ```
   ⚠ Consistency Warning:
   - [FEAT-002] marked done but no matching TODO found
   - TODO "Write tests" in-progress but no feature tracks it
   ```

4. **Offer to fix (optional):**
   ```
   AskUserQuestion:
   Question: "Would you like to sync these tracking files?"
   Options:
   1. "Yes, sync them" - "I'll help align TODO.md and features.json"
   2. "No, ignore" - "Leave as-is, they're intentionally different"
   ```

**Note:** This is an opt-in warning only. Many projects intentionally have TODOs without features (small fixes) or features without TODOs (generated from /init-features). Don't require perfect sync.

### Step 6: Final Summary

Show a final wrap-up message:

```
★ Session Complete ────────────────────────────

SAVED:
✓ TODO.md updated - [N] tasks completed [FEAT-XXX, FEAT-YYY]
✓ features.json updated - [N] features completed
✓ CLAUDE.md status updated to [status]
✓ PROGRESS.md updated with session summary
  (or: ✓ Session notes saved to docs/session-notes.md)

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

REMINDERS:
[If user chose to init features: Run /project-starter:init-features]

─────────────────────────────────────────────────

Great work! Use /project-starter:start when you're ready to begin your next session.
```

## Important Guidelines

1. **Non-destructive**: Always ask before modifying files or creating new ones
2. **Offer to create missing files**: Don't silently skip - ask user if they want to create PROGRESS.md, features.json, or CLAUDE.md
3. **Feature ID cross-references**: Link TODO tasks to features using text matching when possible
4. **PROGRESS.md is primary**: Use PROGRESS.md as the unified session document; session-notes.md is archive/fallback
5. **Be specific**: Use real data from git and files, not placeholders
6. **Date format**: Use YYYY-MM-DD for consistency
7. **Preserve structure**: When editing TODO.md, maintain the TODO/IN-PROGRESS/DONE sections
8. **Consistency validation**: Warn about mismatches between TODO.md and features.json but don't require sync

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

**Step 1 - Remove task from IN-PROGRESS (match the specific task line):**
```
Edit: tasks/TODO.md
old_string: - [ ] Implement Stripe integration
new_string:
```

**Why this works:** Removing just the task line is safer than trying to match section headers + task + next section. The task description itself should be unique enough. If multiple tasks have identical descriptions, include the checkbox and any distinguishing context.

**Step 2 - Add to DONE section:**

**Case A: DONE section is empty (no existing tasks):**
```
Edit: tasks/TODO.md
old_string: ## DONE
new_string: ## DONE
- [x] Implement Stripe integration [FEAT-002] (2025-12-08)
```

**Case B: DONE section has existing tasks (append after last task):**
```
Edit: tasks/TODO.md
old_string: - [x] Previous task (2025-12-07)

## ARCHIVE
new_string: - [x] Previous task (2025-12-07)
- [x] Implement Stripe integration [FEAT-002] (2025-12-08)

## ARCHIVE
```

**Case C: DONE is last section (no section after it):**
```
Edit: tasks/TODO.md
old_string: - [x] Previous task (2025-12-07)
new_string: - [x] Previous task (2025-12-07)
- [x] Implement Stripe integration [FEAT-002] (2025-12-08)
```

**Tip:** Read TODO.md structure first to determine which case applies. Use the last existing task in DONE as anchor for appending.

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
