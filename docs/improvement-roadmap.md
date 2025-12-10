# Plugin Improvement Roadmap
## Based on Anthropic Engineering Blog Analysis

**Date**: 2025-12-10
**Current State**: project-starter v1.4.0, agent-harness v1.0.0
**Alignment**: 80% with Anthropic best practices

---

## Executive Summary

Multi-agent analysis of last 4 Anthropic engineering posts reveals:

1. **Your architecture is fundamentally sound** ✅
2. **Missing 5 key patterns** that would complete the agent harness
3. **High ROI improvements** available in v1.5.0-v1.7.0

**Sources Analyzed**:
- Effective harnesses for long-running agents
- Advanced tool use on Claude platform
- Code execution with MCP
- Claude Code sandboxing

---

## Current Strengths

✅ **Feature Tracking**: features.json schema is **better** than Anthropic's example
✅ **Session Lifecycle**: /start, /end, /status commands
✅ **Working Scratchpad**: PROGRESS.md (not in blog posts!)
✅ **Git Checkpoints**: PostToolUse hook suggests commits
✅ **Security**: Project-scoped, interactive, file-based
✅ **Skills Concept**: Validated by MCP code execution patterns

---

## Missing Patterns (Priority Ordered)

### 1. claude-progress.txt - Chronological Session Log

**Status**: ❌ Not implemented
**From**: Harnesses post
**Impact**: ⭐⭐⭐ High

**Problem**: session-notes.md is retrospective (written at end), not incremental

**Solution**: Append-only log showing project evolution

**Format**:
```
[2025-12-10 14:30] Added authentication
- Completed: FEAT-001
- Modified: 8 files
- Notes: Chose JWT over sessions
- Next: FEAT-002
---
```

**Implementation**:
- Modify `end.md` - add append step
- Modify `session-start.sh` - show last 3 entries

---

### 2. Single Feature Enforcement

**Status**: ⚠️ Documented but not enforced
**From**: Harnesses post
**Impact**: ⭐⭐ Medium

**Problem**: Nothing prevents starting FEAT-002 while FEAT-001 is in-progress

**Solution**: Validation in /start command

**Logic**:
- Check features.json for in-progress features
- If found: offer "Continue" or "Mark blocked" only
- Block "Start new" until current resolved

---

### 3. Test Execution

**Status**: ⚠️ test_command exists but not executed
**From**: Harnesses post
**Impact**: ⭐⭐⭐ High

**Problem**: passes: true is manual assertion, no verification

**Solution**: Actual test running in /end command

**Flow**:
1. User marks feature complete
2. Read feature's test_command
3. Offer: "Run tests?"
4. Execute and capture result
5. Set passes: true only if exit code 0

---

### 4. init.sh Startup Script

**Status**: ❌ Not implemented
**From**: Harnesses post
**Impact**: ⭐ Low-Medium

**Problem**: No standardized "how do I run this project?"

**Solution**: Project-specific startup script

**Benefits**:
- One command starts environment
- Agents know how to run project
- Faster session startup

**Implementation**: New /project-starter:init command

---

### 5. Progressive Context Disclosure

**Status**: ⚠️ Loads everything upfront
**From**: Advanced tool use + MCP posts
**Impact**: ⭐⭐ Medium

**Problem**: SessionStart hook loads full CLAUDE.md, README.md, TODO.md, features.json

**Solution**: Summary first, details on-demand

**Token Savings**: Potentially 50-70% reduction

**Example**:
```bash
# Instead of: cat CLAUDE.md (500 lines)
# Show: echo "Status: in-progress | Last: 2025-12-08"
```

---

## Implementation Plan

### v1.5.0 - Foundations (1 week)

**Goals**: Context continuity + discipline enforcement

1. Add claude-progress.txt logging (Priority 1)
2. Enforce single feature discipline (Priority 2)
3. Add tool call examples to commands (Priority 3)
4. Optimize SessionStart hook for progressive disclosure (Priority 5)

**Effort**: 5-7 hours total
**Impact**: Immediate improvement to session quality

---

### v1.6.0 - Quality Assurance (1 week)

**Goals**: Automated testing integration

1. Add test execution to /end (Priority 3)
2. Validate passes: true requires test success
3. Show test results in final summary
4. Add features.json schema validation

**Effort**: 4-5 hours total
**Impact**: Higher code quality, fewer false completions

---

### v1.7.0 - Initialization (1-2 weeks)

**Goals**: Better new project experience

1. Create /project-starter:init command (Priority 4)
2. Implement init.sh generation for common project types
3. Add init.sh execution offer to /start
4. Template library for different frameworks

**Effort**: 6-8 hours total
**Impact**: Smoother onboarding for new projects

---

## Detailed Specifications

### Spec 1: claude-progress.txt Format

**Location**: Project root
**Type**: Append-only text file
**Entry format**:
```
[YYYY-MM-DD HH:MM] Session title
- Features completed: [FEAT-001], [FEAT-002]
- Features started: [FEAT-003]
- Files modified: [count] files
- Notes: [1-2 sentence summary or key decision]
- Next: [Next task or in-progress feature]
---
```

**Usage**:
- `/end` appends entry
- SessionStart hook shows last 3 entries (12 lines)
- Never deleted, only appended

**Difference from session-notes.md**:
- claude-progress.txt: Chronological log, brief entries
- session-notes.md: Detailed retrospective, archival format

---

### Spec 2: Single Feature Validation

**Location**: plugins/project-starter/commands/start.md
**Step**: Before "Ask What's Next" (Step 7)

