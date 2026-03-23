# Artifact Creation Guidelines

- Follow the `instruction` field from `openspec instructions` for each artifact type
- The schema defines what each artifact should contain — follow it
- Read dependency artifacts for context before creating new ones
- Use `template` as the structure for the output file — fill in its sections
- **`context` and `rules` are constraints for the model, not content for the file**
  - Do NOT copy `<context>`, `<rules>`, `<project_context>` blocks into the artifact
  - These guide what to write, but should never appear in the output
