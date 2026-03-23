---
name: jira-ticket-analyzer
description: "Fetch and analyze Jira tickets to produce actionable development plans. Use this skill whenever the user provides a Jira ticket number (e.g., XY-12345), a Jira URL, or asks to analyze/plan work for a Jira issue. Also trigger when the user says things like 'what needs to be done for [ticket]', 'plan the work for [ticket]', 'analyze [ticket]', 'look at this Jira ticket', or mentions working on a specific ticket. This skill fetches the ticket via the Atlassian MCP server, analyzes the problem, searches the codebase for relevant files, and produces a structured development plan including reproduction steps (for bugs), implementation steps, and test coverage guidance."
user-invocable: true
---

# Jira Ticket Analyzer

Fetch a Jira ticket, understand the problem, explore relevant code, and produce a development plan with testing guidance.

## Prerequisites

Requires the **Atlassian MCP server** to be connected. If tools like `getJiraIssue` are unavailable, ask the user to run `/mcp` to connect and authenticate.

If the user has configured their cloudId in CLAUDE.md, use it directly instead of calling `getAccessibleAtlassianResources`.

## Step 1: Parse Input & Fetch Ticket

The user may provide a ticket number (`XY-12345`), a Jira URL, or a description. For descriptions, search with `searchJiraIssuesUsingJql` and ask the user to confirm which ticket.

Fetch with `getJiraIssue(cloudId, issueIdOrKey, responseContentFormat="markdown")` and extract: summary, type, status, priority, description, acceptance criteria, comments, linked issues, attachments, and labels/components.

Fetch up to 3 linked issues (parent epic, blockers, related tickets, confluence pages) for broader context. Pay special attention to **comments** — they often contain the most valuable context (decisions, workarounds, reproduction details).

## Step 2: Analyze the Problem

**Classify the ticket type** — this drives the plan structure:
- **Bug** — broken, wrong results, crashes → gets reproduction steps
- **Feature** — new functionality → gets acceptance criteria breakdown
- **Enhancement** — improvement to existing functionality
- **Tech Debt / Refactor** — code quality, performance, maintainability → emphasize regression testing
- **Investigation / Spike** — research task → focus on questions to answer

**Synthesize context** from description, comments, linked tickets, and labels to write a 2-3 sentence problem summary for a developer who has never seen this ticket.

## Step 3: Explore the Codebase

Search for relevant code using the ticket context:
- `Grep` for keywords (error messages, component names, function/class names)
- `Glob` for file patterns (e.g., `**/Calendar/**/*.php`)
- `Read` to understand the code once located

Start narrow — if the ticket mentions specific files or classes, begin there. Optionally run `git log --oneline -10 <file>` on critical files to check for recent activity or ongoing work.

## Step 4: Produce the Plan

Output using [this structure](references/output-structure.md), adapting sections based on ticket type.


## Adaptation by Type

- **Bug**: Always include "How to Reproduce". Focus on root cause, not symptoms. First test case = exact repro scenario.
- **Feature**: Break acceptance criteria into steps. Identify existing patterns to follow. Note new files needed.
- **Tech Debt**: Explain current state and why it's problematic. Preserve existing behavior. Suggest incremental approach.
- **Spike**: Focus on questions to answer. Define "done". Recommend follow-up tickets.

## Tips

- Comments often have better context than the description — read them carefully
- Show specific file paths with line numbers so the developer can jump straight there
- If the ticket is vague, call it out in "Open Questions" rather than guessing
- Fetch linked tickets to understand scope, but limit to the most relevant 3
