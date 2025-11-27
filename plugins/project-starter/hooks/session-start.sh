#!/bin/bash
# SessionStart hook for project-starter
# Outputs project context to Claude session (only in git repos)

# Guard: Only run in git repositories
if [ ! -d ".git" ]; then
    exit 0
fi

echo "★ Project Context ─────────────────────────────"

# Git info
BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
UNCOMMITTED=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
echo "GIT: $BRANCH | $UNCOMMITTED uncommitted"

# Last 3 commits (short)
echo ""
echo "RECENT:"
git log -3 --format="  %h %s" 2>/dev/null || echo "  (no commits)"

# Features.json stats
if [ -f "features.json" ]; then
    echo ""
    echo "FEATURES:"

    # Count features by status using grep (portable)
    TOTAL=$(grep -c '"id":' features.json 2>/dev/null || echo "0")
    DONE=$(grep -c '"status": "done"' features.json 2>/dev/null || echo "0")
    IN_PROGRESS=$(grep -c '"status": "in-progress"' features.json 2>/dev/null || echo "0")
    PENDING=$(grep -c '"status": "pending"' features.json 2>/dev/null || echo "0")

    echo "  $DONE/$TOTAL done, $IN_PROGRESS in-progress, $PENDING pending"

    # Show current in-progress feature (if any)
    if [ "$IN_PROGRESS" -gt 0 ]; then
        # Extract first in-progress feature ID and description
        # Using awk for portable parsing
        CURRENT=$(awk '
            /"status": "in-progress"/ { found=1 }
            found && /"id":/ { gsub(/[",]/, "", $2); id=$2 }
            found && /"description":/ {
                gsub(/^[^"]*"description": "/, "");
                gsub(/".*$/, "");
                print "→ [" id "] " $0;
                exit
            }
        ' features.json 2>/dev/null)

        if [ -n "$CURRENT" ]; then
            echo "  $CURRENT"
        fi
    fi
fi

# TODO.md stats
TODO_FILE=""
if [ -f "tasks/TODO.md" ]; then
    TODO_FILE="tasks/TODO.md"
elif [ -f "TODO.md" ]; then
    TODO_FILE="TODO.md"
fi

if [ -n "$TODO_FILE" ]; then
    echo ""
    echo "TODOS:"
    TODO_COUNT=$(grep -c '^\s*- \[ \]' "$TODO_FILE" 2>/dev/null || echo "0")
    DONE_COUNT=$(grep -c '^\s*- \[x\]' "$TODO_FILE" 2>/dev/null || echo "0")
    IN_PROGRESS_COUNT=$(grep -c '^\s*- \[-\]' "$TODO_FILE" 2>/dev/null || echo "0")
    echo "  $TODO_COUNT todo, $IN_PROGRESS_COUNT in-progress, $DONE_COUNT done"
fi

echo "─────────────────────────────────────────────────"

exit 0
