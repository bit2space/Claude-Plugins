# Agent Harness Plugin

**Version:** 1.1.0
**License:** MIT

Reusable components for building effective agent harnesses, implementing patterns from [Effective Harnesses for Long-Running Agents](https://www.anthropic.com/engineering/claude-code-best-practices).

> Updated to [Agent Skills](https://agentskills.io) open standard with proper SKILL.md frontmatter.

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

### progress-tracking

Live working scratchpad pattern using PROGRESS.md for complex multi-step tasks.

**Key Concepts:**
- PROGRESS.md - Live scratchpad updated DURING work
- Checklist format with `- [ ]` / `- [x]` syntax
- Track intermediate findings, decisions, and files modified
- One per project, not per task

## Agent Skills Standard

Skills in this plugin follow the [Agent Skills](https://agentskills.io) open standard:
- Proper SKILL.md frontmatter with `name` and `description`
- YAML-style `allowed-tools` lists
- `user-invocable: false` for auto-loaded skills

## Version History

### 1.1.0 (2026-01-08)
- Updated to Agent Skills standard
- Added proper SKILL.md frontmatter
- Converted to YAML-style allowed-tools
- Added progress-tracking skill documentation

### 1.0.0
- Initial release with feature-tracking skill
