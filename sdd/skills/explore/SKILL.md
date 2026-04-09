---
name: explore
description: Use when the user asks to "explore", "explore the codebase", "map the architecture", "understand the codebase", or wants a structured overview of a project or module saved for future reference.
user-invocable: true
argument-hint: "[what to explore — e.g. 'auth module', 'API layer', or leave blank for full codebase]"
model: haiku
agent: Explore
---

Explore a codebase or module through guided discovery, then save structured findings as a persistent markdown document.

## Step 1: Derive exploration name

Parse the user's argument to determine:
1. **What** to explore (scope — full codebase, a module, a feature, a directory)
2. **Name** — derive a short, kebab-case name from the input (e.g., "auth module" becomes `auth-module`, "API layer" becomes `api-layer`). If no argument, use `full-codebase`.
3. **Directory name** — prefix with today's date: `YYYY-MM-DD-{{name}}/` (e.g., `2026-04-09-auth-module/`).

This name and date prefix are used for the output path and document title throughout.

## Step 2: Understand intent

Before diving into code, clarify what the user actually needs:

1. **Ask the user** what they want to learn — are they onboarding, evaluating a refactor, debugging, planning a feature, or just curious?
2. **Propose 2-3 exploration angles** based on the scope. For example:
   - "I can focus on **architecture** (how modules connect), **patterns** (conventions and idioms), or **dependencies** (what relies on what). Which matters most?"
   - For a single module: "I can go **broad** (overview of all files) or **deep** (trace a specific flow end-to-end)."
3. **Wait for the user's choice** before proceeding. This shapes what to prioritize in Step 3.

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

## Step 4: Present findings and confirm

Before saving, present key findings to the user:

1. **Summarize** the 3-5 most important discoveries.
2. **Flag surprises** — anything that contradicts expectations or seems risky.
3. **Ask if anything is missing** — "Is there anything else you'd like me to dig into before I save this?"

Incorporate any additional findings from the user's feedback.

## Step 5: Save findings

1. Create the output directory: `.powerball/specs/`
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
