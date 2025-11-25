# Project Starter Plugin

**Version:** 1.2.0
**Author:** Kamil Grabowski

Tools for starting and managing project sessions - intelligently loads project context, analyzes TODOs, proposes next steps.

## Overview

The `project-starter` plugin helps you quickly get oriented and start working on any project by:
- Loading project context (CLAUDE.md, README.md, TODO.md)
- Analyzing project structure and detecting project type
- Showing task status (TODO/IN-PROGRESS/DONE)
- Proposing next steps interactively
- Handling missing files gracefully

## Installation

This plugin is installed locally in `~/.claude/plugins/project-starter/`.

To use in other projects or share with team, add to `.claude/settings.json`:

```json
{
  "plugins": {
    "local": ["~/.claude/plugins/project-starter"]
  }
}
```

## Commands

### `/project-starter:start`

**Description:** Start project session - load context, show status, choose task

**Usage:**
```bash
/project-starter:start
```

**What it does:**

1. **Gathers environment context** (auto-executed inline bash):
   - Current directory and git status
   - Checks for CLAUDE.md, README.md, TODO.md existence

2. **Verifies location**:
   - Detects if you're in a project directory
   - If in ~/Projects/ root, asks which project to start
   - If elsewhere, confirms location

3. **Loads project context**:
   - Reads CLAUDE.md (project rules and goals)
   - Reads README.md (project overview)
   - Reads tasks/TODO.md or TODO.md (task tracking)
   - Analyzes project structure (finds key directories)

4. **Detects project type** based on structure:
   - **Template 1** (Documentation/Analysis): `docs/`, `reference/`, `tasks/`, `archive/`
   - **Template 2** (Development): `src/`, `tests/`, `docs/`
   - **Template 3** (Research): `research/`, `experiments/`

5. **Presents comprehensive summary**:
   - Project name and location
   - Git status (branch, uncommitted changes)
   - Loaded files and their key info
   - Task breakdown (X TODO, Y IN-PROGRESS, Z DONE)
   - Project structure

6. **Handles missing files** (interactive):
   - Proposes creating CLAUDE.md with template selection
   - Proposes creating README.md
   - Proposes creating tasks/TODO.md
   - Waits for user confirmation before creating anything

7. **Offers additional context**:
   - Suggests searching ~/memories for relevant context
   - Offers to review git history

8. **Asks what to work on next** (interactive):
   - Continue in-progress task
   - Start new task from TODO list
   - Review documentation
   - Explore codebase
   - Set up project structure
   - Custom action

9. **Executes user's choice**:
   - Loads relevant context for selected task
   - Provides next steps
   - Offers to create session todos

### `/project-starter:end`

**Description:** End project session - save notes, update TODOs, prepare for next time

**Usage:**
```bash
/project-starter:end
```

**What it does:**

1. **Analyzes session activity**:
   - Checks git diff for modified files
   - Shows summary of changes (insertions/deletions)
   - Identifies uncommitted changes

2. **Presents session summary**:
   - Lists files changed during session
   - Shows current TODO.md status
   - Displays git statistics

3. **Updates TODO.md** (interactive):
   - Asks which tasks were completed
   - Moves completed tasks from TODO/IN-PROGRESS to DONE section
   - Adds completion dates to finished tasks
   - Optionally adds notes to in-progress tasks

4. **Saves session notes** (interactive):
   - Creates/updates `docs/session-notes.md`
   - Captures what was accomplished
   - Records blockers and issues
   - Documents next steps for future session

5. **Suggests next session start**:
   - Recommends which task to start with next time
   - Based on IN-PROGRESS and TODO tasks

6. **Shows final summary**:
   - What was saved (TODO updates, session notes)
   - Current task counts
   - Next suggested action
   - Git status reminder

**Example workflow:**
```
★ Session Summary ─────────────────────────────
PROJECT: marketplace-platform

SESSION ACTIVITY:
- Modified files: 5 files
- Git changes: 127 insertions(+), 43 deletions(-)

FILES CHANGED:
- src/auth/middleware.ts
- src/api/payments.ts
- tests/auth.test.ts

Which tasks did you complete? [Interactive selection...]

✓ Updated TODO.md: moved 2 tasks to DONE
✓ Session notes saved to docs/session-notes.md

NEXT SESSION:
→ Continue with: Write API documentation
─────────────────────────────────────────────────
```

