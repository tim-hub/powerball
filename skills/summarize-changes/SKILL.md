---
name: summarize-changes
description: This skill should be used when summarizing code changes, writing descriptions of what changed in a diff or PR, generating changelog entries, or explaining the impact of a set of commits. Relevant when a user asks "what changed?", "summarize this diff", "write a changelog", "write a PR description", or requests release notes or commit messages that convey change impact.
model: haiku
allowed-tools: Read, Bash, Write, Edit
---

## Core Principles

Good change summaries communicate **impact**, not mechanics. A reader shouldn't need to understand the code to know why a change matters.

**Bad:** "Updated function signature and added null check"
**Good:** "Prevents crash when user submits empty form"

The job is to translate code changes into meaning — what a person gains, what problem disappears, what breaks.

## Structure Changes by Significance

Not all changes are equal. Order summaries with the most impactful changes first:

1. **Breaking changes** — anything that changes existing behavior or contracts
2. **New capabilities** — features users or callers can now use
3. **Bug fixes** — problems that are now resolved
4. **Refactors / internals** — structural changes with no visible behavior change
5. **Chores** — deps, formatting, CI, docs

Skip categories that don't apply. Don't pad.

## Writing Individual Change Entries

Each entry should answer: **what changed, and why does it matter?**

**Format:** Imperative verb + subject + optional context

```
Add retry logic to API client (prevents failures on flaky connections)
Fix null pointer when user profile is missing avatar
Remove deprecated `--legacy` flag
```

**Verbs to use:** Add, Fix, Remove, Update, Improve, Extract, Rename, Replace, Migrate

**Avoid:**
- Passive voice: "was updated", "has been fixed"
- Vague nouns: "various improvements", "misc changes", "cleanup"
- Implementation details as the primary description: "Changed forEach to reduce"

## Diff Analysis Approach

When analyzing a diff to generate a summary:

1. **Read file names first** — they reveal the domain (auth, payments, UI)
2. **Identify added/removed exports** — these are API surface changes
3. **Find deleted code** — removals are often the most important signal
4. **Check test changes** — test names describe intended behavior precisely
5. **Read new error messages** — they describe the bug that was fixed
6. **Ignore formatting noise** — whitespace, import reordering, comment tweaks

**For large diffs (50+ files):** Don't try to enumerate everything. Identify 3–5 dominant themes and summarize those. Note the total scope ("~80 files across auth and payments modules") so readers understand the scale without drowning in detail.

**For squash/merge commits:** Read the PR title and description if available — they often already contain the best summary. Use them as the foundation and refine rather than re-deriving from the raw diff.

**For ambiguous context ("summarize the last sprint"):** Ask which commits or date range to scope. Don't guess; a misscoped summary is worse than no summary.

## Grouping Related Changes

When multiple files changed together for one reason, group them into a single entry:

```
Migrate authentication from JWT to sessions
  - Updated middleware, login route, and session config
  - Removed jwt-decode dependency
```

Don't create one entry per file. Group by intent, not by file.

If a single PR or commit touches two unrelated concerns, split the summary into separate groups even if they share a commit. This is common in "fix the bug while you're in there" changes.

## Worked Example

**Diff summary (5 files changed):**
- `src/auth/middleware.ts` — removed JWT decode, added session check
- `src/auth/login.ts` — replaced `jwt.sign()` with `session.create()`
- `src/auth/logout.ts` — clears session instead of blacklisting token
- `package.json` — removed `jsonwebtoken` dep, added `express-session`
- `tests/auth.test.ts` — updated tests to use session-based flows

**As a commit message:**
```
refactor(auth): replace JWT with session-based authentication
```

**As a PR description:**
```
## Summary
- Replace JWT-based auth with server-side sessions

## What changed
JWT required token blacklisting on logout, which created a distributed state
problem. Sessions are simpler to invalidate and reduce client-side complexity.

## Test plan
- [ ] Login, navigate protected routes, verify session persists
- [ ] Logout, verify session is destroyed and protected routes redirect
- [ ] Restart server, verify sessions do not survive (expected)
```

**As a changelog entry:**
```
### Changed
- Authentication now uses server-side sessions instead of JWTs,
  simplifying logout behavior and eliminating token blacklist infrastructure.
```

## Tone by Context

**Commit messages** — terse, imperative, technical audience
```
fix(auth): redirect to login on token expiry
```

**PR descriptions** — conversational, explains reasoning, mixed audience
```
The old token refresh logic had a race condition under load. This replaces it
with a simpler expiry check on each request.
```

**Changelog / release notes** — user-facing, no internal jargon, benefit-focused
```
Fixed an issue where users were unexpectedly logged out during heavy traffic.
```

**Code review comments** — specific, cite the line, explain the why
```
This null check on line 42 will silently swallow errors if `user.profile` is
undefined. Consider throwing instead so callers know something went wrong.
```
