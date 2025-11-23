# Project Starter Plugin

**Version:** 1.0.0
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

### ✅ Current Features (v1.0.0)

- Intelligent project detection and context loading
- Interactive file creation proposals
- Task status tracking and analysis
- Project type detection (Templates 1/2/3)
- Graceful handling of missing files
- Multi-phase interactive workflow
- Git status integration
- Edge case handling (empty projects, wrong directories, etc.)

### 🔮 Future Enhancements

Easily extendable with additional commands:

- `/project-starter:quick` - Fast start without questions
- `/project-starter:deep` - Include memory search and git history
- `/project-starter:end` - End session and save notes
- `/project-starter:status` - Show status without loading full context

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
│   └── start.md             # Main /start command
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

**Last updated:** 2025-11-21
**Plugin location:** `~/.claude/plugins/project-starter/`
