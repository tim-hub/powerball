---
name: update-overview
description: Use when the user asks to "update overview", "refresh diagrams", "regenerate overall.md", "show the big picture", "update project diagrams", or wants to see the cumulative state of what's been built. Also called by the lodge skill after moving specs to lodge.
model: opus
user-invocable: true
argument-hint: "[spec name that was just lodged, or leave blank to regenerate from all lodged specs]"
---

Maintain a living `overall.md` document in `.powerball/lodge/` that captures the cumulative state of the project through four mermaid diagrams. Each time specs are lodged, read what was built and update the relevant diagrams — this file grows richer over time as more work is lodged.

The purpose is to give anyone opening the project a visual snapshot of where things stand: what features exist and why, how the system is structured, how users interact with it, and what the data model looks like.

## Input

You receive either:
- **spec_dir**: Path to the spec directory that was just lodged (now in `.powerball/lodge/`)
- Or **no argument**: regenerate from all lodged specs in `.powerball/lodge/`

The lodge directory is always `.powerball/lodge/`.

Read the lodged spec's `exploration.md`, `plan.md`, and `tasks.md` to understand what was built.

## Process

### Step 1: Read the lodged specs

Read these files from the lodged spec directory:
- `exploration.md` — what was explored, components, architecture
- `plan.md` — what was planned, architecture decisions, goals
- `tasks.md` — what was actually implemented

Synthesize: what changed in the project as a result of this work?

### Step 2: Read existing overall.md (if any)

Check if `.powerball/lodge/overall.md` exists.
- If yes, read it — you'll be updating the existing diagrams.
- If no, you'll create it fresh from the template.

### Step 3: Update each diagram

The file contains exactly four mermaid diagrams. For each one, decide whether the lodged work is relevant — if the work doesn't touch that dimension, leave that diagram unchanged. Don't update for the sake of updating.

#### 1. Feature Mindmap

A `mindmap` diagram showing the project's features, organized by domain. Each branch can include the feature name, what it does, and why it was built (the motivation from the plan). When new features are lodged, add them to the appropriate branch or create a new branch if it's a new domain.

Think of this as the answer to: "What does this project do and why?"

#### 2. Architecture Diagram

An `architecture-beta` diagram showing the system's groups and services — use `group` for logical boundaries (e.g. frontend, backend, data layer) and `service` for individual components within them. Connect services with edges to show data flow. When lodged work adds new components or changes how existing ones connect, update accordingly.

Think of this as the answer to: "How is this system structured?"

#### 3. User Journey

A `journey` diagram showing how users interact with the system — the key flows, touchpoints, and experience. When lodged work adds new user-facing flows or modifies existing ones, update the journey. Internal/backend-only changes that don't affect user experience should not change this diagram.

Think of this as the answer to: "How do people use this?"

#### 4. Entity Relationship Diagram

An `erDiagram` showing the data model — entities, their attributes, and relationships. When lodged work adds new data models, modifies schemas, or changes relationships, update accordingly. If the lodged work has no data model impact, leave unchanged.

Think of this as the answer to: "What does the data look like?"

### Step 4: Write overall.md

1. If creating fresh: read the template from this skill's `templates/overall.md`, fill in all sections.
2. If updating: modify the existing `overall.md` in place — preserve diagrams that didn't change, update ones that did.
3. At the bottom of each diagram section, include a brief changelog note: `<!-- Last updated: YYYY-MM-DD-{{name}} — {{what changed}} -->`.
4. Write to `.powerball/lodge/overall.md`.

## Guidelines

- Keep diagrams readable — if a diagram grows too complex, group related items into subgraphs or collapse detail.
- Each diagram should be self-contained and renderable — valid mermaid syntax, no broken references.
- Preserve existing content faithfully when updating — only change what the new lodged work affects.
- The changelog comments help future updates understand the provenance of each diagram element.
- If a lodged spec is purely exploratory (no plan.md or tasks.md), update only the mindmap with the findings.
- Use consistent naming across diagrams — if the architecture calls it "AuthService", the ER diagram should reference the same name.
