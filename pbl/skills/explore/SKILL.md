---
name: explore
description: Use when the user asks to "explore", "explore the codebase", "map the architecture", "understand the codebase", "what does this module do", "give me an overview of", "analyze how X works", "walk me through", "how is this project structured", or wants a structured overview of a project or module saved for future reference. Also use when the user seems unfamiliar with a codebase area and would benefit from a saved exploration before planning or building.
user-invocable: true
argument-hint: "[what to explore — e.g. 'auth module', 'API layer', or leave blank for full codebase]"
model: sonnet
---

Explore a codebase or module through guided discovery, then save structured findings as a persistent markdown document.

## Step 0: Check prior work

Before starting, check both directories for existing work on the same topic:

1. Scan `.powerball/specs/` for directories whose name matches or overlaps with the requested scope. If a recent exploration already exists for the same topic, tell the user and ask whether to reuse it, update it, or start fresh.
2. Scan `.powerball/lodge/` for archived explorations, plans and decisions on the same topic.

If neither directory exists or both are empty, proceed directly.

Never update or overwrite existing documents in `.powerball/lodge/` — these are immutable records of past work. Always create new documents in `.powerball/specs/` for current work. If prior work overlaps with the requested scope, reference it during the exploration in the following steps.

## Step 1: Derive exploration name

Parse the user's argument to determine:
1. **What** to explore (scope — full codebase, a module, a feature, a directory)
2. **Name** — derive a short, kebab-case name from the input (e.g., "auth module" becomes `auth-module`, "API layer" becomes `api-layer`). If no argument, use `full-codebase`.
3. **Directory name** — prefix with today's date: `YYYY-MM-DD-{{name}}/` (e.g., `2026-04-09-auth-module/`).

This name and date prefix are used for the output path and document title throughout.

## Step 2: Understand intent

Before diving into code, determine what the user needs:

1. **Check the argument for explicit intent** — if the user's argument already states a clear goal (e.g., "audit all skills", "find performance bottlenecks", "understand how auth works"), treat that as the chosen angle and proceed directly to Step 3. No need to ask.
2. **If intent is vague or absent**, clarify before proceeding:
   - Ask the user what they want to learn — are they onboarding, evaluating a refactor, debugging, planning a feature, or just curious?
   - Propose 2-3 exploration angles based on the scope. For example:
     - "I can focus on **architecture** (how modules connect), **patterns** (conventions and idioms), or **dependencies** (what relies on what). Which matters most?"
     - For a single module: "I can go **broad** (overview of all files) or **deep** (trace a specific flow end-to-end)."
   - Wait for the user's choice before proceeding. This shapes what to prioritize in Step 3.

## Step 3: Explore

Use the Explore agent capabilities to analyze the target scope, prioritizing what the user chose in Step 2:

- Directory structure and file organization
- Key components, entry points, and their purposes
- Architecture — how modules connect, data flows, layer boundaries
- Patterns and conventions — naming, design patterns, code organization
- Dependencies — external packages and internal module relationships
- Anything surprising, undocumented, or noteworthy

Adjust depth based on scope size — a single module needs thorough analysis, a full codebase needs breadth.

**For large codebases**: Decompose into subsystems first. Present the high-level map and ask the user which areas to explore deeper before detailing everything.

## Step 4: Present findings

Present key findings to the user:

1. **Summarize** the 3-5 most important discoveries.
2. **Flag surprises** — anything that contradicts expectations or seems risky.
3. **If intent was vague in Step 2** (user chose from proposed angles), ask: "Is there anything else you'd like me to dig into before I save this?" and incorporate feedback.
4. **If intent was explicit in Step 2**, proceed directly to Step 5 — no confirmation needed.

## Step 5: Save findings

1. Create the output directory: `.powerball/specs/` if it doesn't exist.
2. Read the template from this skill's `templates/exploration.md`
3. Fill in the template with findings from Step 3-4:
   - Replace `{{NAME}}` with the derived name (title case, spaces)
   - Replace `{{DATE}}` with today's date (YYYY-MM-DD)
   - Fill all sections with actual findings — remove placeholder text
   - Delete sections that don't apply (e.g., no external deps for a pure utility module)
4. Write the filled template to `.powerball/specs/YYYY-MM-DD-{{name}}/exploration.md`

## Step 6: Next step

Tell the user:
- What was explored and key findings (2-3 bullet summary)
- Where the full exploration was saved
- **Suggest `/plan`** if the exploration reveals work to be done — the plan skill reads from the same specs directory
