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

3. **Get current directory:**
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
✓ Session notes saved to docs/session-notes.md

CURRENT STATUS:
- TODO: [N] tasks
- IN-PROGRESS: [N] tasks
- DONE: [N] tasks (+[N] this session)

NEXT SESSION:
→ [Suggested next task or action]

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

Start by gathering session activity as described above.
