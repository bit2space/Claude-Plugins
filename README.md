# Kamil's Claude Code Marketplace

Custom Claude Code plugins for project management and workflow automation.

## Installation

```bash
/plugin marketplace add ~/Projects/Claude\ Plugins
```

## Plugins

### project-starter

Tools for starting and managing project sessions.

**Features:**
- Intelligently loads project context (CLAUDE.md, README.md, TODO.md)
- Analyzes project structure and type
- Proposes next steps based on TODO items
- Interactive task selection
- Creates missing project files

**Usage:**
```bash
/plugin install project-starter@kamil-plugins
/project-starter:start
```

## Development

This marketplace is maintained locally with Git version control.

**Structure:**
```
.
├── .claude-plugin/
│   └── marketplace.json    # Marketplace manifest
├── plugins/
│   └── project-starter/    # Plugin directory
├── docs/                    # Documentation and context files
├── .gitignore
└── README.md
```

## Author

Kamil Grabowski
Email: kamil@royalco.io
Company: Royal Company sp. z o.o.
