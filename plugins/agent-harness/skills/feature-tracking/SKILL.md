# Feature Tracking Skill

This skill provides structured feature tracking for long-running agent tasks, implementing patterns from "Effective Harnesses for Long-Running Agents".

## Core Concepts

### features.json
A project-level file that tracks atomic, testable features. Each feature represents an end-to-end user behavior.

**Location:** Project root (e.g., `./features.json`)

### Feature Structure
```json
{
  "id": "FEAT-001",
  "category": "functional|ui|api|infrastructure",
  "description": "End-to-end user behavior description",
  "status": "pending|in-progress|done|failed|blocked",
  "priority": "high|medium|low",
  "test_command": "npm test -- --grep 'feature'",
  "steps": ["Step 1", "Step 2"],
  "passes": false,
  "completed_at": null,
  "notes": ""
}
```

## Rules

### ONE Feature at a Time
- Only ONE feature should be `in-progress` at any time
- Complete current feature before starting next
- Mark feature as `done` only after tests pass

### Feature IDs
- Use format: `FEAT-XXX` (e.g., FEAT-001, FEAT-002)
- IDs are immutable - never reuse or change
- Sequential numbering within project

### Status Flow
```
pending → in-progress → done
                     → failed (can retry)
                     → blocked (needs external input)
```

### Never Delete Features
- Features are append-only
- If a feature is no longer needed, mark status as `done` with note explaining why
- Preserve history for project understanding

### Test Before Done
- Never mark `passes: true` without running actual tests
- If no test exists, create one first
- `passes: true` triggers checkpoint suggestion

## Reading features.json

When reading a project with features.json:

1. **Count by status:**
   - Total features
   - Done (with passes: true)
   - In-progress
   - Pending
   - Failed/Blocked

2. **Identify current work:**
   - Find feature with `status: "in-progress"`
   - Show its description and steps

3. **Show progress:**
   ```
   FEATURES: 5/12 done, 1 in-progress
   → [FEAT-006] Implement user authentication
   ```

## Updating features.json

### Starting Work
```json
{
  "id": "FEAT-006",
  "status": "in-progress",  // Changed from "pending"
  "passes": false
}
```

### Completing Work
```json
{
  "id": "FEAT-006",
  "status": "done",
  "passes": true,           // Only if tests verified
  "completed_at": "2025-11-27"
}
```

### Marking Blocked
```json
{
  "id": "FEAT-006",
  "status": "blocked",
  "notes": "Waiting for API credentials from client"
}
```

## Checkpoint Commits

When a feature is marked `done` with `passes: true`:

1. **Suggest** (don't auto-commit) a checkpoint:
   ```
   feat(FEAT-006): Implement user authentication
   ```

2. **Ask user** if they want to commit now

3. **Include in commit:**
   - All related code changes
   - Updated features.json
   - Any new tests

## Schema Validation

Use the JSON schema at `schema/features.schema.json` to validate features.json structure.

## Integration with project-starter

This skill integrates with `/start`, `/end`, `/status` commands:
- `/start` - Shows feature progress and current work
- `/end` - Asks which features were completed
- `/status` - Quick feature stats
