---
name: harness-implement
description: Use when the user asks to "implement end to end", "build this feature from scratch", "harness implement", "full pipeline", "do everything", "explore plan build and PR", or gives a feature description and expects the entire pbl pipeline to run autonomously — from exploration through to a reviewed pull request. Use this even when the user describes a feature and says "just do it" or "handle it". This is the hands-off, full-auto version of the pbl workflow.
user-invocable: true
argument-hint: "<what to implement — e.g. 'add user auth with JWT', 'refactor the payment module'>"
model: opus
effort: high
---

Run the full pbl pipeline autonomously: explore → plan → build → lodge → commit → create-pr → simplify → harness review.

The user provides a feature description and walks away. Make every decision yourself — choose the best approach among alternatives, not the first one that comes to mind. Only interrupt the user for critical blockers like fundamental architecture conflicts or ambiguous requirements that could lead to wasted work.

## Autonomy principle

Each sub-skill in this pipeline has interaction points where it might normally ask the user for input. Override that instinct here:

- When `/explore` would ask about exploration angle — choose the angle most relevant to the feature
- When `/plan` would present risks or open questions — evaluate them yourself, pick the best trade-off
- When `/build` encounters a checkpoint failure — analyze the root cause and fix it
- When `/lodge` finds drift between specs and code — update specs to match code (option 1)
- When `/create-pr` review finds issues — fix them (the review loop handles this automatically)

**Escalate only when:**
- The codebase architecture fundamentally conflicts with the requested feature
- The feature request is ambiguous enough that two valid interpretations would produce completely different implementations
- A critical security or data-loss risk is discovered
- Build failures persist after 2 retry cycles with no clear fix

## Step 1: Explore

Use `/explore` with the user's argument. Choose the exploration angle that best serves the implementation — typically "architecture" for new features or "patterns" for refactors.

Read the resulting `exploration.md` to understand the codebase context.

## Step 2: Plan

Use `/plan` with the same argument. The plan skill will find the exploration from Step 1 automatically.

When the plan surfaces risks or open questions, evaluate each one:
- Consider 2-3 approaches for each decision point
- Pick the approach that balances simplicity, correctness, and maintainability
- Document your reasoning briefly in the plan (the plan skill saves to `plan.md`)

## Step 3: Build

Use `/build` with the plan name. This executes tasks, verifies the checklist, and runs code review.

If the build encounters failures:
- Analyze the root cause before retrying
- If a task approach isn't working, consider an alternative rather than retrying the same thing
- If code review finds critical issues, fix them (the build skill handles the review loop)

## Step 4: Lodge

Use `/lodge` with the spec name to archive the completed work.

If drift is detected between specs and code, update the specs to match the actual implementation — the code is the source of truth after a successful build.

## Step 5: Commit

Group the changes into logical commits rather than one massive commit. Analyze the changes and identify natural boundaries:

- Separate infrastructure/config changes from feature code
- Separate test additions from implementation
- Separate documentation from code changes

For each group, use `/commit` with a hint describing that group's purpose.

## Step 6: Create PR

Use `/create-pr`. This handles pushing, PR creation with mermaid diagram, and the automated review loop (up to 3 rounds of fixes).

## Step 7: Simplify

Use `/simplify` to review the changes for opportunities to reduce complexity — redundant code, over-engineering, unnecessary abstractions, or duplicated logic. If simplifications are found, apply them and use `/commit` with hint "simplify implementation".

## Step 8: Harness review loop

This is the top-level quality gate — distinct from build's per-task code review and create-pr's PR review. Those catch code-level issues. This review checks whether the feature actually does the job and doesn't harm the project.

### Round N (max 3):

1. **Review** — use `/review` on the PR changes. Focus on:
   - Does the implementation fulfill the original feature request?
   - Does it introduce regressions, break existing behavior, or degrade the project?
   - Are there integration issues that per-task reviews would miss?

2. **If issues found:**
   - Fix them in the codebase
   - Use `/commit` with hint "harness review fix (round N)"
   - Push: `git push`
   - Go to next round

3. **If clean or round 3 with remaining issues:**
   - If issues remain after 3 rounds, leave a comment on the PR summarizing what needs manual attention
   - Proceed to Step 9

## Step 9: Report

Tell the user:
- What was implemented (brief summary)
- PR link
- Any decisions you made autonomously and why (so the user can course-correct if needed)
- Any unresolved issues from any review layer (build, PR, or harness)
