# Kamil's Claude Code Marketplace

Custom Claude Code plugins for project management and workflow automation.

## Quick Start

### 1. Add Marketplace

```bash
/plugin marketplace add ~/Projects/Claude\ Plugins
```

### 2. Install Plugins

```bash
/plugin install project-starter@kamil-plugins
```

### 3. Use Plugin

```bash
/project-starter:start
```

## Available Plugins

### project-starter

Context teleportation between sessions - fast, reliable project state loading and saving.

**Commands:**
- `/project-starter:start` - Start interactive session (load context, choose task)
- `/project-starter:end` - End session (update TODOs, save notes)
- `/project-starter:status` - Quick read-only status check

**Features:**
- Loads project context (CLAUDE.md, README.md, TODO.md)
- Detects project type (Templates 1/2/3)
- Tracks tasks (TODO/IN-PROGRESS/DONE)
- Saves session notes to `docs/session-notes.md`
- Suggests next task for session continuity

**Allowed Tools:** Bash, Read, Write, Edit, Glob, Grep, AskUserQuestion

**Use Cases:**
- Starting/ending work sessions with state persistence
- Quick project status checks
- Task tracking across sessions

## Development

### Local Development Workflow

This marketplace uses Git version control for plugin development:

1. **Edit plugin files** in `plugins/[plugin-name]/`
2. **Test changes** by running the plugin command
3. **Commit changes:**
   ```bash
   cd ~/Projects/Claude\ Plugins
   git add .
   git commit -m "Description of changes"
   ```
4. **Update plugin in Claude Code:**
   ```bash
   /plugin update project-starter@kamil-plugins
   ```

### Adding New Plugin

1. **Create plugin directory:**
   ```bash
   mkdir -p plugins/my-new-plugin/.claude-plugin
   mkdir -p plugins/my-new-plugin/commands
   ```

2. **Create plugin.json:**
   ```json
   {
     "name": "my-new-plugin",
     "version": "1.0.0",
     "description": "Brief description",
     "author": {
       "name": "Kamil Grabowski",
       "email": "kamil@royalco.io"
     }
   }
   ```

3. **Add command** in `plugins/my-new-plugin/commands/command-name.md`:
   ```markdown
   ---
   description: Command description
   allowed-tools: ["Bash", "Read", "Write"]
   ---

   # Command Instructions

   Your prompt for Claude...
   ```

4. **Update marketplace.json:**
   Add entry to `plugins` array in `.claude-plugin/marketplace.json`

5. **Commit and install:**
   ```bash
   git add .
   git commit -m "Add my-new-plugin"
   /plugin install my-new-plugin@kamil-plugins
   ```

### Plugin Structure

```
plugins/[plugin-name]/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── commands/
│   ├── command1.md          # Slash command definitions
│   └── command2.md
├── agents/                  # Optional: Custom agents
├── hooks/                   # Optional: Lifecycle hooks
└── README.md                # Plugin documentation
```

### Best Practices

- Use semantic versioning in plugin.json
- Keep commands focused and single-purpose
- Document allowed-tools accurately
- Test plugins before committing
- Write clear command descriptions
- Use AskUserQuestion for user input
- Handle missing files gracefully

## Marketplace Structure

```
/Users/kamil/Projects/Claude Plugins/
├── .git/                    # Git version control
├── .claude-plugin/
│   └── marketplace.json     # Marketplace manifest
├── plugins/
│   └── project-starter/
│       ├── .claude-plugin/
│       │   └── plugin.json
│       ├── commands/
│       │   ├── start.md
│       │   ├── end.md
│       │   └── status.md
│       └── README.md
├── docs/                    # Documentation
│   ├── migration-context.md
│   ├── migration-todo.md
│   └── README.md
├── .gitignore
└── README.md                # This file
```

## Troubleshooting

### Plugin not loading

1. Check plugin is enabled: `/doctor`
2. Verify Git commit exists: `git log`
3. Update plugin: `/plugin update plugin-name@kamil-plugins`
4. Restart Claude Code

### Permission errors

Approve Bash commands when prompted. Inline bash execution (`!`command``) requires one-time approval.

### Changes not reflected

Always commit changes to Git before updating:
```bash
git add .
git commit -m "Update description"
/plugin update plugin-name@kamil-plugins
```

## Resources

- [Claude Code Plugin Documentation](https://code.claude.com/docs/en/plugins)
- [Plugin Marketplaces Guide](https://code.claude.com/docs/en/plugin-marketplaces)
- [Anthropic Plugin Schema](https://anthropic.com/claude-code/marketplace.schema.json)

## Author

**Kamil Grabowski**
Email: kamil@royalco.io
Company: Royal Company sp. z o.o.

## License

Personal use. Not for distribution.
