# AI-Assisted Documentation Processes Applied to WordPress Security

This repository contains a methodology, process documentation, and working scripts for AI-assisted technical writing and editorial review. It includes agent roles, skills, and Behavior-Driven Development (BDD) scenarios for researching, updating, verifying, aligning, and cross-referencing complex technical documents for different audiences and use cases. 

As a working system, `ai-assisted-docs` curates and maintains a series of technical documents about WordPress security contained in four separate repositories, ensuring they remain living documents aligned with current code and industry standards. 

**End-to-end transparency is a key feature.** Readers of the resulting documents should be able to understand how AI was involved, what guardrails were in place, what authority hierarchies were followed, and where human editorial judgment was applied.

## Documents Produced Under This Process

| Document | Repository | Role |
|---|---|---|
| WordPress Operations Runbook | [wordpress-runbook-template](https://github.com/dknauss/wordpress-runbook-template) | Operational — "how to do it" |
| WordPress Security Benchmark | [wp-security-benchmark](https://github.com/dknauss/wp-security-benchmark) | Audit checklist — "what to verify" |
| WordPress Security Hardening Guide | [wp-security-hardening-guide](https://github.com/dknauss/wp-security-hardening-guide) | Advisory — "what to implement" |
| WordPress Security Style Guide | [wp-security-style-guide](https://github.com/dknauss/wp-security-style-guide) | Editorial — "how to write about it" |

## Agent Skills

This repository includes the editorial agent skills used in the WordPress document workflow. These live in [`wp-docs-skills/`](wp-docs-skills/) and serve as both process transparency and reusable machine-readable guidance for AI-assisted edits. See the [skills index](wp-docs-skills/README.md) for usage instructions.

## Behavioral Scenarios

The [`scenarios/`](scenarios/) directory contains Given/When/Then behavioral specifications for each skill. These turn the acceptance criteria in [AGENTS.md](AGENTS.md) section 6 and each skill's `SKILL.md` done criteria into testable expectations with concrete pass/fail examples. During editorial review, check AI-generated output against the applicable scenarios before accepting it. See the [scenarios index](scenarios/README.md) for format, usage, and [test run results](scenarios/README.md#test-runs).

| Skill | AGENTS.md Agents | Primary Use |
|---|---|---|
| [`wordpress-runbook-ops`](wp-docs-skills/wordpress-runbook-ops/SKILL.md) | @RunbookAgent | Create, revise, and validate WordPress operational runbooks with deterministic WP-CLI procedures, verification, rollback, and escalation. |
| [`wordpress-security-doc-editor`](wp-docs-skills/wordpress-security-doc-editor/SKILL.md) | @BenchmarkAgent, @HardeningGuideAgent, @StyleGuideAgent, @AuditAgent, @SynthesisAgent | Draft, fact-check, and audit WordPress security documentation against authority hierarchy and cross-document consistency rules. |
| [`security-researcher`](wp-docs-skills/security-researcher/SKILL.md) | @SecurityResearcher | Produce internal, source-grounded briefs about vendor-specific WordPress security products or hosting guidance. |

The skills are the machine-readable counterparts to the editorial agent roles defined in [AGENTS.md](AGENTS.md). Each skill's `SKILL.md` contains the constraints, output templates, and done criteria that an LLM needs to produce work matching the editorial standards. The `agents/` subdirectories contain platform-specific config stubs for Claude and OpenAI.

---

## Metrics and Revision Tracking

Each downstream document repo maintains two tracking files:

- **`docs/current-metrics.md`** — canonical architectural counts (sections, controls, glossary terms, WP-CLI commands, code fences, etc.) with runnable verification commands. Updated after every structural edit.
- **`CHANGELOG.md`** — revision history. Updated after every substantive change.

This repo's [`docs/current-metrics.md`](docs/current-metrics.md) aggregates key counts across all four downstream repos and tracks editorial project-level facts (scenario files, phases, research subjects).

The [AGENTS.md](AGENTS.md) workflow (sections 5.1 and 5.2) includes metrics verification and changelog update steps at the end of every drafting and revision round.

---

## Remote Rebuilds

The easiest remote rebuild path for the four canonical security documents is the existing `workflow_dispatch` entry point on each downstream repo's `Generate PDF, Word & EPUB Documents` workflow. That workflow rebuilds only the single primary Markdown file in each repo and preserves the required pipeline:

`Markdown -> DOCX -> PDF/EPUB`

In the GitHub web UI:

1. Open the downstream repo's `Actions` tab.
2. Select `Generate PDF, Word & EPUB Documents`.
3. Click `Run workflow`.
4. Choose `main` and run it.

From a remote shell with GitHub CLI:

```bash
gh workflow run generate-docs.yml --repo dknauss/wp-security-benchmark
gh workflow run generate-docs.yml --repo dknauss/wp-security-hardening-guide
gh workflow run generate-docs.yml --repo dknauss/wordpress-runbook-template
gh workflow run generate-docs.yml --repo dknauss/wp-security-style-guide
```

This repository does not yet provide a single orchestration command or parent workflow to trigger all four rebuilds at once. That is tracked as backlog work in [.planning/ROADMAP.md](.planning/ROADMAP.md).

---

## Process: WordPress Security Document Series

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

## Sources and Tools

### Primary Authorities

These are the sources the [authority hierarchy](AGENTS.md#3-authority-hierarchy) draws on. When sources conflict, higher-numbered sources defer to lower-numbered ones.

| Priority | Source | Role |
|---:|---|---|
| 1 | [WordPress Developer Documentation](https://developer.wordpress.org/) | Primary authority for all WordPress-specific guidance. Key subsections: [Security](https://developer.wordpress.org/advanced-administration/security/), [Hardening](https://developer.wordpress.org/advanced-administration/security/hardening/). |
| 2 | [WordPress Code Reference](https://developer.wordpress.org/reference/) and [core source](https://core.trac.wordpress.org/browser/trunk) | Primary authority for constants, hooks, filters, and function behavior. |
| 3 | [WP-CLI Documentation](https://developer.wordpress.org/cli/commands/) | Primary authority for command syntax and flags. |
| 4 | [OWASP](https://owasp.org/), [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks), [NIST SP 800-63B](https://pages.nist.gov/800-63-4/sp800-63b.html), [MDN](https://developer.mozilla.org/) | Authority for non-WordPress-specific topics (HTTP headers, cryptographic standards, network hardening). |

### Verification and Research Tools

| Tool | Purpose |
|---|---|
| [Veloria](https://veloria.dev/) | MCP server for verifying plugin hooks, functions, and CLI commands against actual plugin source code on WordPress.org. Used when `wp help` is insufficient. |
| [WordPress.org Plugin API](https://api.wordpress.org/plugins/info/1.2/) | Active install counts, version numbers, and metadata for WordPress.org plugins. |
| [WordPress.org SVN](https://plugins.svn.wordpress.org/) | Plugin source code verification against live trunk. |

### Threat Intelligence and Industry Data

| Source | Use |
|---|---|
| [Patchstack](https://patchstack.com/) | WordPress vulnerability intelligence and annual security reports. Primary source for WordPress-specific vulnerability statistics. |
| [Verizon DBIR](https://www.verizon.com/business/resources/reports/dbir/) | Cross-industry breach data and threat patterns. |
| [IBM Cost of a Data Breach](https://www.ibm.com/reports/data-breach) | Economic impact data for breach analysis. |

### Vendor Research

| Vendor | Context |
|---|---|
| [GridPane](https://gridpane.com/) | First vendor research subject. Used to develop the vendor-editorial separation methodology. Research artifacts: [`wp-security-doc-review/`](wp-security-doc-review/). |
| [WordPress VIP](https://wpvip.com/) | Enterprise WordPress hosting standards and coding practices. Reference for enterprise-grade security expectations. |

### Editorial Methodology

| Resource | Notes |
|---|---|
| Tom Johnson, [10 Principles of the Cyborg Technical Writer](https://idratherbewriting.com/blog/10-principles-of-cyborg-technical-writer) | Framework for human-AI editorial collaboration. |
| [CIS Benchmark format](https://www.cisecurity.org/cis-benchmarks) | Structural model for the Security Benchmark document (Profile Applicability, Audit, Remediation). |
| [Runbook conventions](https://github.com/runbear-io/awesome-runbook) (Atlassian, Google SRE, PagerDuty) | Structural models for the Operations Runbook. |

## Contributors

- [Dan Knauss](https://dan.knauss.ca) — author, general editor
- [Claude](https://claude.ai) (Anthropic) — primary working model: research, drafting, revision, cross-document audit, synthesis
- [Gemini](https://gemini.google.com) (Google) — independent review and revision planning
- [GPT-5 Codex](https://openai.com) (OpenAI) — independent review and revision planning

## License

This repository is licensed under the [Creative Commons Attribution-ShareAlike 4.0 International License (CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/).
