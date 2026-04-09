---
name: plan
description: Use when the user asks to "plan", "create a plan", "design a solution", "how should I implement", "design an approach for", "what's the best way to build", "architect a solution", or wants an implementation plan for a feature, refactor, or change. Also use when the user describes a feature or change that would benefit from structured planning before coding.
user-invocable: true
argument-hint: "[what to plan — e.g. 'auth module', 'API refactor', or leave blank to pick from existing explorations]"
model: opus
---

Create an implementation plan informed by a prior exploration, and save it alongside the exploration document.

## Step 1: Derive name and locate exploration

Same naming convention as the explore skill:
1. Parse the user's argument to determine scope and derive a kebab-case **name**.
2. Search `.powerball/specs/` for a directory whose name ends with `-{{name}}` (ignoring the date prefix). If multiple matches, list them and ask.
3. If a matching directory with `exploration.md` is found, read it — this is the context for planning.
4. If not found, use the `Skill` tool to invoke the `explore` skill with the same argument, then read the resulting exploration.
5. If no argument is provided, ask the user to input one.

## Step 2: Plan

Use Plan agent capabilities to design an implementation plan informed by the exploration:
- Define the goal and architectural decisions
- Flag risks, unknowns, or decisions that need user input
- Consider architectural trade-offs

## Step 3: Save plan

1. Read the template from this skill's `templates/plan.md`
2. Fill in the template with findings from Step 2:
   - Replace `{{NAME}}` with the derived name (title case, spaces)
   - Replace `{{DATE}}` with today's date (YYYY-MM-DD)
   - Fill all sections with actual plan content — remove placeholder text
   - Delete sections that don't apply
3. Write the filled template to `.powerball/specs/YYYY-MM-DD-{{name}}/plan.md`

## Step 4: Write tasks and checklist in parallel

Use the `Skill` tool to invoke **both** skills concurrently as parallel agents:
- **`writing-tasks`** — breaks the plan into ordered, phased tasks with dependencies. Saves `tasks.md`.
- **`writing-checklist`** — defines verification checkpoints. Saves `checklist.md`.

Both skills read from the same inputs (`exploration.md` and `plan.md`) but must NOT read each other's output. This is intentional: tasks describe **what to do** (implementation steps), while the checklist describes **what to verify** (observable outcomes). Running them in parallel prevents the checklist from mirroring tasks 1:1 and instead forces outcome-oriented thinking.

For example, if the tasks are "change button text to X" and "add onClick handler to button", the checklist should NOT be "button text is X" + "onClick handler exists." It should be "clicking the button triggers action Y and log Z is visible" — verifying the combined outcome.

## Step 5: Cross-validate tasks and checklist

After both artifacts are written, do a quick cross-validation:
- Every checklist item should be achievable by the tasks in `tasks.md` — if a checklist item has no supporting tasks, add the missing task(s).
- Every task phase should have at least one checklist item that verifies its outcome — if a phase has no coverage, add a checkpoint.
- Fix any gaps by editing the relevant file directly. Do not re-invoke the writing skills.

## Step 6: Report

Tell the user:
- Summary of the plan (key phases, task count)
- Any decisions or risks that need their input
- Where the artifacts were saved:
  - `plan.md` — goal, architecture, risks
  - `tasks.md` — step-by-step implementation tasks
  - `checklist.md` — verification checkpoints
- **Suggest `/build`** if the plan work is complete, the build skill reads from the same specs directory