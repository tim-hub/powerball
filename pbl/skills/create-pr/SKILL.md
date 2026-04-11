---
name: create-pr
description: Use when the user asks to "create a PR", "open a pull request", "submit changes", "push and create PR", "send this for review", "make a PR", "pr this", or wants to turn their current work into a reviewed pull request. Also use when the user finishes a build and wants to get their changes merged. This skill handles branch creation, PR formatting with mermaid diagrams, and automated review — use it even if the user just says "PR" or "ship it".
user-invocable: true
argument-hint: "[optional: PR title hint or ticket reference]"
model: sonnet
---

Create a pull request from current changes, with a rich description including purpose, file changes, challenges, and a mermaid diagram. Then run automated review and fix issues in a loop.

The skill handles two scenarios automatically — working directly on main (needs a new branch) or already on a feature branch (just create the PR). After PR creation, it runs `/pr-review-toolkit:review-pr` and fixes issues iteratively, up to 3 rounds.

## Step 1: Assess the situation

Gather context to decide the right path:

```bash
git branch --show-current
git status --short
git diff --stat
git diff --stat --staged
git log --oneline -5
```

Determine:
1. **Current branch** — is this `main`, `master`, or a feature branch?
2. **Are there uncommitted changes?** — staged, unstaged, or untracked files
3. **Are there unpushed commits?** — commits ahead of the remote

If there are no changes AND no unpushed commits, tell the user there's nothing to create a PR from and stop.

## Step 2: Branch setup

### Path A: On main/master with changes

When changes exist on `main` or `master`, they need a feature branch before a PR can be created.

1. **Analyze the changes** — read the diff to understand what was done:
   ```bash
   git diff HEAD
   git diff --staged
   ```

2. **Derive a branch name** — from the diff content, pick a descriptive kebab-case name following conventional patterns:
   - `feat/short-description` for new features
   - `fix/short-description` for bug fixes
   - `refactor/short-description` for refactors
   - `chore/short-description` for maintenance
   
   If the user provided an argument (like a ticket number), incorporate it: `feat/PROJ-123-add-auth`.

3. **Create the branch and move changes over:**
   ```bash
   git checkout -b <branch-name>
   ```
   This carries uncommitted changes to the new branch automatically.

4. **Commit** — use the `Skill` tool to invoke `/commit` to stage and commit the changes with a conventional commit message.

5. **Push the branch:**
   ```bash
   git push -u origin <branch-name>
   ```

### Path B: On a feature branch

The branch already exists — just ensure changes are committed and pushed.

1. **If uncommitted changes exist** — use the `Skill` tool to invoke `/commit` to stage and commit.
2. **If there are unpushed commits** — push to remote:
   ```bash
   git push -u origin <branch-name>
   ```
3. **If already pushed and clean** — proceed directly to Step 3.

## Step 3: Analyze changes for PR description

Before creating the PR, build a thorough understanding of the changes. Compare against the base branch (usually `main` or `master`):

```bash
git log main..HEAD --oneline
git diff main..HEAD --stat
git diff main..HEAD
```

From this analysis, extract:
1. **Purpose** — what problem does this solve, and why
2. **Files changed** — group by area (e.g., "API layer", "tests", "config")
3. **Challenges** — any non-obvious decisions, workarounds, or trade-offs worth noting
4. **Change relationships** — how the changed files relate to each other (data flow, dependencies, call chains)

## Step 4: Create the PR

Read the PR description template from this skill's `templates/pr-description.md`. Fill it in with the analysis from Step 3.

For the mermaid diagram, choose the most informative diagram type based on the changes:
- **flowchart** — for changes that affect data flow or control flow between components
- **sequenceDiagram** — for changes to interaction patterns between services/modules
- **classDiagram** — for structural changes to types/interfaces/classes
- **graph** — for dependency changes

The diagram should show what changed and how — not the entire system. Highlight modified components and their connections.

Create the PR using `gh`:

```bash
gh pr create --title "<title>" --body "$(cat <<'EOF'
<filled template content>
EOF
)"
```

The title should be concise (under 70 characters), following conventional commit style if appropriate.

After creation, capture the PR number and URL from the output.

## Step 5: Review loop

Run automated review and fix issues, up to 3 rounds.

### Round N (max 3):

1. **Review** — use the `Skill` tool to invoke `/pr-review-toolkit:review-pr` with the PR number. This dispatches multiple specialized reviewers (code quality, tests, error handling, types, comments).

2. **Evaluate results** — classify issues by severity:
   - **Critical/High** — bugs, security vulnerabilities, data loss risks, broken logic
   - **Medium/Low** — style, naming, minor improvements, suggestions

3. **If critical or high issues exist AND this is not round 3:**
   - Fix the issues in the codebase
   - Use the `Skill` tool to invoke `/commit` with hint "address PR review findings (round N)"
   - Push the fixes: `git push`
   - Go to the next round

4. **If only medium/low issues or no issues:**
   - The review is complete. Proceed to Step 6.

5. **If round 3 and critical/high issues still remain:**
   - Do NOT keep looping. Leave a summary comment on the PR listing the unresolved issues:
     ```bash
     gh pr comment <pr-number> --body "$(cat <<'EOF'
     ## Unresolved Review Issues

     The following critical/high issues remain after 3 review rounds and need manual attention:

     <list of issues with file locations and descriptions>
     EOF
     )"
     ```
   - Proceed to Step 6 with a note that issues remain.

## Step 6: Report

Tell the user:
- **PR created** — link to the PR (URL)
- **Branch** — which branch was created/used
- **Review status**:
  - Clean: "All review checks passed"
  - Fixed: "N issues found and fixed across M review rounds"
  - Unresolved: "N critical/high issues remain — see PR comments for details"
- **Next steps** — suggest reviewing the PR in the browser, requesting human reviewers, or using `/lodge` if this was a pbl spec build

## Quick Reference

| Situation | Action |
|-----------|--------|
| On main with changes | Create feature branch, commit, push, PR |
| On feature branch with uncommitted changes | Commit, push, PR |
| On feature branch, already pushed | Just create PR |
| No changes, no unpushed commits | Stop — nothing to PR |
| Review finds critical issues (round < 3) | Fix, commit, push, re-review |
| Review finds only minor issues | Complete — no fixes needed |
| Critical issues after 3 rounds | Leave PR comment, report to user |
