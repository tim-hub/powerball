---
name: writing-checklist
description: Use when a plan needs verification checkpoints to measure whether completed work meets requirements and quality standards. Called by the plan skill — not invoked directly by users.
model: opus
user-invocable: false
context: fork
---

Define verification checkpoints that measure whether the implementation meets requirements, and save to `checklist.md`.

## Input

- The exploration at `.powerball/specs/YYYY-MM-DD-{{name}}/exploration.md`
- The plan at `.powerball/specs/YYYY-MM-DD-{{name}}/plan.md` — read the goal and architecture decisions from here

To find the directory, search `.powerball/specs/` for a directory ending with `-{{name}}`.

**Important:** Do NOT read `tasks.md`. This skill runs in parallel with `writing-tasks` — both read from `exploration.md` and `plan.md` independently. The checklist must think about **observable outcomes**, not mirror implementation steps.

## Process

1. Review the goal, and architecture to identify what "done" looks like.
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
- Checkpoints verify **observable outcomes**, not individual implementation steps — e.g., "clicking the button triggers action X and log Y is visible" rather than "button text changed" + "onClick handler added", or "API returns 200" rather than "API was tested"
- Think about what the **user or system would experience** when the work is complete, not what the developer did
- A single checkpoint can (and should) verify the combined result of multiple implementation steps
- If a checkpoint can't be verified without manual testing, note how to verify it
