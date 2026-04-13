---
name: language-translate
description: General-purpose translation between any two languages while preserving source format. Use this skill whenever the user needs to translate plain text, code snippets, markdown, or mixed content from one language to another. Automatically detects source language; user specifies target. Preserves markdown syntax, preserves code (translating only comments and docstrings), and keeps output format identical to input format. This is the core translation primitive — other skills like translate-markdown build on top of it.
user-invocable: true
model: haiku
disable-model-invocation: false
allowed-tools: Bash, Write, Edit, Read
---

Translate content from one language to another while keeping the source format intact. The principle: the reader should be able to tell what the original looked like just by looking at the translation — same structure, same formatting, same code.

## What to preserve

The translation should change the *words* but not the *shape* of the content.

- **Markdown input → markdown output.** Headings (`#`, `##`), emphasis (`**bold**`, `*italic*`), links, lists, tables, and code fences stay exactly as they are. Only the human-readable prose inside gets translated.
- **Plain text → plain text.** Do not introduce markdown formatting that wasn't in the source. Paragraph breaks stay the same.
- **Code → code.** Keep variable names, function names, class names, keywords, and syntax unchanged. Translate only:
  - Comments (`//`, `#`, `--`, `/* */`, etc.)
  - Docstrings (`"""..."""`, `'''...'''`)
  - User-facing string literals when context clearly indicates they're meant for human display (e.g., error messages, UI labels). When unsure, leave strings alone.
- **Mixed content.** A markdown file with code blocks inside is the common case: translate the markdown prose, translate comments inside the code blocks, leave the code itself alone.

## What to leave untranslated

Technical identifiers look like words but are not — translating them breaks the content. Leave these in the source language:

- URLs and file paths
- Variable, function, class, and module names
- Command-line flags, environment variables, API endpoints
- Proper nouns (product names, company names, people's names) unless a well-known localized form exists
- Code inside fenced code blocks (except for comments/docstrings, per above)

## Process

1. **Read the input.** Determine whether it's plain text, markdown, code, or mixed content.
2. **Identify the target language.** If the user did not specify one, ask.
3. **Detect the source language** automatically — no need to ask.
4. **Translate.** Produce a faithful, natural-sounding translation in the target language. Be idiomatic rather than literal when the two languages diverge.
5. **Emit in the same format as the source.** If the user asked for a file output, write to the path they specified; otherwise return the translated content directly.

## Examples

**Example 1 — Markdown:**

Input:
```markdown
# Welcome

This is **important** information.
```

Output (to French):
```markdown
# Bienvenue

Ceci est une information **importante**.
```

**Example 2 — Python with comments:**

Input:
```python
# Calculate the total price
def calculate_total(items):
    """Return the sum of all item prices."""
    return sum(item.price for item in items)
```

Output (to German):
```python
# Den Gesamtpreis berechnen
def calculate_total(items):
    """Gibt die Summe aller Artikelpreise zurück."""
    return sum(item.price for item in items)
```

Notice that `calculate_total`, `items`, `item.price`, and `sum` are preserved. Only the human-facing comment and docstring change.

**Example 3 — Mixed markdown + code:**

Input:
````markdown
# Usage

Call the API like this:

```javascript
// Fetch the user profile
const user = await fetchUser(id);
```
````

Output (to Japanese):
````markdown
# 使い方

このように API を呼び出します:

```javascript
// ユーザープロフィールを取得
const user = await fetchUser(id);
```
````

## Edge cases

- **No target language given.** Ask the user — do not guess.
- **Source already in target language.** Inform the user and stop; do not re-translate.
- **Unfamiliar domain jargon.** Preserve the original term in parentheses after the translation if it aids understanding, e.g., `キャッシュ (cache)`.
- **Very long content.** Translate in full; do not summarize or truncate. If the content is genuinely too large, translate section by section, preserving section boundaries.

## Used by

The `translate-markdown` skill delegates to this skill for the actual translation work. This skill is the general-purpose primitive; `translate-markdown` is a convenience wrapper for the common markdown-file case.
