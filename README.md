# AI-Assisted Documentation Processes

Methodology and process documentation for AI-assisted technical writing and editorial review.

## Purpose

This repository documents the workflows, authority hierarchies, and editorial processes used when frontier LLMs assist with technical documentation — specifically the WordPress security document series described below. 

The goal is transparency: readers of the resulting documents should be able to understand how AI was involved, what guardrails were in place, and where human editorial judgment was applied.

## Documents Produced Under This Process

| Document | Repository | Role |
|---|---|---|
| WordPress Operations Runbook | [wordpress-runbook-template](https://github.com/dknauss/wordpress-runbook-template) | Operational — "how to do it" |
| WordPress Security Benchmark | [wp-security-benchmark](https://github.com/dknauss/wp-security-benchmark) | Audit checklist — "what to verify" |
| WordPress Security Hardening Guide | [wp-security-hardening-guide](https://github.com/dknauss/wp-security-hardening-guide) | Advisory — "what to implement" |
| WordPress Security Style Guide | [wp-security-style-guide](https://github.com/dknauss/wp-security-style-guide) | Editorial — "how to write about it" |

## Agent Skills

This repository includes local snapshots of the editorial agent skills used in the WordPress document workflow. These live in [`wp-docs-skills/`](wp-docs-skills/) and are intended as process transparency and reusable guidance for future edits.

| Skill | Link | Primary Use |
|---|---|---|
| WordPress Runbook Ops | [`wordpress-runbook-ops/SKILL.md`](wp-docs-skills/wordpress-runbook-ops/SKILL.md) | Create, revise, and validate WordPress operational runbooks with deterministic WP-CLI procedures, verification steps, rollback paths, and escalation criteria. |
| WordPress Security Doc Editor | [`wordpress-security-doc-editor/SKILL.md`](wp-docs-skills/wordpress-security-doc-editor/SKILL.md) | Draft and fact-check WordPress security documentation (benchmark, hardening, runbook, style guidance) against authority hierarchy and cross-document consistency rules. |

---

## Process: WordPress Security Document Series (2026 Revision)

### Background

These documents originate from a personal effort to collect and collate best practices in WordPress security and security writing from 2021 to 2025. Maintaining accuracy across four interrelated documents — each with a distinct purpose and audience — requires a significant time investment from technical specialists and generalists alike. As of late 2025, frontier LLMs have become reliable enough to serve as research and drafting assistants when guided and verified by a knowledgeable human. The documents now reflect two layers of history: the original manual synthesis and the current AI-assisted revisions.

- The **Style Guide** remains the most original and uniquely "human" text, as it should, in its first sections, where the most subjective matters (values, ethics, taste, voice, and style) are defined. This document dates back to a side project the author/editor began while working on a WordPress security product team. There's not much reason for this foundational mission/vision-type material to change, except to improve it (e.g., more storytelling and concrete examples) and adjust LLM output by influencing or aligning directives to agents with `AGENTS.md` and `SKILL.md` files. The rest is much more objective, boilerplate material. Producing a glossary keyed to a range of evolving documents, like the following three, is easy for editorial agents. 

- The **Security Benchmark** and **Runbook** (two documents) are the most generative or "original" machine-generated texts intended for both humans and machines. As an audit tool, benchmarks are for testing. As operational maintenance and emergency response tools, runbooks are for automated processes and quick responses. The idea of using CIS Benchmarks as a template adapted to WordPress emerged in the OWASP Slack community's `#wordpress` channel several years ago. [Runbook templates](https://github.com/runbear-io/awesome-runbook) are a similar standard reference in enterprise contexts where many good models exist.
  
- The **Security Hardening Guide** started as an unofficial update and modernization to one major source, the _WordPress Security Whitepaper_ from wordpress.org. This is the most "mongrel" or hybridized document, where editorial agents verified, corrected, updated, and augmented the older, existing source by reference to general and specialized industry sources on the open web and my own archives. Ultimately, this was shaped into an original document that aligned with the other three sources noted above, in terms of context-appropriate agreement and deviation, gap-filling, style and formatting (code examples), and time-bound updates from authoritative sources they all draw on.

As these documents evolve together, they should continue to harmonize in style and substance while respecting their different audiences and purposes. 

The following steps generally describe the most in-depth version of the evolving process I've used for multi-agent editorial collaboration.

### Step 1: Independent Multi-Model Review

Three frontier models (Gemini 2.5 Pro, OpenAI GPT-5.3-Codex-xhigh, and Claude Opus 4.6) independently reviewed all four documents with identical instructions:

1. **Compare** the four documents against each other for internal consistency.
2. **Identify** factual errors, outdated information, incorrect code samples, and significant misalignments between documents or with authoritative external sources.

Each model produced an independent revision plan. The three plans overlapped substantially but differed in emphasis, severity assessments, and recommended fixes.

### Step 2: Authority Hierarchy

All three models were given the same authority hierarchy for resolving conflicts:

1. **WordPress Developer Documentation** and key subsections, such as the Advanced Administration Handbook, and the [Security](https://developer.wordpress.org/advanced-administration/security/) and [Hardening](https://developer.wordpress.org/advanced-administration/security/hardening/) subsections. Primary authority for WordPress-specific guidance.
2. **WordPress Code Reference and core source**. Primary authority for constants, hooks, filters, and function behavior.
3. **Supplemental standards**, such as MDN, OWASP, and CIS. Authorities only for non-WordPress-specific topics such as HTTP headers, cryptographic standards, and network hardening. A separate archive of collated data and statistics from annual reports on infosec topics was developed separately and used as a supplemental authoritative resource (by reference to the original sources) in the domain of threat modeling. 

Any recommendation deviating from the WordPress Handbook or other authoritative sources is flagged and examined. Usually, these need to be labeled as conditional or environment-specific, with a stated rationale and appropriate citations and cross-references, to avoid confusing readers with apparent contradictions.

### Step 3: Synthesis and Critical Review

After personally reviewing all three revision plans, the general editor instructed Claude (the primary working model) to:

- **Compare** the three plans and identify points of agreement and disagreement.
- **Verify** each finding against the actual source files and authoritative references.
- **Synthesize** a single corrected revision plan, flagging any findings that were overclaimed or insufficiently supported.
- **Raise** questionable judgments — cases where the models' recommendations conflicted with WordPress design intent or with each other.

Claude has access to my archive of industry sources, coding standards, WordPress-specific skills, and development tools. It also uses the Style Guide to harmonize voice and tone across all four documents, and to evaluate new material against the Style Guide's editorial philosophy regarding security, vulnerability, and trust in open source.

This process is inherently dialogic — it produces editorial discussion, not just output. Findings are debated, positions are refined, and some recommendations are rejected.

### Step 4: Human Editorial Decision

I (@dknauss), acting general editor, reviewed and approved, modified, or rejected each recommended revision in the final plan before implementation. No change was applied without explicit human approval. The implemented revision plan is archived in the [wp-security-doc-review](https://github.com/dknauss/wp-security-doc-review) working directory. 

### Guardrails: Acceptance Criteria

- No unsupported/deprecated constants remain in examples.
- No code samples contradict WordPress core semantics.
- Same control has the same baseline/optional classification across all four docs.
- Every major recommendation has a WordPress developer doc citation.
- Plan-only phase completed without changing source documents.

### What This Process Does Not Do

- **It does not replace domain expertise.** The human editor must be able to evaluate whether a model's recommendation is correct. LLMs are useful here because verification is fast — you can check a WordPress constant against the code reference in seconds.
- **It does not guarantee correctness.** Every model produced at least one finding that was overclaimed or imprecisely diagnosed. Multi-model review reduces this risk but does not eliminate it.
- **It does not remove the need for community review.** Pull requests, issues, and external feedback remain essential.

---

## License

This repository is licensed under the [Creative Commons Attribution-ShareAlike 4.0 International License (CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/).
