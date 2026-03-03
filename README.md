# AI-Assisted Documentation Processes

Methodology and process documentation for AI-assisted technical writing and editorial review.

## Purpose

This repository documents the workflows, authority hierarchies, and editorial processes used when frontier LLMs assist with technical documentation — specifically the WordPress security document series maintained by [Dan Knauss](https://dan.knauss.ca).

The goal is transparency: readers of the resulting documents should be able to understand how AI was involved, what guardrails were in place, and where human editorial judgment was applied.

## Documents Produced Under This Process

| Document | Repository | Role |
|---|---|---|
| WordPress Operations Runbook | [wordpress-runbook-template](https://github.com/dknauss/wordpress-runbook-template) | Operational — "how to do it" |
| WordPress Security Benchmark | [wp-security-benchmark](https://github.com/dknauss/wp-security-benchmark) | Audit checklist — "what to verify" |
| WordPress Security Hardening Guide | [wp-security-hardening-guide](https://github.com/dknauss/wp-security-hardening-guide) | Advisory — "what to implement" |
| WordPress Security Style Guide | [wp-security-style-guide](https://github.com/dknauss/wp-security-style-guide) | Editorial — "how to write about it" |

---

## Process: WordPress Security Document Series (2026 Revision)

### Background

These documents originate from a personal effort to collect and collate best practices in WordPress security and security writing, from 2021 to 2025. Maintaining accuracy across four interrelated documents — each with a distinct purpose and audience — requires a significant time investment from technical specialists and generalists alike. As of late 2025, frontier LLMs have become reliable enough to serve as research and drafting assistants when guided and verified by a knowledgeable human. The documents now reflect two layers of history: the original manual synthesis and the current AI-assisted revisions.

### Step 1: Independent Multi-Model Review

Three frontier models (Gemini 2.5 Pro, OpenAI GPT-5.3-Codex-xhigh, and Claude Opus 4) independently reviewed all four documents with identical instructions:

1. **Compare** the four documents against each other for internal consistency.
2. **Identify** factual errors, outdated information, incorrect code samples, and significant misalignments between documents or with authoritative external sources.

Each model produced an independent revision plan. The three plans overlapped substantially but differed in emphasis, severity assessments, and recommended fixes.

### Step 2: Authority Hierarchy

All three models were given the same authority hierarchy for resolving conflicts:

1. **WordPress Advanced Administration Handbook** — specifically the [Security](https://developer.wordpress.org/advanced-administration/security/) and [Hardening](https://developer.wordpress.org/advanced-administration/security/hardening/) sections. Primary authority for WordPress-specific guidance.
2. **WordPress Code Reference and core source** — primary authority for constants, hooks, filters, and function behavior.
3. **Supplemental standards** (MDN, OWASP, CIS) — authority only for non-WordPress-specific topics such as HTTP headers, cryptographic standards, and network hardening.

Any recommendation deviating from the WordPress Handbook is labeled as conditional or environment-specific, with stated rationale.

### Step 3: Synthesis and Critical Review

After personally reviewing all three revision plans, I instructed Claude (the primary working model) to:

- **Compare** the three plans and identify points of agreement and disagreement.
- **Verify** each finding against the actual source files and authoritative references.
- **Synthesize** a single corrected revision plan, flagging any findings that were overclaimed or insufficiently supported.
- **Raise** questionable judgments — cases where the models' recommendations conflicted with WordPress design intent or with each other.

Claude has access to my archive of industry sources, coding standards, WordPress-specific skills, and development tools. It also uses the Style Guide to harmonize voice and tone across all four documents, and to evaluate new material against the Style Guide's editorial philosophy regarding security, vulnerability, and trust in open source.

This process is inherently dialogic — it produces editorial discussion, not just output. Findings are debated, positions are refined, and some recommendations are rejected.

### Step 4: Human Editorial Decision

I (@dknauss) reviewed and approved, modified, or rejected each recommended revision in the final plan before implementation. No change was applied without explicit human approval. The implemented revision plan is archived in the [wp-security-doc-review](https://github.com/dknauss/wp-security-doc-review) working directory.

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
