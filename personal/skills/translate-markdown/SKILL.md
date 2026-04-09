---
name: translate-markdown
description: This skill should be used when the user asks to "translate this file to Spanish", "convert this markdown to French", "translate the docs to Japanese", or wants to translate any markdown file or text content from one language to another.
user-invocable: true
model: haiku
disable-model-invocation: true
allowed-tools: Bash, Write, Edit, Read
---

Translate source content to the target language, preserving markdown structure throughout.

- Keep the original meaning and tone of the text.
- Preserve all markdown formatting — headings, bold, italic, links, code blocks, lists — exactly as they appear in the source.
- Do not translate code blocks, variable names, file paths, URLs, or technical identifiers.
- Write the translated markdown content to a file if a target directory or file path is specified; otherwise return the translated text directly.

## Process

1. **Identify the source.** Read the source file or content provided.
2. **Identify the target language and destination.** Extract the target language and output path from the provided argument, or ask if unclear.
3. **Translate.** Produce a faithful translation that preserves meaning, tone, and markdown structure.
4. **Write or return.** If a target path is given, write the translated content to that file. Otherwise, return the translated text.

## Argument Format

Accepts flexible input, for example:
- `path/to/file.md Spanish`
- `path/to/file.md --lang fr --out path/to/output.md`
- Just a target language if content is already in context

## Edge Cases

- If no target language is specified, ask the user before proceeding.
- If the source file does not exist, report the error and stop.
- If the target directory does not exist, create it before writing.
- If the content is already in the target language, inform the user and stop.
