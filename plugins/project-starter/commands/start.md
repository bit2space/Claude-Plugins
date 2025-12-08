---
description: Start project session - load context, show status, choose task
allowed-tools: ["Bash", "Read", "Write", "Glob", "Grep", "AskUserQuestion"]
argument-hint: "[task focus]"
---

# Project Session Startup

## Your Task

You are helping the user start a work session on their project. Follow these steps carefully to provide an interactive, helpful project startup experience.

### Step 1: Gather Environment Context

First, gather information about the current environment using the Bash tool:

1. **Check current directory:** `pwd`
2. **Check if Git repository:** `git rev-parse --is-inside-work-tree 2>/dev/null`
3. **Get Git branch:** `git branch --show-current 2>/dev/null`
4. **Count uncommitted changes:** `git status --porcelain 2>/dev/null | wc -l`
5. **Check for key files:** Use Glob or test for CLAUDE.md, README.md, tasks/TODO.md, TODO.md

Run these checks efficiently (you can combine some in parallel Bash calls).

### Step 2: Verify Location

Check the current directory from the context above:

- **If in `~/Projects/[project-name]`**: Proceed with that project
- **If in `~/Projects/` (root)**:
  - List available projects using `ls ~/Projects`
  - Use AskUserQuestion to ask which project to start
  - Confirm the selection
- **If elsewhere**:
  - Confirm with user: "Not in ~/Projects. Start session here in [current directory]?"
  - Use AskUserQuestion with options: "Yes, use current directory" / "No, navigate to ~/Projects"

### Step 3: Load Project Context

Read the following files **if they exist** (handle missing files gracefully):

1. **CLAUDE.md** (project-specific rules and context)
   - If exists: Read it fully, extract key information (project goals, type, boundaries)
   - If missing: Note for later proposal

2. **README.md** (project overview)
   - If exists: Read it, extract project description and setup info
   - If missing: Note for later proposal

