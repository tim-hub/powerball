---
name: writing-tasks
description: Use when a plan needs discrete implementation tasks with step-by-step ordering, file targets, and dependency mapping. Called by the plan skill — not invoked directly by users.
model: opus
user-invocable: false
---

Break an implementation plan into ordered, actionable tasks and save to `tasks.md`.

## Input

- The exploration at `.powerball/specs/YYYY-MM-DD-{{name}}/exploration.md`
- The plan at `.powerball/specs/YYYY-MM-DD-{{name}}/plan.md` — read the goal and architecture decisions from here

To find the directory, search `.powerball/specs/` for a directory ending with `-{{name}}`.

## Process

1. Identify all discrete units of work needed to achieve the plan's goal.
2. Order tasks by dependency — a task should only depend on tasks above it.
3. For each task, specify:
   - **What** to do (clear, imperative description)
   - **Files** to create or modify
   - **Dependencies** — which prior tasks must be complete first
   - **Effort** — S (< 30 min), M (30 min–2 hrs), L (2+ hrs)
4. Group related tasks into phases where it aids clarity.

## Output

1. Read the template from this skill's `templates/tasks.md`
2. Fill in the template — replace `{{NAME}}`, `{{DATE}}`, and all placeholders with actual content
3. Write to `.powerball/specs/YYYY-MM-DD-{{name}}/tasks.md`

## Guidelines

- Tasks should be small enough to complete in one sitting
- Each task should produce a testable or verifiable result
- Avoid vague tasks like "refactor code" — be specific about what changes
- If a task has no file target, it's probably too abstract — split or rephrase
