---
name: sync
description: Use when archiving specs to detect drift between spec artifacts and actual code changes. Called by the lodge skill at Step 0 — not invoked directly by users.
model: sonnet
user-invocable: false
---

Detect drift between spec artifacts (tasks, checklist, plan) and actual code changes before archiving. Surface discrepancies so the user can choose to update specs or revert code.

## Input

- The spec directory at `.powerball/specs/YYYY-MM-DD-{{name}}/`
- Read `plan.md`, `tasks.md`, and `checklist.md` from the directory

## Process

### 1. Gather what specs say should have changed

From `tasks.md`, extract:
- All completed tasks (`[x]`) — what files they claim to have created or modified
- The described behavior of each task

From `plan.md`, extract:
- Architecture decisions and their expected impact on the codebase

From `checklist.md`, extract:
- All passing checkpoints (`[x]`) — what observable outcomes they verify

### 2. Gather what actually changed

Run `git diff` against the branch or commits associated with this spec's work:
- Files added, modified, or deleted
- Summary of changes in each file

If the spec work was done in a worktree that has been merged, diff the merge commit range instead.

### 3. Compare and detect drift

Check for discrepancies in both directions:

**Spec claims work not reflected in code:**
- Task says "modify `src/auth.ts`" but file has no changes
- Checklist says "API returns 200" but no API code was touched
- Plan describes an architecture decision that isn't visible in the diff

**Code changes not captured in specs:**
- Files were modified that no task mentions
- New files created that aren't in any task's file list
- Behavior changes visible in the diff that no checklist item verifies

### 4. Report drift to user

If **no drift** detected, report clean and proceed (return to lodge).

If **drift detected**, present each discrepancy clearly:

```
Drift detected between specs and code:

Specs claim work not in code:
  - Task #3 says "add validation to user.ts" — file unchanged

Code changes not in specs:
  - src/utils/helpers.ts was modified — no task mentions this file
  - New file src/config/defaults.ts created — not in any task

Options:
  1. Update specs to match code (add missing tasks/checkpoints)
  2. Revert code changes that aren't in specs
  3. Lodge anyway (accept drift as-is)
```

Wait for user's choice before proceeding:
- **Option 1**: Edit `tasks.md` and `checklist.md` to reflect actual changes, then return to lodge
- **Option 2**: Identify which changes to revert, confirm with user, then revert and return to lodge
- **Option 3**: Return to lodge without changes
