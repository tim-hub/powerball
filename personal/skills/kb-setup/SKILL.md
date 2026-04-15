---
name: kb-setup
description: Knowledge base setup and configuration skill. Use this skill when the user wants to configure the knowledge base, set up KB paths, update allow/disallow lists, reset the KB config, or when kb/kb-search fails because config is missing. Trigger when user says "kb setup", "setup knowledge base", "configure kb", "kb reset", or when invoked internally by kb or kb-search because ~/.kb/config.json is missing.
argument-hint: "[reset]"
user-invocable: true
allowed-tools: Bash, Read
model: haiku
---

Set up or update the knowledge base configuration at `~/.kb/config.json`.

## Subcommand: reset

If the argument is `reset`:
```bash
bash <skill-dir>/scripts/init.sh reset
```
This writes an empty config: `{"allow_list": [], "disallow_list": []}`.
Confirm to the user and stop.

## Read Existing Config

```bash
cat ~/.kb/config.json 2>/dev/null
```

### If config exists and is non-empty:

Show the current configuration clearly:
```
Current KB configuration:
  allow_list:
    - /path/one
    - /path/two
  disallow_list:
    - /path/ignored
```

Ask the user what they want to do:
1. **Add paths** to allow_list
2. **Remove paths** from allow_list
3. **Update disallow_list** (paths to ignore during search)
4. **No changes** — exit

### If config is missing or empty:

Explain what the KB needs:
- `allow_list` — directories to search when using `kb-search`, and where KB files are stored (`allow_list[0]/kb/` is the default KB storage location)
- `disallow_list` — directories to exclude (e.g., `node_modules`, `.git`, build artifacts)

Ask for the paths:
1. "Which directories should be included in KB search? (Provide full paths, one per line)"
2. "Any directories to exclude? (Optional — press enter to skip)"

## Save Configuration

After collecting the paths, run:
```bash
bash <skill-dir>/scripts/init.sh "<allow_list_json>" "<disallow_list_json>"
```

The script writes the config to `~/.kb/config.json` and creates the `kb/` subfolder inside `allow_list[0]` if it doesn't exist.

## Confirm

Show the final saved configuration to the user and confirm the setup is complete.
The `allow_list[0]/kb/` directory is where project KB files will be stored.

## References

- Script: `scripts/init.sh` — writes `~/.kb/config.json` and creates KB directories
