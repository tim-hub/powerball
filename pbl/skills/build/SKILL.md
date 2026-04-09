---
name: build
description: Use when the user asks to "build", "execute a plan", "start implementing", "work through tasks", "run the plan", or wants to implement tasks from a previously created plan in .powerball/specs/.
user-invocable: true
argument-hint: "[plan name — e.g. 'auth-module', or leave blank to pick from existing plans]"
model: sonnet
---

Execute plan by dispatching fresh subagent per independent tasks in isolated worktrees, with two-stage review after each: spec compliance review first, then code quality review and code review step after completion.

## Step 1: Locate the plan

1. If the user provided an argument, search `.powerball/specs/` for a directory whose name ends with `-{{argument}}` (ignoring the date prefix). If multiple matches, list them and ask.
2. If no argument, list directories under `.powerball/specs/` and ask the user which plan to execute.
3. Read the plan's `tasks.md` to get the task list. Also read `plan.md` for architecture context and `checklist.md` for verification criteria.

## Step 2: Execute tasks

For each uncompleted task (where Done is `[ ]`):

1. **Read the task** — understand what needs to be done, which files to touch, and dependencies.
2. **Check dependencies** — all dependent tasks must be marked `[x]` before starting.
3. **Implement** — do the work described in the task.
4. **Verify** — confirm the task produces a working result (build passes, no errors).
5. **Mark done** — update `tasks.md` by changing `[ ]` to `[x]` for this task's Done column.
6. **Report** — briefly tell the user what was completed before moving to the next task.

## Step 3: Verify against checklist

After all tasks are complete, read `checklist.md` and verify each checkpoint:

1. **For each checkpoint**, test whether it passes.
2. **If it passes**, mark it `[x]` in `checklist.md`.
3. **If it fails**:
   - Tell the user which checkpoint failed and why.
   - Identify which task(s) are responsible for this checkpoint.
   - Mark those tasks back to `[ ]` in `tasks.md`.
   - Go back to **Step 2** and re-execute only the undone tasks.
   - After re-execution, return to **Step 3** and re-verify.

This loop continues until all checkpoints pass.

## Step 4: Code review

After all tasks and checklist items pass, dispatch the code-reviewer agent to review all changes made during execution. Pass the plan directory path (`.powerball/specs/YYYY-MM-DD-{{name}}/`) so the reviewer can read `plan.md` and `tasks.md` for context.

1. **Run code review** — the reviewer examines all modified/created files for bugs, security issues, code quality, and adherence to project conventions.
2. **Classify issues**:
   - **Critical** (bugs, security vulnerabilities, data loss risks) — stop and raise to the user. Do not auto-fix. Wait for user guidance.
   - **Minor** (style, naming, small improvements) — add new fix tasks to `tasks.md` with prefix "Review fix:" and mark them `[ ]`. Go back to **Step 2** to execute only the new fix tasks, then re-run **Step 3** and **Step 4**.
3. **No issues** — proceed to Step 5.

This ensures no code ships without review. The loop exits when the reviewer finds no issues or only critical issues awaiting user input.

## Step 5: Report

Tell the user:
- How many tasks were completed (including any that were redone)
- All checklist items now passing
- Code review status (clean, or critical issues pending user input, what minor issues and new fixed tasks were created and fixed)
- What to do next (commit, review critical issues, etc.)

## Rules

- **Never skip tasks** — execute in order within phases, respecting dependencies
- **Stop on failure** — if a task fails, stop and tell the user rather than continuing
- **Parallelize independent tasks** — use worktrees and subagents for tasks with no shared state
- **Sequential for dependent tasks** — tasks with dependencies execute one at a time
- **Update files as you go** — `tasks.md` should reflect progress at all times so the user can resume later
