---
name: using-git-worktrees
description: Use when starting feature work that needs isolation from current workspace or before executing implementation plans
user-invocable: true
---

Create an isolated git worktree for feature work, with safety verification and clean baseline.

## Step 1: Find or create worktree directory

Priority order:
1. **Existing directory** — check for `.worktrees/` or `worktrees/` in project root. If both exist, `.worktrees/` wins.
2. **CLAUDE.md preference** — check if a worktree directory is specified.
3. **Ask user** — offer `.worktrees/` (project-local, hidden) as default.

## Step 2: Verify .gitignore

For project-local directories, verify the worktree directory is git-ignored:

```bash
git check-ignore -q .worktrees 2>/dev/null
```

**If NOT ignored:** Add to `.gitignore` and commit before proceeding. This prevents worktree contents from polluting git status.

## Step 3: Create worktree

```bash
git worktree add .worktrees/$BRANCH_NAME -b $BRANCH_NAME
cd .worktrees/$BRANCH_NAME
```

Then auto-detect and run project setup (e.g., `npm install`, `pip install`, `go mod download`) based on project files.

## Step 4: Verify clean baseline

Run the project's test suite. If tests fail, report failures and ask whether to proceed or investigate. If tests pass, report ready.

```
Worktree ready at <full-path>
Tests passing (<N> tests, 0 failures)
Ready to implement <feature-name>
```

## Quick Reference

| Situation | Action |
|-----------|--------|
| `.worktrees/` exists | Use it (verify ignored) |
| Neither exists | Check CLAUDE.md → ask user |
| Directory not ignored | Add to .gitignore + commit |
| Tests fail at baseline | Report + ask before proceeding |

## Integration

**Called by:**
- **executing-plan** — use before executing tasks that need workspace isolation
- Any skill needing an isolated workspace

**After work is complete:** Remove the worktree with `git worktree remove .worktrees/$BRANCH_NAME`
