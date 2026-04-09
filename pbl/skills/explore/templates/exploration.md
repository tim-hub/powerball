# Exploration: {{NAME}}

> Generated on {{DATE}}

## Overview

{{A one-paragraph summary of what was explored and the key takeaway.}}

## Scope

- **Target**: {{What was explored — a directory, module, feature, or the full codebase}}
- **Depth**: {{quick | medium | thorough}}

## Key Components

| Component | Path | Purpose |
|-----------|------|---------|
| {{name}} | {{path}} | {{brief description}} |

## Architecture

{{How components connect — entry points, data flow, layer structure.}}

Include a Mermaid diagram to visualize the architecture:

```mermaid
graph TD
    {{component relationships — e.g., A[Module A] --> B[Module B]}}
```

## Patterns & Conventions

- {{Pattern observed — e.g., "Repository pattern for data access", "barrel exports in each module"}}

## Dependencies

### External
- {{package}} — {{what it's used for}}

### Internal
- {{module}} depends on {{module}} — {{why}}

## Notes

- {{Anything surprising, risky, undocumented, or worth flagging for future work}}
