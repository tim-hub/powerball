---
name: creative-writing
description: This skill should be used when the user asks to "write a post about", "create content for", "draft a description of", "generate copy for", "write a tweet", "write a LinkedIn post", "write an announcement", "draft an email", or requests any written material such as blog posts, marketing copy, social media posts, product descriptions, emails, or social media updates.
user-invocable: true
disable-model-invocation: true
model: sonnet
allowed-tools: Write, Edit, Read
---

Always review existing writing in the project before generating new content, then match the established style and tone closely.

## Process

1. **Study existing writing first.** Search the codebase, project and [examples here](./examples) for any existing content — marketing copy, README prose, blog posts, product descriptions, UI text. Use Grep or Read to find it. Never generate without this step.
2. **Extract the voice.** Note the tone (formal/casual, playful/serious), sentence length, vocabulary level, use of punctuation, and how the writing addresses the reader.
3. **Generate new content** that a reader would believe came from the same author as the existing material.
4. **Review your output.** Read it back and ask: does this sound like the existing writing? If not, revise.
5. Consult [personal style guidelines](./references/personal-styles.md) to apply consistent voice rules across all content.

## Style Matching Checklist

Before delivering content, verify:
- [ ] Tone matches (warm, authoritative, playful, etc.)
- [ ] Sentence rhythm matches (short and punchy vs. long and flowing)
- [ ] Vocabulary level matches (technical, accessible, conversational)
- [ ] Point of view matches (first person, second person, brand voice)
- [ ] Formatting conventions match (headers, bullets, paragraph length)

## Content Quality Standards

- **Clear** — every sentence earns its place; cut filler
- **Engaging** — hooks the reader early, maintains momentum
- **Informative** — delivers real value, not vague generalities
- **Audience-resonant** — speaks directly to who will read it

## Output Format

Deliver content ready to use — no meta-commentary around it unless the user asks for explanation. If you produce multiple variants, label them clearly (e.g. **Option A**, **Option B**).
