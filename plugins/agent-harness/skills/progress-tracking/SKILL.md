# Progress Tracking Skill

Live working scratchpad pattern from [Anthropic's Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices).

> "improve performance by having Claude use a Markdown file as a checklist and working scratchpad"

## When to Use

- Complex tasks with multiple steps
- Long-running work sessions
- Tasks requiring context persistence across iterations
- Migrations, bulk fixes, or multi-file changes

## PROGRESS.md vs Other Files

| File | Purpose | When Updated |
|------|---------|--------------|
| **PROGRESS.md** | Live working scratchpad | DURING work |
| TODO.md | User-facing task list | By user |
| features.json | Structured feature tracking | At milestones |
| session-notes.md | Retrospective summary | At session END |

## PROGRESS.md Format

```markdown
# Progress: [Task Name]

**Started:** YYYY-MM-DD HH:MM
**Status:** 🔄 In Progress | ✅ Complete | ⏸️ Paused

## Current Task
[Clear description of what we're working on]

## Checklist
- [ ] Step 1: [description]
- [ ] Step 2: [description]
- [x] Step 3: [completed item] ✓

## Notes
- [Intermediate findings]
- [Decisions made]
- [Blockers encountered]

## Files Modified
- [file1.ts] - [what changed]
- [file2.ts] - [what changed]
```

## Rules

1. **Create at task START**, not end
2. **Update DURING work**, not after
3. **Use checkbox format** for subtasks (`- [ ]` / `- [x]`)
4. **Note intermediate findings** as you discover them
5. **Track files modified** to help with commits
6. **One PROGRESS.md per project** (not per task)

## Tool Call Examples

### Creating PROGRESS.md

**Tool Call:**
```
Write: PROGRESS.md
content: |
  # Progress: Implement user authentication

  **Started:** 2025-12-08 14:30
  **Status:** 🔄 In Progress

  ## Current Task
  Add JWT-based authentication to the API

  ## Checklist
  - [ ] Create auth middleware
  - [ ] Add login endpoint
  - [ ] Add token refresh endpoint
  - [ ] Write tests

  ## Notes
  [To be filled]

  ## Files Modified
  [To be updated]
```

### Updating Progress (checking off item)

**Edit Call:**
```
Edit: PROGRESS.md
old_string: - [ ] Create auth middleware
new_string: - [x] Create auth middleware ✓
```

### Adding a Note

**Edit Call:**
```
Edit: PROGRESS.md
old_string: ## Notes
[To be filled]
new_string: ## Notes
- Using bcrypt for password hashing (industry standard)
- Token expiry set to 1 hour based on security requirements
```

### Recording Modified File

**Edit Call:**
```
Edit: PROGRESS.md
old_string: ## Files Modified
[To be updated]
new_string: ## Files Modified
- src/middleware/auth.ts - Created JWT verification middleware
```

## Lifecycle

```
/start → Create PROGRESS.md with checklist
    ↓
Work → Update checkboxes, notes, files as you go
    ↓
/end → Archive to session-notes.md or keep for next session
```

## Integration with project-starter

- `/start` creates PROGRESS.md after user selects task (Step 9)
- `/end` offers to archive or keep PROGRESS.md (Step 2.5)
- `/status` could show PROGRESS.md summary (future enhancement)
