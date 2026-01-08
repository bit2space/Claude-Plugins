---
name: feature-tracking
description: Structured feature tracking with features.json for long-running agent tasks. Use when tracking atomic, testable features during development. Implements one-feature-at-a-time workflow with checkpoint commits.
user-invocable: false
allowed-tools:
  - Read
  - Edit
  - Write
  - Glob
---

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

---

## Tool Call Examples

These examples show exact tool invocations for working with features.json.

### Example: Reading Feature Status

**Tool Call:**
```
Read: features.json
```

**Parse Logic (pseudocode):**
```javascript
// Count by status
const features = json.features;
const done = features.filter(f => f.status === "done" && f.passes === true).length;
const inProgress = features.filter(f => f.status === "in-progress").length;
const pending = features.filter(f => f.status === "pending").length;
const failed = features.filter(f => f.status === "failed").length;
const blocked = features.filter(f => f.status === "blocked").length;
const total = features.length;

// Find current work
const current = features.find(f => f.status === "in-progress");
// Output: FEAT-006 "Implement user authentication"
```

### Example: Starting a Feature

**Pre-check:** Ensure no other feature is `in-progress`

**Edit Call:**
```
Edit: features.json
old_string: {"id": "FEAT-003", "status": "pending"
new_string: {"id": "FEAT-003", "status": "in-progress"
```

### Example: Completing a Feature

**Single Edit (include feature ID for safety):**
```
Edit: features.json
old_string: {"id": "FEAT-006", "status": "in-progress", "passes": false
new_string: {"id": "FEAT-006", "status": "done", "passes": true, "completed_at": "2025-12-08"
```

**Why include feature ID:** Generic matches like `"status": "in-progress"` could match the wrong feature if multiple exist in the file.

### Example: Marking Feature as Blocked

**Edit Call (include feature ID):**
```
Edit: features.json
old_string: {"id": "FEAT-006", "status": "in-progress", "passes": false, "notes": ""
new_string: {"id": "FEAT-006", "status": "blocked", "passes": false, "notes": "Waiting for API credentials from client"
```

### Example: Checkpoint Commit Message

When feature marked done with `passes: true`:
```
Suggested commit:
  feat(FEAT-006): Implement user authentication

Include:
- All related code changes
- Updated features.json
- New tests
```

---

## Context Budget Guidelines

### Summarization Rules
- **Display format:** "8/15 done, 1 in-progress" (not full JSON)
- **Current feature:** "[FEAT-006] Implement user authentication"
- **Never dump:** Full features.json to output

### Large features.json Handling
- **> 30 features:** Show counts + current only
- **> 50 features:** Warn about file size, suggest archiving done features

### Output Template
```
FEATURES: [done]/[total] done, [in-progress] in-progress
→ [FEAT-XXX] [current feature description]

Pending: [count] | Blocked: [count] | Failed: [count]
```
