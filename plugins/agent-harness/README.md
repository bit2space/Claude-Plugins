# Agent Harness Plugin

Reusable components for building effective agent harnesses, implementing patterns from [Effective Harnesses for Long-Running Agents](https://www.anthropic.com/engineering/claude-code-best-practices).

## Skills

### feature-tracking

Structured feature tracking for long-running agent tasks.

**Key Concepts:**
- `features.json` - Project-level file tracking atomic, testable features
- One feature at a time - complete current before starting next
- Git as external memory - commits = checkpoints
- Never delete features - append-only

**Feature Schema:**
```json
{
  "id": "FEAT-001",
  "category": "functional|ui|api|infrastructure",
  "description": "End-to-end user behavior",
  "status": "pending|in-progress|done|failed|blocked",
  "priority": "high|medium|low",
  "test_command": "npm test -- --grep 'feature'",
  "steps": ["Step 1", "Step 2"],
  "passes": false,
  "completed_at": null,
  "notes": ""
}
```

## Integration

This plugin provides foundational skills used by `project-starter` for:
- Session context (SessionStart hook)
- Feature initialization (`/init-features` command)
- Feature completion tracking (`/end` command)

## Version

1.0.0
