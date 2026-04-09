---
name: plan
description: Use when the user asks to "plan", "create a plan", "design a solution", or wants an implementation plan for a feature, refactor, or change based on prior exploration.
user-invocable: true
argument-hint: "[what to plan — e.g. 'auth module', 'API refactor', or leave blank to pick from existing explorations]"
model: opus
agent: Plan
---

Create an implementation plan informed by a prior exploration, and save it alongside the exploration document.

## Step 1: Derive name and locate exploration

Same naming convention as the explore skill:
1. Parse the user's argument to determine scope and derive a kebab-case **name**.
2. Search `.powerball/specs/` for a directory whose name ends with `-{{name}}` (ignoring the date prefix). If multiple matches, list them and ask.
3. If a matching directory with `exploration.md` is found, read it — this is the context for planning.
4. If not found, invoke the `explore` skill first with the same argument, then read the resulting exploration.
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

## Step 4: Write tasks

Invoke the `writing-tasks` skill to break the plan into ordered, phased tasks with dependencies. This saves `tasks.md` in the same specs directory.

## Step 5: Write checklist

Invoke the `writing-checklist` skill to define verification checkpoints that measure whether the work meets requirements. This saves `checklist.md` in the same specs directory.

## Step 6: Report

Tell the user:
- Summary of the plan (key phases, task count)
- Any decisions or risks that need their input
- Where the artifacts were saved:
  - `plan.md` — goal, architecture, risks
  - `tasks.md` — step-by-step implementation tasks
  - `checklist.md` — verification checkpoints
- **Suggest `/build`** if the plan work is complete, the build skill reads from the same specs directory