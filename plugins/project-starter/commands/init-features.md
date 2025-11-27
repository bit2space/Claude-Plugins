---
description: Initialize features.json for feature tracking in the current project
allowed-tools: ["Bash", "Read", "Write", "Glob", "AskUserQuestion", "Task"]
argument-hint: "[project description]"
---

# Initialize Features

## Your Task

Create a `features.json` file for the current project to enable feature tracking. This follows the "Effective Harnesses for Long-Running Agents" pattern from Anthropic.

### Step 1: Verify Environment

1. **Check if git repo:**
   ```bash
   git rev-parse --is-inside-work-tree 2>/dev/null
   ```
   If not a git repo, warn user:
   "Feature tracking works best with git for checkpointing. Would you like to continue anyway?"

2. **Check if features.json exists:**
   - If exists: Show current stats and ask if user wants to add more features
   - If not: Proceed with creation

3. **Get current directory:**
   ```bash
   pwd
   ```

### Step 2: Gather Project Context

Read the following files if they exist:

1. **CLAUDE.md** - Project-specific rules and goals
2. **README.md** - Project overview and description
3. **TODO.md** or **tasks/TODO.md** - Existing task list
4. **package.json** / **requirements.txt** / **Cargo.toml** - Tech stack info

Use Glob to find these files.

### Step 3: Ask for Project Description

If the user didn't provide a description in the command argument:

Use AskUserQuestion:
- Question: "Briefly describe what this project should do (or press enter to use README/CLAUDE.md):"
- Options:
  1. "Use existing docs" - "Analyze README.md and CLAUDE.md for features"
  2. "I'll describe it" - "Let me provide a project description"

If user chooses to describe, wait for their input.

### Step 4: Launch Feature Initializer Agent

Use the Task tool to launch the feature-initializer agent:

```
Prompt: |
  Initialize features.json for this project.

  Project directory: [pwd result]

  Project context:
  - CLAUDE.md: [contents or "not found"]
  - README.md: [contents or "not found"]
  - TODO.md: [contents or "not found"]
  - Tech stack: [from package.json etc]

  User description: [if provided]

  Generate a comprehensive features.json with 10-50 atomic, testable features.
  Write the file to ./features.json in the project root.

Subagent type: feature-dev:code-architect
```

### Step 5: Review and Confirm

After the agent generates features.json:

1. **Read the generated file**
2. **Show summary to user:**
   ```
   ★ Features Initialized ────────────────────────

   PROJECT: [name]
   FEATURES: [count] total

   BY CATEGORY:
   - functional: [N]
   - ui: [N]
   - api: [N]
   - infrastructure: [N]

   BY PRIORITY:
   - high: [N]
   - medium: [N]
   - low: [N]

   FIRST 5 FEATURES:
   1. [FEAT-001] [description]
   2. [FEAT-002] [description]
   3. [FEAT-003] [description]
   4. [FEAT-004] [description]
   5. [FEAT-005] [description]

   ─────────────────────────────────────────────────
   ```

3. **Ask for confirmation:**
   - "Does this look good? You can always edit features.json manually."
   - Options: "Looks good" / "Add more features" / "Start over"

### Step 6: Suggest Commit

If in a git repo and user approved:

```
★ Ready to Track Features ─────────────────────

features.json created with [N] features.

Suggested commit:
  git add features.json
  git commit -m "feat: Initialize feature tracking with [N] features"

Would you like to commit now?
─────────────────────────────────────────────────
```

Use AskUserQuestion:
- Options: "Yes, commit" / "No, I'll commit later"

If yes, run the git commands.

## Important Guidelines

1. **Don't overwrite** - If features.json exists, ask before replacing
2. **Validate JSON** - Ensure generated file is valid JSON
3. **Date format** - Use YYYY-MM-DD for dates
4. **Be helpful** - If agent fails, provide manual template

## Fallback Template

If agent fails or user wants manual setup, provide this template:

```json
{
  "version": "1.0.0",
  "project": {
    "name": "[project-name]",
    "created": "[today's date]"
  },
  "features": [
    {
      "id": "FEAT-001",
      "category": "functional",
      "description": "[First feature description]",
      "status": "pending",
      "priority": "high",
      "test_command": "",
      "steps": [],
      "passes": false,
      "completed_at": null,
      "notes": ""
    }
  ]
}
```

## Example Flow

```
> /init-features Build a todo app with user accounts

Checking environment...
✓ Git repository detected
✗ No features.json found

Reading project context...
✓ CLAUDE.md found
✓ README.md found
✗ TODO.md not found
✓ package.json found (Node.js project)

Generating features...

★ Features Initialized ────────────────────────

PROJECT: todo-app
FEATURES: 15 total

BY CATEGORY:
- functional: 8
- ui: 4
- api: 2
- infrastructure: 1

FIRST 5 FEATURES:
1. [FEAT-001] User can create account with email
2. [FEAT-002] User can log in with credentials
3. [FEAT-003] User can create a new todo item
4. [FEAT-004] User can mark todo as complete
5. [FEAT-005] User can delete a todo item

─────────────────────────────────────────────────

Does this look good?
[Looks good] [Add more features] [Start over]
```
