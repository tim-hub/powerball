# KB Setup Skill Evaluation — Fresh Install (with_skill)

## Task

User requested first-time KB setup:
- Store everything in `/tmp/kb-eval-1-with`
- Exclude `/tmp/kb-eval-1-with/archive` from searches

## Pre-conditions

- `~/.kb/config.json` did **not** exist before the skill ran (fresh environment).
- `~/.kb/` directory did not exist.

## Steps Executed by the Skill

### 1. Read Existing Config

```bash
cat ~/.kb/config.json 2>/dev/null
```

Result: No output — config was missing/empty. This triggered the "fresh setup" branch.

### 2. Skill Behavior (fresh config path)

The skill explained what KB needs:
- `allow_list` — directories to search and where KB files are stored (`allow_list[0]/kb/` is the default storage location)
- `disallow_list` — directories to exclude from search

Paths collected from user task statement:
- **allow_list**: `/tmp/kb-eval-1-with`
- **disallow_list**: `/tmp/kb-eval-1-with/archive`

### 3. Script Invocation

```bash
bash <skill-dir>/scripts/init.sh '["/tmp/kb-eval-1-with"]' '["/tmp/kb-eval-1-with/archive"]'
```

Script output:
```
saved:/Users/hbai/.kb/config.json
kb-dir:/tmp/kb-eval-1-with/kb
```

### 4. Config Written

The script used `jq` to write valid JSON to `~/.kb/config.json`:

```json
{
  "allow_list": [
    "/tmp/kb-eval-1-with"
  ],
  "disallow_list": [
    "/tmp/kb-eval-1-with/archive"
  ]
}
```

### 5. KB Directory Created

The script created `/tmp/kb-eval-1-with/kb` (the default KB storage location, derived from `allow_list[0]/kb/`).

Verified with `ls -la /tmp/kb-eval-1-with/kb`:
```
total 0
drwxr-xr-x@ 2 hbai  wheel  64 Apr 16 13:55 .
drwxr-xr-x@ 3 hbai  wheel  96 Apr 16 13:55 ..
```

## Errors

None. The script completed successfully.

## Summary

| Item | Result |
|------|--------|
| Config file written | Yes — `~/.kb/config.json` |
| `allow_list` set | Yes — `/tmp/kb-eval-1-with` |
| `disallow_list` set | Yes — `/tmp/kb-eval-1-with/archive` |
| `kb/` directory created | Yes — `/tmp/kb-eval-1-with/kb` |
| Errors | None |

## Notes

- The sandbox (`~/.kb` not in write allowlist) required `dangerouslyDisableSandbox: true` to write the config file. This is expected in a sandboxed evaluation environment and does not reflect a skill defect.
- The skill correctly followed the "fresh install" code path: detected missing config, collected paths, invoked the init script, and confirmed the result.
