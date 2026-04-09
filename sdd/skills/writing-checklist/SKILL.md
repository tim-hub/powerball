---
name: writing-checklist
description: Use when a plan needs verification checkpoints to measure whether completed work meets requirements and quality standards. Called by the plan skill — not invoked directly by users.
model: opus
user-invocable: false
context:fork
---

Define verification checkpoints that measure whether the implementation meets requirements, and save to `checklist.md`.

## Input

- The exploration at `.powerball/specs/YYYY-MM-DD-{{name}}/exploration.md`
- The tasks at `.powerball/specs/YYYY-MM-DD-{{name}}/tasks.md`
- The goal and architecture decisions from the plan

## Process

1. Review the goal, tasks, and architecture to identify what "done" looks like.
2. Write checkpoints that are **verifiable** — each should have a clear pass/fail answer.
3. Categorize checkpoints by type:
   - **Functional** — does the feature work as intended?
   - **Quality** — does the code meet standards (tests, types, no warnings)?
   - **Integration** — does it work with existing systems without breaking them?
   - **Security** — are there no exposed secrets, injection risks, or auth gaps?
4. Order from most critical to least critical within each category.

## Output

1. Read the template from this skill's `templates/checklist.md`
2. Fill in the template — replace `{{NAME}}`, `{{DATE}}`, and all placeholders with actual content
3. Write to `.powerball/specs/YYYY-MM-DD-{{name}}/checklist.md`

## Guidelines

- Every checkpoint must be answerable with yes/no — avoid subjective criteria
- Checkpoints verify outcomes, not process ("API returns 200" not "API was tested")
- Include at least one checkpoint per task phase from `tasks.md`
- If a checkpoint can't be verified without manual testing, note how to verify it