3. **tasks/TODO.md OR TODO.md** (task list)
   - Check both locations (prefer tasks/TODO.md per user's structure)
   - If exists: Read it, count tasks in each section (TODO/IN-PROGRESS/DONE)
   - If missing: Note for later proposal

4. **features.json** (feature tracking - Agent Harness pattern)
   - If exists: Read it and extract:
     - Total feature count
     - Done features (status: "done" with passes: true)
     - In-progress features (status: "in-progress")
     - Pending features (status: "pending")
     - Current in-progress feature ID and description
   - If missing: Note for later proposal (suggest /init-features)

5. **Project Structure Analysis**
   - Use Glob to find key directories:
     - `docs/`, `src/`, `tests/`, `reference/`, `tasks/`, `research/`, `experiments/`, `archive/`
   - Identify project template type based on structure:
     - **Template 1** (Documentation/Analysis): Has `docs/`, `reference/`, `tasks/`, `archive/`
     - **Template 2** (Development): Has `src/`, `tests/`, `docs/`
     - **Template 3** (Research): Has `research/`, `experiments/`
     - **Unknown**: Doesn't match any template

### Step 4: Present Project Summary

Create a comprehensive summary in this format:

```
★ Project Session Ready ───────────────────────

PROJECT: [Project Name from directory]
LOCATION: [Full path]
TYPE: [Template 1/2/3/Unknown - based on structure]

GIT STATUS:
- Repository: [Yes/No]
- Branch: [branch name or N/A]
- Changes: [N uncommitted changes]

LOADED CONTEXT:
✓ CLAUDE.md - [Brief summary of goals/purpose, max 1 line]
✓ README.md - [Brief project description, max 1 line]
✓ TODO.md - [X TODO, Y IN-PROGRESS, Z DONE tasks]
✓ features.json - [X/Y done, Z in-progress]
  → [FEAT-XXX] [current in-progress feature description]

OR if files are missing:

MISSING FILES:
✗ CLAUDE.md - Project-specific configuration and goals
✗ README.md - Project overview and documentation
✗ TODO.md - Task tracking and progress
✗ features.json - Feature tracking (run /init-features to set up)

PROJECT STRUCTURE:
- [List key directories found, e.g., "docs/, src/, tests/"]
- [Or "Minimal structure" if few/no directories]

─────────────────────────────────────────────────
```

### Step 5: Handle Missing Critical Files

**If CLAUDE.md is missing:**

Use AskUserQuestion:
- Question: "This project doesn't have a CLAUDE.md file. This file defines project-specific rules, goals, and context. Would you like to create one?"
- Options:
  1. "Yes, create from template" - "I'll help set up CLAUDE.md based on your project type"
  2. "Yes, minimal version" - "Create a simple CLAUDE.md with basic structure"
  3. "No, skip for now" - "Continue without CLAUDE.md"

If user chooses Yes (either option):
- Ask which template type: Documentation/Analysis, Development, or Research
- **DO NOT create the file yet** - explain what will be in it and wait for confirmation
- Prepare content based on template but let user review first

**If README.md is missing:**

Use AskUserQuestion:
- Question: "No README.md found. Would you like to create one?"
- Options:
  1. "Yes, create README" - "I'll help set up project documentation"
  2. "No, skip" - "Continue without README"

**If TODO.md is missing:**

Use AskUserQuestion:
- Question: "No task tracking file found. Would you like to create tasks/TODO.md with the TODO/IN-PROGRESS/DONE structure?"
- Options:
  1. "Yes, create TODO.md" - "Set up task tracking in tasks/TODO.md"
  2. "No, skip" - "Continue without task tracking"

**If features.json is missing:**

Use AskUserQuestion:
- Question: "No feature tracking found. Feature tracking helps with long-running tasks by breaking work into atomic, testable features. Would you like to set it up?"
- Options:
  1. "Yes, initialize features" - "Run /init-features to create features.json"
  2. "No, skip" - "Continue without feature tracking"

If user chooses Yes, remind them to run `/project-starter:init-features` after startup completes.

**Note:** Handle these sequentially (one at a time), not all at once.

### Step 6: Offer Additional Context

**Memory Search:**
If the project name or context suggests relevance to user's memories:
- Suggest: "Would you like me to search ~/memories/ for relevant context about [project topic]?"
- Only search if user confirms

**Git History:**
If this is an active git repository with commits:
- Offer: "Would you like me to review recent commits to understand what was worked on last?"

### Step 7: Ask What's Next

Use AskUserQuestion to ask what the user wants to work on:

**If features.json exists with in-progress feature:**

Question: "What would you like to work on today?"
Options (prioritize current feature):
1. "Continue feature: [FEAT-XXX] [description]" - "Resume work on current feature"
2. "Start next feature: [FEAT-YYY] [description]" - "Begin the next pending feature"
3. "Review project documentation" - "Read through docs and understand context"
4. "Explore codebase" - "Navigate and understand the code structure"

**If features.json exists but no in-progress feature:**

Question: "What would you like to work on today?"
Options:
1. "Start feature: [FEAT-XXX] [first pending feature]" - "Begin working on this feature"
2. "Review features list" - "See all pending features"
3. "Review project documentation" - "Read through docs and understand context"
4. "Explore codebase" - "Navigate and understand the code structure"

**If TODO.md exists with tasks (no features.json):**

Question: "What would you like to work on today?"
Options (customize based on actual tasks found):
1. "Continue in-progress: [first IN-PROGRESS task name]" - "Resume work on [task]"
2. "Start new task: [first TODO task name]" - "Begin working on [task]"
3. "Review project documentation" - "Read through docs and understand context"
4. "Explore codebase" - "Navigate and understand the code structure"

**If neither TODO.md nor features.json exists:**

Question: "What would you like to work on today?"
Options:
1. "Set up project structure" - "Create directories and initial files"
2. "Initialize feature tracking" - "Run /init-features to set up features.json"
3. "Review existing code" - "Explore what's already here"
4. "Start coding" - "Begin implementation work"

### Step 8: Execute User's Choice

Based on the user's selection:

1. **If continuing/starting a task:**
   - Load relevant context for that task
   - If it's from TODO.md, show the full task description
   - Ask if they want to create a TodoWrite session tracker
   - Provide next steps or ask clarifying questions

2. **If reviewing documentation:**
   - List available docs
   - Ask which to review first
   - Read and summarize

3. **If exploring codebase:**
   - Show project structure
   - Identify entry points
   - Offer to explain architecture

4. **If setting up:**
   - Propose directory structure based on project type
   - Create files as confirmed by user

### Step 9: Create PROGRESS.md Scratchpad

After the user selects their task, create a live working progress file:

1. **Create PROGRESS.md in project root:**
   ```markdown
   # Progress: [Task Name from user's choice]

   **Started:** [Current date/time]
   **Status:** 🔄 In Progress

   ## Current Task
   [Description from user's selection]

   ## Checklist
   - [ ] Step 1: [first subtask]
   - [ ] Step 2: [second subtask]
   - [ ] Step 3: [third subtask]

   ## Notes
   [To be filled during work]

   ## Files Modified
   [To be updated as files change]
   ```

2. **Break down task into steps:**
   - Based on selected task, propose 3-5 concrete subtasks
   - Use AskUserQuestion: "Here's a suggested breakdown. Modify or confirm?"
   - Options: "Looks good" / "Let me adjust"

3. **Confirm creation:**
   ```
   ✓ Created PROGRESS.md - I'll update this as we work.
     You can check it anytime to see current progress.
   ```

**Why PROGRESS.md?** This pattern from Anthropic's Claude Code Best Practices helps maintain context across work iterations. Unlike session-notes.md (retrospective), PROGRESS.md is updated live during work.

### Edge Case Handling

**Empty Project (no files, no structure):**
- Identify as "New/Empty Project"
- Use AskUserQuestion: "This appears to be a new project. How would you like to set it up?"
  - Options: Template 1 structure / Template 2 structure / Template 3 structure / Custom

**TODO.md in root instead of tasks/**:
- Note the location
- Suggest: "I found TODO.md in the root directory. Your standard structure uses tasks/TODO.md. Would you like to move it?"

**Multiple potential projects (in ~/Projects/ root):**
- List all subdirectories
- Ask which one to start

**Not a git repository:**
- Note this in summary
- Offer: "Would you like to initialize git for this project?"

---

## Important Guidelines

1. **Don't modify files** without explicit user confirmation
2. **Ask questions sequentially** - one at a time, not all at once
3. **Be specific** - use real data from the project, not placeholders
4. **Stay focused** - this is about starting the session, not implementing features
5. **Graceful degradation** - work with whatever files exist, don't require everything
6. **Respect user's structure** - follow their Templates (1/2/3) when suggesting structure

---

## Example Interaction Flow

```
[Read context from inline bash]

★ Project Session Ready ───────────────────────
PROJECT: marketplace-platform
LOCATION: /Users/kamil/Projects/marketplace-platform
TYPE: Template 2 (Development)

GIT STATUS:
- Repository: Yes
- Branch: feature/payment-integration
- Changes: 3 uncommitted changes

LOADED CONTEXT:
✓ CLAUDE.md - E-commerce platform with focus on payment processing
✓ README.md - Marketplace connecting buyers and sellers
✓ TODO.md - 5 TODO, 2 IN-PROGRESS, 12 DONE tasks

PROJECT STRUCTURE:
- src/, tests/, docs/, .github/
─────────────────────────────────────────────────

[Check what's IN-PROGRESS in TODO.md]

You have 2 tasks in progress:
1. Implement Stripe payment integration
2. Write API documentation for payment endpoints

What would you like to work on today?
[Show AskUserQuestion with relevant options]
```

---

## Tool Call Examples

These examples show exact tool invocations with expected outputs to help you execute correctly.

### Example: Parallel Environment Checks (Step 1)

**Tool Calls (run in parallel):**
```
Bash: pwd
Bash: git rev-parse --is-inside-work-tree 2>/dev/null
Bash: git branch --show-current 2>/dev/null
Bash: git status --porcelain 2>/dev/null | wc -l
```

**Expected Results:**
```
pwd → /Users/kamil/Projects/marketplace-platform
git rev-parse → true
git branch → feature/payment-integration
git status | wc -l → 3
```

### Example: Reading features.json

**Tool Call:**
```
Read: features.json
```

**Expected Structure:**
```json
{
  "features": [
    {"id": "FEAT-001", "status": "done", "passes": true, "description": "User login"},
    {"id": "FEAT-002", "status": "in-progress", "passes": false, "description": "Payment integration"}
  ]
}
```

**What to extract:**
- Total: 2 features
- Done: 1 (count where status="done" AND passes=true)
- In-progress: 1 (current work)
- Current feature: FEAT-002 "Payment integration"

### Example: AskUserQuestion Format (Step 7)

**Tool Call:**
```json
AskUserQuestion: {
  "questions": [{
    "question": "What would you like to work on today?",
    "header": "Task",
    "options": [
      {"label": "Continue FEAT-002", "description": "Resume payment integration"},
      {"label": "Start FEAT-003", "description": "Begin user dashboard"},
      {"label": "Review docs", "description": "Read through project documentation"},
      {"label": "Explore code", "description": "Navigate and understand codebase"}
    ],
    "multiSelect": false
  }]
}
```

### Example: Glob for Project Structure

**Tool Call (check for known project directories):**
```
Glob: {docs,src,tests,tasks,research,experiments,archive,reference,.github}
```

**Expected Result:** Returns list of directories that exist, e.g., `[docs, src, tests]`

**Use to identify project template:**
- Template 1 (Documentation): `docs/`, `reference/`, `tasks/`, `archive/`
- Template 2 (Development): `src/`, `tests/`, `docs/`, `.github/`
- Template 3 (Research): `research/`, `experiments/`

---

## Context Budget Guidelines

### Large File Handling
- **features.json > 50 features:** Summarize counts, don't dump full JSON
- **TODO.md > 100 lines:** Count sections, show only IN-PROGRESS items
- **README.md > 200 lines:** Extract first paragraph + key sections only

### Result Summarization Pattern

**Instead of showing full file contents, summarize:**
```
LOADED CONTEXT:
✓ CLAUDE.md - E-commerce platform with payment focus (15 rules)
✓ README.md - Marketplace connecting buyers and sellers
✓ TODO.md - 5 TODO, 2 IN-PROGRESS, 12 DONE tasks
✓ features.json - 8/15 done, 1 in-progress
  → [FEAT-009] Implement Stripe payment integration
```

### Aggregation Examples
- **Features:** "8/15 done, 1 in-progress" (not full JSON)
- **Tasks:** "5 TODO, 2 IN-PROGRESS, 12 DONE" (not full list)
- **Git:** "3 uncommitted changes" (not full porcelain output)
- **Structure:** "src/, tests/, docs/" (not full tree)

---

Start by verifying the location and loading the project context as described above.
