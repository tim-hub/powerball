---
name: kb-search
description: Knowledge base search skill. Use this skill when the user wants to search the knowledge base, find past notes, look up stored information, or recall what was previously documented. Trigger when user says "kb search", "search kb", "find in knowledge base", "look up X in kb", "what do we know about X", "search my notes for X", or any variation of searching local notes/knowledge. Also trigger when a question could be answered by prior documented knowledge.
argument-hint: "<search keyword or phrase>"
user-invocable: true
allowed-tools: Bash, Read
context: fork
model: haiku
---

Search the knowledge base and local files using ripgrep, returning the most relevant results.

## Setup Check

Before searching, verify the KB is configured:
```bash
cat ~/.kb/config.json 2>/dev/null
```
If the config is missing or empty, invoke the `kb-setup` skill first.

## Read Config

Load search paths from `~/.kb/config.json`:
- `allow_list` — paths to search (can include any directories, not just the `kb/` subfolder)
- `disallow_list` — paths to exclude from search results

## Keyword Expansion

The user's input keyword is a starting point — expand it to find more relevant results:

1. Extract the core search term from the argument.
2. Generate 2-4 related/synonymous keywords (e.g., "JWT" → also try "token", "auth", "bearer").
3. Pass each keyword to `scripts/search.sh` in parallel (up to the limit).

This expansion catches results the user would expect even when they phrase things differently from how they were written.

## Run Search

For each keyword variant, run in parallel:
```bash
bash <skill-dir>/scripts/search.sh "<keyword>" "<allow_list_json>" "<disallow_list_json>"
```

Collect all results. The script returns matching lines with file paths and context.

## Result Ranking and Filtering

From all parallel results:
1. Deduplicate results that appear for multiple keyword variants (same file + line number).
2. Rank by relevance — prefer results where:
   - The keyword appears in a heading (`##`) over body text
   - Multiple keyword variants matched the same file/section
3. Return the **top 3 most relevant results**.

## Output Format

Present results clearly:

```
## Search Results for "<query>"

### 1. [Topic from heading] — <relative-file-path>
> <matching excerpt, 2-4 lines of context>

### 2. [Topic from heading] — <relative-file-path>
> <matching excerpt, 2-4 lines of context>

### 3. [Topic from heading] — <relative-file-path>
> <matching excerpt, 2-4 lines of context>
```

If no results found: say so clearly and suggest trying broader terms or checking if `kb-setup` has the right paths configured.

## References

- Script: `scripts/search.sh` — ripgrep wrapper with allow/disallow list support
