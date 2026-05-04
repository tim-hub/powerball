import json
import re
import sys

SKILL_PATH_RE = re.compile(r'^(.*/skills/[^/]+)/[^/].*$')

def main():
    data = sys.stdin.read()
    if not data:
        return

    try:
        inp = json.loads(data)
    except json.JSONDecodeError:
        return

    fp = inp.get('tool_input', {}).get('file_path', '')
    if not fp:
        return

    # Skip third-party plugin caches; we don't own those.
    if '/plugins/cache/' in fp:
        return

    m = SKILL_PATH_RE.match(fp)
    if not m:
        return

    skill_dir = m.group(1)
    out = {
        'hookSpecificOutput': {
            'hookEventName': 'PostToolUse',
            'additionalContext': (
                f"Skill file edited under {skill_dir}. "
                f"Standing directive: before ending this turn, invoke /optimize-skill {skill_dir} "
                f"and apply its auto-fixes, surfacing any 'Needs Confirmation' items to the user."
            )
        }
    }
    print(json.dumps(out))

if __name__ == '__main__':
    main()
