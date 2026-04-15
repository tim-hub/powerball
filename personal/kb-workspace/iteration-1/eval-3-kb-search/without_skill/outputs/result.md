# KB Search Result — Without Skill

**Query:** database connections or pool settings

---

## Search Method

Used `grep` (ripgrep) with pattern `pool|database|connection` (case-insensitive) across all files in the KB directory (`/tmp/claude/kb-eval-3-without/kb/`).

Command equivalent:
```
grep -r -i "pool|database|connection" /tmp/claude/kb-eval-3-without/kb/
```

---

## Results Found

### File: `myproject.md`

**Matching section: Connection Pool Sizing**

> After hitting repeated 503s under load, we discovered the default pool_size of 5 was too small.
> Fixed by setting pool_size=100 and pool_timeout=30 in database.yml.
> Always benchmark connection pool settings against expected concurrency.

---

## What Was Presented to the User

Here is what I found in your knowledge base about database connections and pool settings:

**From `myproject.md` — Connection Pool Sizing**

- The default `pool_size` of 5 caused repeated 503 errors under load.
- Fix applied: `pool_size=100` and `pool_timeout=30` in `database.yml`.
- Recommendation: Always benchmark connection pool settings against expected concurrency.

---

## Observations (for evaluation)

- The search worked, but it was purely text-pattern based — no semantic understanding.
- The query "database connections" matched because the section contains related keywords like "connection pool" and "database.yml", but a query like "why did we get 503 errors?" would return nothing despite the answer being in this section.
- There is no ranking, scoring, or summarization — just raw grep output.
- The user had to know to search for the right keywords. A skill with semantic search or NLP would handle natural language queries much better.
- No support for fuzzy matching, synonyms, or intent understanding.
