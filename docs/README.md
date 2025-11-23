# Documentation - Kamil's Claude Code Marketplace

Technical documentation for the kamil-plugins marketplace.

## Table of Contents

- [Architecture](#architecture)
- [Plugin Development Guide](#plugin-development-guide)
- [Command Format](#command-format)
- [Marketplace Schema](#marketplace-schema)
- [Git Workflow](#git-workflow)
- [Testing](#testing)
- [Migration History](#migration-history)

## Architecture

### Marketplace Structure

The marketplace follows Anthropic's official plugin marketplace specification:

```
kamil-plugins/
├── .git/                           # Git version control (REQUIRED)
├── .claude-plugin/
│   └── marketplace.json            # Marketplace manifest
├── plugins/
│   └── [plugin-name]/
│       ├── .claude-plugin/
│       │   └── plugin.json         # Plugin manifest
│       ├── commands/
│       │   └── [command].md        # Command definitions
│       ├── agents/                 # Optional
│       ├── hooks/                  # Optional
│       └── README.md
├── docs/
└── README.md
```

### Key Requirements

1. **Git Repository:** Claude Code requires Git tracking
   - Uses `gitCommitSha` to track plugin versions
   - Non-Git marketplaces won't load properly
   - Local changes require commit + `/plugin update`

2. **JSON Schema Compliance:**
   - marketplace.json must follow Anthropic schema
   - plugin.json must have correct field types
   - Author must be object: `{name, email}`

3. **File Permissions:**
   - Inline bash execution requires user approval
   - Approval is one-time per pattern
   - Stored in user's Claude Code settings

## Plugin Development Guide

### Creating a New Plugin

#### Step 1: Directory Structure

```bash
cd ~/Projects/Claude\ Plugins
mkdir -p plugins/my-plugin/.claude-plugin
mkdir -p plugins/my-plugin/commands
```

#### Step 2: plugin.json

Create `plugins/my-plugin/.claude-plugin/plugin.json`:

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "Brief description of what the plugin does",
  "author": {
    "name": "Kamil Grabowski",
    "email": "kamil@royalco.io"
  }
}
```

**Field Requirements:**
- `name`: Must match directory name, lowercase, hyphens only
- `version`: Semantic versioning (major.minor.patch)
- `description`: One sentence, < 100 chars
- `author`: MUST be object (not string)

#### Step 3: Command Definition

Create `plugins/my-plugin/commands/do-something.md`:

```markdown
---
description: Brief command description (shown in /help)
allowed-tools: ["Bash", "Read", "Write", "Grep", "AskUserQuestion"]
---

# Command Implementation

Instructions for Claude on how to execute this command.

## Your Task

1. First, do X
2. Then, do Y
3. Finally, present results to user

Use the AskUserQuestion tool for user input.
Handle errors gracefully.
```

**Frontmatter:**
- `description`: Required, shown in `/help`
- `allowed-tools`: Array of tools Claude can use
  - Common: Bash, Read, Write, Edit, Grep, Glob, AskUserQuestion
  - Restrict to minimum needed for security

#### Step 4: Update marketplace.json

Add to `.claude-plugin/marketplace.json` plugins array:

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "Brief description",
  "source": "./plugins/my-plugin",
  "category": "productivity"
}
```

**Categories:** development, productivity, security, learning

#### Step 5: Commit and Install

```bash
git add .
git commit -m "Add my-plugin with /my-plugin:do-something command"
/plugin install my-plugin@kamil-plugins
```

### Updating Existing Plugin

1. **Edit files** in `plugins/[plugin-name]/`
2. **Test changes** by running commands
3. **Commit:**
   ```bash
   git add plugins/[plugin-name]
   git commit -m "Update: description of changes"
   ```
4. **Update in Claude Code:**
   ```bash
   /plugin update plugin-name@kamil-plugins
   ```

**Note:** Changes are NOT reflected until committed to Git

## Command Format

### Markdown Structure

Commands are written in Markdown with YAML frontmatter:

```markdown
---
description: What this command does
allowed-tools: ["Tool1", "Tool2"]
---

# Command Title

## Your Task

Instructions for Claude...

### Step 1: Do something

Detailed instructions...

### Step 2: Do something else

More instructions...
```

### Inline Bash Execution

You can execute bash commands inline in the markdown:

```markdown
**Current directory:** !`pwd`
**Git branch:** !`git branch --show-current`
```

**Format:** `!`command``

**Requirements:**
- User must approve commands with multiple operations (`&&`, `||`)
- Approval is one-time per pattern
- Commands execute before Claude sees the prompt

### Using AskUserQuestion

For interactive input:

```markdown
Use the AskUserQuestion tool to ask:

**Question:** "Which option do you prefer?"
**Options:**
  1. Option A - Description
  2. Option B - Description
  3. Option C - Description

Based on their choice, proceed with...
```

### Best Practices

1. **Be specific:** Tell Claude exactly what to do
2. **Handle errors:** Include error handling instructions
3. **Use tools wisely:** Restrict to minimum needed
4. **Test thoroughly:** Run command multiple times
5. **Document well:** Clear descriptions and examples

## Marketplace Schema

### marketplace.json

```json
{
  "$schema": "https://anthropic.com/claude-code/marketplace.schema.json",
  "name": "marketplace-name",
  "version": "1.0.0",
  "description": "Marketplace description",
  "owner": {
    "name": "Owner Name",
    "email": "email@example.com"
  },
  "plugins": [
    {
      "name": "plugin-name",
      "version": "1.0.0",
      "description": "Plugin description",
      "source": "./plugins/plugin-name",
      "category": "productivity"
    }
  ]
}
```

### plugin.json

```json
{
  "name": "plugin-name",
  "version": "1.0.0",
  "description": "Plugin description",
  "author": {
    "name": "Author Name",
    "email": "email@example.com"
  }
}
```

**Common Errors:**
- ❌ `"author": "Name <email>"` - String not allowed
- ✅ `"author": {"name": "Name", "email": "email"}` - Correct format

## Git Workflow

### Development Cycle

```bash
# 1. Make changes to plugin files
vim plugins/my-plugin/commands/command.md

# 2. Test the command
/my-plugin:command

# 3. Commit changes
git add .
git commit -m "Update: improved error handling"

# 4. Update plugin in Claude Code
/plugin update my-plugin@kamil-plugins

# 5. Test again
/my-plugin:command
```

### Commit Messages

Follow conventional commits:

- `feat: Add new feature`
- `fix: Fix bug in command`
- `docs: Update documentation`
- `refactor: Refactor code structure`
- `test: Add tests`

### Branching (Optional)

For complex changes:

```bash
git checkout -b feature/new-command
# Make changes...
git commit -m "feat: Add new command"
git checkout main
git merge feature/new-command
```

## Testing

### Manual Testing

1. **Install plugin:**
   ```bash
   /plugin install my-plugin@kamil-plugins
   ```

2. **Test command:**
   ```bash
   /my-plugin:command
   ```

3. **Check for errors:**
   - Permission errors
   - Tool usage errors
   - Logic errors

4. **Test edge cases:**
   - Missing files
   - Invalid input
   - Different project types

### Verification Checklist

- [ ] Command appears in `/help`
- [ ] Description is clear and accurate
- [ ] Allowed tools are sufficient
- [ ] Handles missing files gracefully
- [ ] Error messages are helpful
- [ ] Asks for user input when needed
- [ ] Produces expected output
- [ ] No permission errors (or approved)

## Migration History

This marketplace was migrated from `local-plugins` to a proper Git-based structure.

### Key Files

- **migration-todo.md** - Step-by-step migration plan (completed)
- **migration-context.md** - Detailed context and learnings

### Problems Solved

1. **Plugin not loading** - Required Git repository
2. **Manifest validation** - Fixed author field format
3. **Permission errors** - Inline bash requires approval
4. **Old references** - Cleaned up .claude/ configs

### Lessons Learned

1. Git repository is mandatory for marketplaces
2. Schema validation is strict
3. Local development workflow is fast with `/plugin update`
4. Inline bash execution works with user approval
5. gitCommitSha tracking is essential

---

**Last Updated:** 2025-11-23
**Marketplace Version:** 1.0.0
**Status:** Production Ready
