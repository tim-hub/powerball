---
name: skill-review
description: Review a SKILL.md file for clarity, simplicity, and quality. Use this whenever the user asks to "review my skill", "check if this skill is clear", "simplify a skill", "audit skill writing", "is this skill well written", or wants feedback on whether a SKILL.md could be improved or is doing too much.
model: sonnet
tools:
  deny:
    - WebFetch
    - Fetch
---

Review the skill at: $ARGUMENTS (or the currently active/open SKILL.md if no path is given).

Read the file, then evaluate it across five dimensions and produce a structured report.

## Five Dimensions

**1. Clarity** — Can someone follow the instructions without ambiguity?
- Are steps numbered or sequenced clearly?
- Are conditionals ("if X, do Y") explicit?
- Is it obvious what output is expected?

**2. Conciseness** — Is every line earning its place?
- Are there sections that repeat the same point?
- Is there background context the model doesn't need to act?
- Could a bullet list be collapsed into one sentence without losing meaning?

**3. Actionability** — Are instructions specific enough to act on?
- Does each step say *what* to do, not just *that* something should happen?
- Are vague verbs ("handle", "deal with", "manage") used without explanation?
- Are expected outputs, file paths, or tool calls spelled out?

**4. Scope** — Is this skill doing one thing, or secretly three?
- Could it be split into two focused skills that each trigger independently?
- Are there sections that only apply to a subset of use cases, making the skill feel bloated for the common case?
- Is the model being asked to make judgment calls that belong in the user's hands?

**5. Description & frontmatter** — Will this skill trigger at the right times?
- Does the description name the contexts and phrases that should trigger it?
- Is it specific enough to avoid false positives (triggering when it shouldn't)?
- Does it tell Claude *what the skill does* AND *when to use it*?
- Are `model`, `tools`, and other frontmatter settings appropriate for the skill's task?

## Report Format

**Overall verdict:** [Good / Needs Work / Major Revision]
One sentence on the main strength and main weakness.

**Issues:**
For each problem found, cite the section or approximate line, name the dimension, describe what's wrong and why it matters, then provide a rewrite:

> **[Dimension] — [Section or Line Reference]**
> Problem: [what's wrong and why it matters]
> Suggested rewrite:
> ```
> [rewritten text]
> ```

If a section has no issues, skip it — don't pad with "this looks fine."

**What's working:**
2–3 specific things done well. Omit only if the skill needs major revision.

Keep the review honest and specific. Vague praise or vague criticism isn't useful. If the skill is genuinely clear and simple, say so.
