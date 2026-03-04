# Pipeline vs. Review Board: Agent Architecture for Documentation Maintenance

A comparison of two multi-agent approaches to technical documentation, prompted by Cherryleaf's April 2024 article on [using multiple AI agents in a technical documentation production workflow](http://www.cherryleaf.com/2024/04/using-multiple-ai-agents-in-a-technical-documentation-production-workflow/).

## Two Models

### The Pipeline Model (Cherryleaf)

Cherryleaf proposes a seven-agent linear chain for producing documentation from scratch:

1. **Content Gathering Agent** — searches codebases, specs, and repositories.
2. **Information Designer Agent** — organizes raw material into structured outlines.
3. **Technical Writer Agent** — drafts user guides, release notes, and help articles.
4. **Editorial Reviewer Agent** — enforces style guides and corrects errors.
5. **Integration Testing Agent** — verifies links, code snippets, and commands.
6. **Formatting Agent** — applies visual design and layout.
7. **Publishing Agent** — packages and distributes.

Each agent hands off to the next. The workflow is sequential with feedback loops between the writer and reviewer.

### The Review Board Model (This Project)

The WordPress security document series uses a different architecture, defined in [AGENTS.md](../AGENTS.md):

- **Multiple models independently review the same material** (Gemini, GPT, Claude).
- A **@SynthesisAgent** merges the independent findings, flags disagreements, and verifies each claim.
- **Document-specific agents** (@BenchmarkAgent, @HardeningGuideAgent, @RunbookAgent, @StyleGuideAgent) implement approved changes within their domain constraints.
- An **@AuditAgent** checks cross-document consistency after changes.
- The **human editor** makes all final decisions.

The key structural difference: the pipeline assumes each stage gets it right and the next stage builds on it. The review board assumes no single reviewer is fully reliable and uses redundancy to catch errors.

## Where the Pipeline Model Falls Short for Maintenance

Cherryleaf's model is designed for content creation — turning source material into finished documentation. The WordPress security series presents a different problem: four existing documents that must stay technically accurate, internally consistent, and aligned with each other across revisions. Three specific gaps in the pipeline model are relevant:

### 1. No Technical Accuracy Verification

Cherryleaf identifies this as an unsolved problem in their own framework. There is no agent responsible for verifying that a WP-CLI command actually exists, that a PHP constant behaves as described, or that a database privilege grant is correct.

The review board model addresses this through multi-model cross-validation. In the March 2026 revision round, one model claimed the OWASP Top 10:2025 had not been published. Another model correctly identified it as published. The @SynthesisAgent caught the discrepancy, verified it, and dropped the incorrect finding. A single-reviewer pipeline would have propagated the error.

### 2. No Style Guide Integration Path

A practitioner quoted in the Cherryleaf article says: "I quickly run out of tokens, and I haven't figured out how to best structure the prompts to have the agents write the text in line with the style guide."

The review board model solves this by making the Style Guide the normative source for all agent behavior. The AGENTS.md file derives its global style and voice rules directly from the Style Guide document. The @StyleGuideAgent is not just a reviewer — it is the authority that the other agents are constrained by. Style compliance is a precondition, not a post-hoc check.

### 3. No Cross-Document Consistency Mechanism

A pipeline that processes one document at a time has no built-in way to detect that the Runbook uses `GRANT ALL PRIVILEGES` while the Benchmark prescribes eight specific privileges, or that the Hardening Guide says PHP 7.2+ for Argon2id while the correct floor is 7.3+. These cross-document contradictions are invisible to a single-document pipeline.

The @AuditAgent exists specifically for this. It reads all four documents, applies the [cross-document audit template](cross-document-audit-template.md), and produces structured findings that the human editor can act on.

## What the Pipeline Model Does Better

Two ideas from Cherryleaf's framework are worth adopting or considering:

### Integration Testing Agent

Cherryleaf's concept of an agent that verifies links, code snippets, and commands actually function is currently handled manually through the @AuditAgent's WP-CLI verification. A dedicated **@ValidationAgent** could automate this:

- Run `wp help <command>` against every WP-CLI command in the Runbook and Benchmark.
- Check that URLs in References sections resolve (HTTP 200).
- Verify that PHP constants exist in the WordPress source for the stated version.
- Validate that `grep` patterns in audit commands use correct syntax (ERE vs. BRE).

This would tighten the feedback loop from "audit finding → manual verification → fix" to "automated validation → fix."

### Formatting and Publishing as an Explicit Agent Concern

The `generate-docs.yml` workflow (Pandoc → PDF/DOCX/EPUB, date injection, version display) is currently treated as infrastructure. Cherryleaf's Formatting and Publishing agents suggest that output pipeline configuration could be owned by an agent role — a **@PublishingAgent** responsible for ensuring the eisvogel template, fonts, output formats, and release tagging stay consistent across all four repos.

Whether this warrants an agent role or remains infrastructure is a judgment call. The argument for an agent: when the YAML frontmatter, PDF defaults, or workflow configuration drifts between repos, an agent role creates accountability for catching it. The argument against: the workflow files are already identical across repos and rarely change.

## Cherryleaf's Pragmatic Conclusion

The article ends by suggesting that for most teams, adopting existing help authoring tools with embedded AI provides "90% of the benefits of AI, without all the time and cost associated with developing an Agentic AI system."

This is reasonable advice for most documentation projects. The WordPress security series is an exception because:

- Four interrelated documents must cross-reference and agree on technical details.
- Domain-specific validation requirements (WP-CLI commands, WordPress constants, PHP version floors) are not handled by any off-the-shelf tool.
- The multi-model review process catches errors that no single model reliably avoids.
- The documents serve audiences ranging from sysadmins to communicators, requiring distinct personas within a shared voice.

The complexity of the agent architecture is justified by the complexity of the problem. For a single document with a single audience, a simpler approach would be appropriate.

## Summary

| Dimension | Pipeline (Cherryleaf) | Review Board (This Project) |
|---|---|---|
| **Primary use case** | Creating new documentation | Maintaining existing documentation |
| **Error handling** | Sequential — each stage trusts the previous | Redundant — multiple reviewers, cross-validation |
| **Style enforcement** | Post-hoc review (unsolved) | Normative constraint from Style Guide |
| **Cross-document consistency** | Not addressed | Dedicated @AuditAgent with structured checklist |
| **Technical verification** | Identified as a gap | Multi-model cross-validation + authority hierarchy |
| **Publishing** | Explicit agent role | Infrastructure (CI workflow) |
| **Human role** | Unclear | All final decisions; no change without approval |

## References

- Ellis Pratt, "Using Multiple AI Agents in a Technical Documentation Production Workflow," Cherryleaf, April 2024. [cherryleaf.com](http://www.cherryleaf.com/2024/04/using-multiple-ai-agents-in-a-technical-documentation-production-workflow/)
- [AGENTS.md](../AGENTS.md) — Agent configuration for this project.
- [PROCESS-SUMMARY.md](PROCESS-SUMMARY.md) — How the multi-model editorial process works in practice.