**Pseudocode**:
```
Read features.json
in_progress_features = filter(status == "in-progress")

IF count(in_progress_features) > 0:
  feature_id = in_progress_features[0].id
  feature_desc = in_progress_features[0].description

  Display:
    "⚠️ You have {feature_id} already in progress:"
    "  {feature_desc}"
    ""
    "Following best practices, work on ONE feature at a time."

  AskUserQuestion:
    Options:
      1. "Continue {feature_id}" (recommended)
      2. "Mark {feature_id} as blocked/failed"

  IF option 1: Set current_task = feature_id, proceed
  IF option 2: Update feature status, then show new feature selection
ELSE:
  Show normal "What would you like to work on?" options
END
```

---

### Spec 3: Test Execution Flow

**Location**: plugins/project-starter/commands/end.md
**Step**: Within "Update features.json" (Step 3.5)

**Flow**:
```
FOR EACH feature user wants to mark complete:

  Read feature.test_command

  IF test_command exists:
    AskUserQuestion:
      "Run tests for {feature_id}?"
      "Test command: `{test_command}`"
      Options:
        1. "Yes, run tests" (recommended)
        2. "Skip tests"

    IF option 1 (run tests):
      result = Bash(command=test_command, timeout=60000)
      exit_code = result.exit_code

      IF exit_code == 0:
        Display: "✓ Tests passed"
        Update feature:
          status = "done"
          passes = true
          completed_at = current_date
      ELSE:
        Display: "✗ Tests failed (exit code: {exit_code})"
        Keep feature:
          status = "in-progress"
          Add note: "Test failure on {date}: {exit_code}"

    IF option 2 (skip):
      Display: "⚠️ Marking complete without test verification"
      Update feature:
        status = "done"
        passes = false
        Add note: "Completed without running tests"

  ELSE (no test_command):
    Display: "⚠️ No test_command defined for {feature_id}"
    Update feature:
      status = "done"
      passes = false
      Add note: "No tests defined"

END FOR
```

---

### Spec 4: Progressive Disclosure in SessionStart Hook

**Location**: plugins/project-starter/hooks/session-start.sh

**Current** (loads everything):
```bash
cat CLAUDE.md
cat README.md
cat TODO.md
jq '.' features.json
```

**Optimized** (summaries):
```bash
echo "PROJECT: $(head -1 CLAUDE.md | sed 's/# //')"
echo "Status: $(grep '^**Status' CLAUDE.md | sed 's/**//g')"
echo ""
echo "FEATURES:"
jq -r '.features[] | select(.status == "in-progress") | "  🔄 \(.id): \(.description)"' features.json
jq -r '.features[] | select(.status == "pending") | length | "  ⏳ \(.) pending"' features.json
echo ""
echo "TODOS:"
grep -c '- \[ \]' TODO.md | xargs echo "  □ Pending:"
grep -c '- \[-\]' TODO.md | xargs echo "  ▶ In progress:"
echo ""
echo "Run /project-starter:status for details"
```

**Token savings**: ~70% (from ~2000 tokens → ~600 tokens)

---

## Cross-Post Insights

### From MCP Post: Skills Validation

**Key Finding**: MCP's "dynamic skill development" (agents saving reusable code) validates your agent-harness Skills concept.

**Implication**: Filesystem-based skill organization is the right pattern

**Future**: Consider MCP server integration for development tools

---

### From Advanced Tool Use: Context Budget

**Key Finding**: 98.7% token reduction via progressive disclosure (150K → 2K tokens)

**Implication**: Don't load everything upfront

**Application**: SessionStart hook optimization (Spec 4)

---

### From Sandboxing Post: Security Boundaries

**Key Finding**: 84% reduction in permission prompts via proactive containment

**Implication**: Your current security (project-scoped, interactive) is well-aligned

**Recommendation**: Add security manifest to plugin.json for transparency

---

## Success Metrics

### v1.5.0 Success Criteria:
- [ ] claude-progress.txt created on /end
- [ ] SessionStart shows last 3 progress entries
- [ ] /start prevents starting second feature when one in-progress
- [ ] All commands have tool call examples
- [ ] SessionStart hook token usage reduced by 50%+

### v1.6.0 Success Criteria:
- [ ] /end offers to run tests for completed features
- [ ] passes: true only set when tests actually pass
- [ ] Test failures keep feature in-progress
- [ ] features.json schema validated on write

### v1.7.0 Success Criteria:
- [ ] /init command creates init.sh for detected project type
- [ ] init.sh works for Node.js, Python, Go projects
- [ ] /start offers to run init.sh if it exists
- [ ] Documentation includes init.sh patterns

---

## Next Steps

1. **Review this roadmap** - Confirm priorities align with your needs
2. **Start v1.5.0** - Highest ROI, quickest wins
3. **Save full agent analyses** - 4 detailed reports available if needed
4. **Update CLAUDE.md** - Document new patterns as implemented

**Estimated timeline**: v1.5.0 (1 week) → v1.6.0 (2 weeks) → v1.7.0 (3-4 weeks)

---

## References

- [Effective Harnesses for Long-Running Agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- [Advanced Tool Use](https://www.anthropic.com/engineering/advanced-tool-use)
- [Code Execution with MCP](https://www.anthropic.com/engineering/code-execution-with-mcp)
- [Claude Code Sandboxing](https://www.anthropic.com/engineering/claude-code-sandboxing)

**Full agent analyses available in**: Individual agent transcripts (can be saved to docs/ if needed)
