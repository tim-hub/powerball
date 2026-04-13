---
name: translate-markdown
description: This skill should be used when the user asks to "translate this file to Spanish", "convert this markdown to French", "translate the docs to Japanese", or wants to translate any markdown file or text content from one language to another.
user-invocable: true
model: haiku
disable-model-invocation: true
allowed-tools: Bash, Write, Edit, Read
---

Translate a markdown file (or markdown content) to a target language, preserving structure.

This skill is a convenience wrapper around the general-purpose `language-translate` skill, specialized for the common case of translating markdown files on disk. For the underlying translation rules (what to preserve, what to translate, how to handle code blocks), defer to `language-translate`.

## Process

1. **Identify the source.** Read the markdown file or content provided.
2. **Identify the target language and destination.** Extract the target language and output path from the argument, or ask if unclear.
3. **Delegate the translation.** Apply the rules from the `language-translate` skill:
   - Preserve all markdown syntax (headings, bold, italic, links, lists, tables, code fences).
   - Translate only human-readable prose.
   - Inside code blocks, translate comments and docstrings; leave code itself unchanged.
   - Do not translate URLs, file paths, variable names, or technical identifiers.
4. **Write or return.** If a target path is given, write the translated markdown to that file (creating the directory if needed). Otherwise, return the translated content directly.

## Argument Format

Accepts flexible input, for example:
- `path/to/file.md Spanish`
- `path/to/file.md --lang fr --out path/to/output.md`
- Just a target language if the content is already in context

## Edge Cases

- If no target language is specified, ask the user before proceeding.
- If the source file does not exist, report the error and stop.
- If the target directory does not exist, create it before writing.
- If the content is already in the target language, inform the user and stop.

## Relationship to language-translate

Use `translate-markdown` when the user specifically wants a markdown file translated and written to disk. Use `language-translate` directly for non-file inputs, non-markdown formats (plain text, standalone code snippets), or when embedding translation into a larger workflow.