## Example Output

```
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

You have 2 tasks in progress:
1. Implement Stripe payment integration
2. Write API documentation for payment endpoints

What would you like to work on today?
[Interactive question with options...]
```

## Features

### ✅ Current Features

**v1.2.0:**
- Quick status command (`/project-starter:status`) - read-only, no prompts
- Session notes moved to `docs/session-notes.md`

**v1.1.0:**
- Session end workflow with TODO.md auto-update
- Session notes saving for continuity between sessions
- Git activity analysis and summary
- Next session task suggestions

**v1.0.0:**
- Intelligent project detection and context loading
- Interactive file creation proposals
- Task status tracking and analysis
- Project type detection (Templates 1/2/3)
- Graceful handling of missing files
- Multi-phase interactive workflow
- Git status integration
- Edge case handling (empty projects, wrong directories, etc.)

### `/project-starter:status`

**Description:** Show project status - quick overview without full startup flow

**Usage:**
```bash
/project-starter:status
```

**What it does:**

1. **Gathers info in parallel** (fast, no prompts):
   - Git branch and uncommitted changes count
   - Last commit hash and message
   - TODO/IN-PROGRESS/DONE task counts

2. **Shows compact status**:
   - Project name and git state
   - Task breakdown with in-progress highlighted
   - File existence indicators (CLAUDE.md, README.md, TODO.md, session-notes.md)

3. **Lists current work**:
   - Shows IN-PROGRESS tasks if any exist

**Key difference from `/start`**: Read-only, no questions, single-screen output. Use when you just want to check status without starting a full session.

**Example output:**
```
★ Project Status ─────────────────────────────────
PROJECT: marketplace-platform
BRANCH: feature/payments | 3 uncommitted changes
LAST COMMIT: a1b2c3d Add payment validation

TASKS:
→ IN-PROGRESS: 2 tasks
  TODO: 5 tasks | DONE: 12 tasks

FILES:
✓ CLAUDE.md  ✓ README.md  ✓ TODO.md  ✗ session-notes.md

CURRENT WORK:
1. Implement Stripe payment integration
2. Write API documentation
─────────────────────────────────────────────────────
```

### 🔮 Future Enhancements

Easily extendable with additional commands:

- `/project-starter:quick` - Fast start without questions
- `/project-starter:deep` - Include memory search and git history automatically

Additional features:

- SessionStart hooks for automatic context loading
- Shared state between commands
- Session time tracking
- Automatic memory creation for important decisions

## Project Structure

```
project-starter/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── commands/
│   ├── start.md             # /start - full interactive session startup
│   ├── end.md               # /end - session wrap-up and notes
│   └── status.md            # /status - quick read-only status
└── README.md                # This file
```

## Configuration

The command uses these tools (configured in frontmatter):
- `Bash` - For environment checks and git status
- `Read` - For reading project files
- `Glob` - For discovering project structure
- `Grep` - For searching file contents
- `AskUserQuestion` - For interactive decision making

## User's Project Templates

This plugin is designed to work with three project templates:

**Template 1: Documentation/Analysis**
- Structure: `docs/`, `reference/`, `tasks/`, `archive/`
- Use case: Contracts, strategies, business analysis

**Template 2: Development**
- Structure: `src/`, `tests/`, `docs/`, `.github/`
- Use case: Software projects, coding

**Template 3: Research**
- Structure: `research/`, `experiments/`
- Use case: Exploration, learning, POCs

## Guidelines

- **Non-destructive**: Never creates files without confirmation
- **Sequential questions**: Asks one question at a time
- **Graceful degradation**: Works with missing files
- **Respects structure**: Follows user's template conventions
- **Real data**: Uses actual project data, not placeholders

## Contributing

To modify or extend this plugin:

1. Edit command files in `commands/`
2. Update version in `.claude-plugin/plugin.json`
3. Test with `/project-starter:start`
4. Update this README with changes

## License

Private plugin for personal/team use.

## Support

For issues or questions, contact: kamil@royalco.io

---

**Last updated:** 2025-11-25
**Plugin location:** `~/Projects/Claude Plugins/plugins/project-starter/`
