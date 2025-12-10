# Anthropic Engineering Blog Analysis
## Plugin Improvement Recommendations

**Date**: 2025-12-10
**Sources**: Last 4 Anthropic engineering blog posts
**Method**: Multi-agent parallel analysis

---

## Executive Summary

Analysis of Anthropic's recent engineering posts reveals **your plugin architecture is 80% aligned** with their best practices. Key gaps identified:

1. **Missing claude-progress.txt** - Chronological session log (harnesses post)
2. **No init.sh pattern** - Project startup script (harnesses post)
3. **Context budget optimization** - Progressive disclosure vs upfront loading (advanced tool use)
4. **Test execution missing** - test_command exists but not executed (harnesses post)
5. **Single feature not enforced** - Documented but no validation (harnesses post)

**Impact potential**: High - these additions would complete the agent harness pattern and improve session continuity.

---

## Analysis Summary by Post

### 1. Effective Harnesses for Long-Running Agents

**Key Pattern**: Two-phase architecture (initializer → coding agent) with comprehensive checkpoint system.

**Your Current State**: ✅ 8/10 - Strong foundation, missing some patterns

**Critical Gaps**:
- No `claude-progress.txt` chronological log (you have session-notes.md but it's retrospective)
- No `init.sh` startup script pattern
- Single feature discipline documented but not enforced
- Test execution planned but not implemented

**Quote**: *"It is unacceptable to remove or edit tests because this could lead to missing or buggy functionality."*

**Your Strength**: features.json schema is **better** than blog example (includes status, priority, test_command, notes, completion dates)

---

### 2. Advanced Tool Use on Claude Platform

**Key Pattern**: Tool call examples, context budget management, programmatic orchestration.

**Impact Metrics**:
- Tool Search Tool: 85% token reduction, 49% → 74% accuracy
- Tool Use Examples: 72% → 90% accuracy on complex parameters
- Programmatic calling: 37% token reduction, fewer orchestration errors

**Critical Insights**:
- **Examples in prompts**: Show minimal/partial/full usage variants with realistic data
- **Context budget**: Progressive disclosure (summary → details on-demand) vs upfront loading
- **Validation**: Common failures are wrong tool selection and incorrect parameters

**Application to Plugins**:
- Add tool call examples to all commands
- Optimize SessionStart hook to provide summaries instead of full file contents
- Use code execution for complex workflows (feature migration, bulk updates)

---

### 3. Code Execution with MCP

**Key Pattern**: Filesystem-based tool discovery + code execution = 98.7% token reduction.

**Revolutionary Insight**: Instead of loading all tool definitions upfront, present tools as files in a filesystem that agents explore progressively.

**Before**: 150,000 tokens (all tool definitions loaded)
**After**: 2,000 tokens (on-demand discovery)
**Savings**: 98.7%

**Skills Validation**: MCP's "dynamic skill development" (agents saving reusable code) **validates your agent-harness Skills concept**. This is a core Anthropic pattern.

**Security**: Privacy-preserving workflows where sensitive data stays in execution environment, never entering LLM context.

**Application to Plugins**:
- Progressive disclosure in project-starter (summary vs deep mode)
- Filesystem-based skill organization (already doing this!)
- Consider MCP server integration for development tools

---

### 4. Claude Code Sandboxing

**Key Pattern**: Proactive containment > reactive approval. Define boundaries once, operate freely within them.

**Security Metric**: 84% reduction in permission prompts while maintaining safety.

**Two-Layer Defense**:
1. Filesystem isolation (working directory scope)
2. Network isolation (domain approval via proxy)

**Critical for Plugins**: Single-layer insufficient—need both filesystem AND network boundaries.

**Your Current Security Posture**: ✅ Well-aligned
- File-based state ✓
- Interactive commands ✓
- Project-scoped operations ✓
- Git audit trail ✓

**Recommendations**:
- Document SessionStart hook approval requirements
- Add explicit security boundaries to agent prompts
- Consider security manifest in plugin.json

---

## Unified Recommendations

### Priority 1: Add claude-progress.txt (v1.5.0)

**What**: Append-only chronological session log

**Why**: Provides evolution of project (journey vs endpoints), enables better context continuity

**Implementation**:

**File**: `plugins/project-starter/commands/end.md`

Add after PROGRESS.md step:

```markdown
### Step 4.5: Append to claude-progress.txt

Create or append to project-root `claude-progress.txt`:

**Format:**
```
[YYYY-MM-DD HH:MM] Session summary
- Features completed: [FEAT-XXX], [FEAT-YYY]
- Files modified: [count] files
- Notes: [Brief user notes or key decisions]
- Next: [Next in-progress feature or task]
---
```

**Why**: Chronological progress log across sessions (complements PROGRESS.md which is task-specific working scratchpad).

**Append-only**: Never delete entries, only add new ones.
```

**SessionStart Hook Update**:
```bash
# Show recent progress
if [ -f claude-progress.txt ]; then
  echo "RECENT PROGRESS:"
  tail -n 15 claude-progress.txt | head -n 12  # Last 3 entries
fi
```

**Effort**: 1-2 hours
**Impact**: High - immediate improvement to session continuity

---

### Priority 2: Enforce Single Feature Discipline (v1.5.0)

**What**: Validation preventing starting second feature when one is in-progress

**Why**: Prevents scope creep, follows Anthropic best practice

**Implementation**:

**File**: `plugins/project-starter/commands/start.md`

Update Step 7 (Ask What's Next):

```markdown
**Before showing options, check in-progress features:**

1. Read features.json
2. Count features with `status: "in-progress"`
3. If count > 0:
   ```
   ⚠️ You have FEAT-XXX already in progress.

   Following best practices for long-running agents, work on ONE feature at a time.

   Options:
   1. "Continue FEAT-XXX" - Resume current feature (recommended)
   2. "Mark FEAT-XXX blocked/failed" - Resolve current before starting new
   ```
4. Only show "Start new feature" option if no in-progress features exist
```

**Effort**: 1 hour
**Impact**: Medium - prevents anti-pattern

---

### Priority 3: Add Test Execution (v1.6.0)

**What**: Actually run tests when marking features complete

**Why**: Quality assurance, prevents false completion

**Implementation**:

**File**: `plugins/project-starter/commands/end.md`

Update Step 3.5:

```markdown
3. **If user selects features to complete:**

   FOR EACH selected feature:

   a. **Read test_command from feature**

   b. **Offer to run tests:**
      ```
      AskUserQuestion:
      Question: "Run tests for FEAT-XXX?"
      Description: "Feature has test_command: `[command]`"
      Options:
      1. "Yes, run tests" - Execute and verify
      2. "Skip tests" - Mark without verification (not recommended)
      ```

   c. **If user chooses run tests:**
      - Execute: `Bash -c "[test_command]"`
      - Capture exit code
      - If exit code 0: "✓ Tests passed"
      - If exit code ≠ 0: "✗ Tests failed"

   d. **Based on test results:**
      - Tests passed: Mark `status: "done"`, `passes: true`
      - Tests failed: Keep `status: "in-progress"`, add failure notes
      - Tests skipped: Mark `status: "done"`, `passes: false`, note "tests not run"
```

**Effort**: 2-3 hours
**Impact**: High - quality assurance

---

### Priority 4: Add Tool Call Examples (v1.5.0)

**What**: Concrete examples in command prompts showing expected tool usage

**Why**: 72% → 90% accuracy improvement on complex parameters

**Implementation**:

Add to **all command files** (start.md, end.md, status.md, init-features.md):

```markdown
## Tool Call Examples

### Example 1: Read TODO.md
<invoke name="Read">
<parameter name="file_path">/path/to/project/TODO.md