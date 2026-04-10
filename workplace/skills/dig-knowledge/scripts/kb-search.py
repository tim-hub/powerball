#!/usr/bin/env python3
"""Search knowledge base entries for a project.

Usage:
    kb-search.py <project_path> [search_term]

If search_term is provided, searches filenames and content for matches.
If omitted, returns the 5 most recent entries.

Output: one file path per line, most relevant/recent first.
Exit code 1 if no entries found.
"""

import os
import sys
from pathlib import Path


def search_with_term(project_path: Path, term: str) -> list[str]:
    """Search by filename match first, then content grep."""
    term_lower = term.lower()
    filename_hits = []
    content_hits = []

    for f in project_path.glob("*.md"):
        if term_lower in f.name.lower():
            filename_hits.append(str(f))
        elif term_lower in f.read_text(errors="ignore").lower():
            content_hits.append(str(f))

    # Filename matches first, then content matches, both sorted newest-first
    filename_hits.sort(reverse=True)
    content_hits.sort(reverse=True)

    # Deduplicate while preserving order
    seen = set()
    results = []
    for path in filename_hits + content_hits:
        if path not in seen:
            seen.add(path)
            results.append(path)

    return results[:5]


def recent_entries(project_path: Path) -> list[str]:
    """Return the 5 most recent entries sorted by filename (date prefix)."""
    entries = sorted(project_path.glob("*.md"), key=lambda f: f.name, reverse=True)
    return [str(f) for f in entries[:5]]


def main():
    if len(sys.argv) < 2:
        return 1

    project_path = Path(sys.argv[1])
    if not project_path.is_dir():
        return 1

    search_term = sys.argv[2] if len(sys.argv) >= 3 else ""

    if search_term:
        results = search_with_term(project_path, search_term)
    else:
        results = recent_entries(project_path)

    if not results:
        return 1

    for r in results:
        print(r)
    return 0


if __name__ == "__main__":
    sys.exit(main())
