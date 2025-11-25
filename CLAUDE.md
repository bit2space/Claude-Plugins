# Claude Plugins Marketplace

**Status**: in-progress
**Last Updated**: 2025-11-25
**Priority**: medium

## Project Goal

Personal Claude Code plugin marketplace for **context teleportation** - fast, reliable way to persist and restore project state between sessions.

## Core Concept

Instead of relying on Claude's memory system, use **file-based state**:
- Load: CLAUDE.md, README.md, TODO.md → structured context
- Save: session notes, TODO updates → `docs/session-notes.md`
- Result: predictable, deterministic session continuity

## Current Plugin: project-starter (v1.2.0)

Three commands for session lifecycle:

| Command | Purpose | Interactive |
|---------|---------|-------------|
| `/project-starter:start` | Load context, choose task | Yes |
| `/project-starter:end` | Save notes, update TODOs | Yes |
| `/project-starter:status` | Quick read-only check | No |

## Development Workflow

```bash
# 1. Edit files in plugins/project-starter/
# 2. Commit changes
git add . && git commit -m "description"
# 3. Update plugin
/plugin update project-starter@kamil-plugins
```

**Key requirement**: Changes must be committed to Git before `/plugin update` reflects them.

## File Structure

```
.claude-plugin/marketplace.json    # Marketplace manifest
plugins/project-starter/
├── .claude-plugin/plugin.json     # Plugin manifest (version here)
├── commands/
│   ├── start.md                   # Full interactive startup
│   ├── end.md                     # Session wrap-up
│   └── status.md                  # Quick status
└── README.md                      # Plugin docs
```

## Conventions

- **Version sync**: Keep version in `marketplace.json` and `plugin.json` aligned
- **Session notes**: Save to `docs/session-notes.md` (not `.claude/`)
- **Templates**: Respect user's Template 1/2/3 structure from global CLAUDE.md
- **Non-destructive**: Always ask before creating/modifying files

## Known Constraints

- Git repository required (Claude Code uses `gitCommitSha` tracking)
- Author field must be object `{name, email}` not string
- Inline bash (`!command`) requires user approval

## Future Ideas

- `/project-starter:quick` - Fast start without questions
- `/project-starter:deep` - Include memory search automatically
- Memory prompt in `/end` - "Save to ~/memories?"
- SessionStart hooks for auto-loading
