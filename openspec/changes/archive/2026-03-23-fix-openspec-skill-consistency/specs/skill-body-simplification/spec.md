## ADDED Requirements

### Requirement: Duplicated artifact creation guidelines extracted to shared reference
The "Artifact Creation Guidelines" block duplicated in `openspec-propose` and `openspec-continue-change` SHALL be extracted to `openspec-rewrite/references/artifact-guidelines.md`. Both skills SHALL replace the inline block with a one-line reference pointer.

#### Scenario: Shared reference file exists
- **WHEN** the file `openspec-rewrite/references/artifact-guidelines.md` is checked
- **THEN** it contains the full "Artifact Creation Guidelines" content

#### Scenario: openspec-propose references shared file
- **WHEN** `openspec-propose/SKILL.md` body is read
- **THEN** the duplicated block is replaced with a reference line pointing to `references/artifact-guidelines.md`

#### Scenario: openspec-continue-change references shared file
- **WHEN** `openspec-continue-change/SKILL.md` body is read
- **THEN** the duplicated block is replaced with a reference line pointing to `references/artifact-guidelines.md`

### Requirement: openspec-explore examples extracted to references
The 4 dialogue example blocks in `openspec-explore` (lines ~150-250) SHALL be moved to `openspec-rewrite/skills/openspec-explore/references/explore-examples.md`. The body SHALL retain a brief pointer.

#### Scenario: Examples file created
- **WHEN** `openspec-explore/references/explore-examples.md` is checked
- **THEN** it contains the 4 dialogue examples (vague idea, specific problem, stuck mid-implementation, compare options)

#### Scenario: Body reduced
- **WHEN** `openspec-explore/SKILL.md` body is measured
- **THEN** the body is at least 80 lines shorter than before the change

### Requirement: openspec-explore uses imperative form throughout
The `openspec-explore` SKILL.md body SHALL NOT contain second-person pronouns ("you", "your") in instructional sections. The "What You Don't Have To Do" section SHALL be rewritten in imperative form or as a "Not Required" list.

#### Scenario: No second-person in body instructions
- **WHEN** `openspec-explore/SKILL.md` body is scanned for "you" and "your" outside of quoted user dialogue
- **THEN** no instances are found in instructional/directive text

### Requirement: openspec-verify-change output templates extracted to references
The output format template (report structure) and the "Verification Heuristics" and "Graceful Degradation" sections SHALL be moved to `openspec-rewrite/skills/openspec-verify-change/references/`. The body SHALL retain a brief pointer.

#### Scenario: References directory created with extracted content
- **WHEN** `openspec-verify-change/references/` is checked
- **THEN** it contains files with the output template, heuristics, and degradation guidelines

#### Scenario: Body reduced
- **WHEN** `openspec-verify-change/SKILL.md` body is measured
- **THEN** the body is at least 40 lines shorter than before the change
