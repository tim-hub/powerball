# kb-search Skill — Evaluation Output

**User query:** "Search my knowledge base for anything about database connections or pool settings."

---

## Skill Execution Notes

### Setup Check

Config at `~/.kb/config.json` was present and valid:
```json
{"allow_list": ["/tmp/kb-eval-3-with"], "disallow_list": []}
```

### Keyword Expansion

The skill extracts the core concepts from the query and generates 2–4 synonymous variants:

| # | Keyword | Rationale |
|---|---------|-----------|
| 1 | `connection` | Direct match to "database connections" |
| 2 | `pool` | Direct match to "pool settings" |
| 3 | `database` | Core subject of the query |
| 4 | `pool_size` | Specific config parameter likely stored in notes |

All four were passed to `scripts/search.sh` in parallel.

### Scripts Called

```bash
bash scripts/search.sh "connection" '["/tmp/kb-eval-3-with"]' '[]'
bash scripts/search.sh "pool"       '["/tmp/kb-eval-3-with"]' '[]'
bash scripts/search.sh "database"   '["/tmp/kb-eval-3-with"]' '[]'
bash scripts/search.sh "pool_size"  '["/tmp/kb-eval-3-with"]' '[]'
```

Each call invokes `rg --ignore-case --context 2 --max-count 20 --type md --no-heading --line-number`.

### Raw Results (before deduplication)

**connection** — matched lines 5, 9 of `kb/myproject.md`
- Line 5: `## Connection Pool Sizing` (heading match)
- Line 9: `Always benchmark connection pool settings against expected concurrency.`

**pool** — matched lines 5, 7, 8, 9 of `kb/myproject.md`
- Line 5: `## Connection Pool Sizing` (heading match)
- Line 7: `...the default pool_size of 5 was too small.`
- Line 8: `Fixed by setting pool_size=100 and pool_timeout=30 in database.yml.`
- Line 9: `Always benchmark connection pool settings against expected concurrency.`

**database** — matched line 8 of `kb/myproject.md`
- Line 8: `Fixed by setting pool_size=100 and pool_timeout=30 in database.yml.`

**pool_size** — matched lines 7, 8 of `kb/myproject.md`
- Line 7: `...the default pool_size of 5 was too small.`
- Line 8: `Fixed by setting pool_size=100 and pool_timeout=30 in database.yml.`

### Deduplication and Ranking

All matches resolve to a single file and section: **`kb/myproject.md` → `## Connection Pool Sizing`**.

Ranking factors applied:
- **Heading match** (`##`): "connection" and "pool" both matched line 5 (`## Connection Pool Sizing`) — highest priority signal.
- **Multiple keyword variants matched same section**: All 4 keywords matched lines within the same section — strong relevance boost.
- **kb/ subfolder**: The file is under `kb/` — preferred as curated content.

Only one distinct result exists after deduplication, so it is returned as result #1 (no result #2 or #3 needed).

---

## Search Results for "database connections or pool settings"

### 1. Connection Pool Sizing — kb/myproject.md

> After hitting repeated 503s under load, we discovered the default pool_size of 5 was too small.
> Fixed by setting pool_size=100 and pool_timeout=30 in database.yml.
> Always benchmark connection pool settings against expected concurrency.

---

*No additional results found. The knowledge base contains one entry directly covering this topic. If you need more, consider adding notes to your KB or broadening the search with terms like `timeout`, `concurrency`, or `yml`.*
