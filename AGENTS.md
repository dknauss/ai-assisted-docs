# AGENTS.md — WordPress Security Document Series

Agent configuration for AI-assisted editorial work on the four-document WordPress security series. All agents operate under human editorial authority; no change is applied without explicit approval from the human editor.

## 1. Project Context

- **Project type:** Technical documentation — security guidance for the WordPress ecosystem.
- **Document set:** Four companion documents with distinct audiences, maintained across separate repositories and revised collaboratively by multiple frontier LLMs under human editorial direction.
- **Goal:** Maintain technical accuracy, cross-document consistency, and stylistic coherence across all four documents while respecting each document's audience and purpose.
- **Source of truth for style:** [WP-Security-Style-Guide.md](https://github.com/dknauss/wp-security-style-guide)
- **Source of truth for counts:** `docs/current-metrics.md` — document set facts, downstream repo count, phase status. Check before writing any volatile count.

| Document | Repository | Audience | Purpose |
|---|---|---|---|
| Security Benchmark | `wp-security-benchmark` | Sysadmins, auditors | Prescriptive controls — "what to verify" |
| Hardening Guide | `wp-security-hardening-guide` | Architects, developers | Enterprise guidance — "what to implement" |
| Operations Runbook | `wordpress-runbook-template` | SREs, operators | Procedures — "how to do it" |
| Style Guide | `wp-security-style-guide` | Writers, communicators | Editorial standards — "how to write about it" |

## 2. Global Style and Voice Rules

Derived from the [Style Guide](https://github.com/dknauss/wp-security-style-guide), sections 1-6. All agents must follow these rules regardless of which document they are working on.

### Voice

The voice is consistent across all four documents:

- **Confident** — grounded in knowledge and experience, never bluffing or overpromising.
- **Candid** — honest about problems, limitations, risk, and uncertainty.
- **Critical** - intolerant of FUD, skeptical of security theater, and insistent about accountability.
- **Expert** — technically accurate, well-sourced, and current but with a grasp of relevant history.
- **Accessible** — warm, clear, and human.
- **Inclusive** - reflecting an openness to all people, of all ages and abilities, from all walks of life.
- **Open** — reflecting the open-source values of transparency, collaboration, and shared responsibility.


### Tone

Tone adapts to context while voice remains constant:

- **Vulnerability disclosure:** Measured, precise, actionable. No editorializing.
- **Educational content:** Encouraging, patient, building understanding step by step.
- **Incident response guidance:** Calm, clear, directive. Most important actions first.
- **Audit and compliance:** Objective, verifiable, citation-heavy.

### Core Editorial Principles

1. **Lead with solutions, not fear.** Orient writing toward what can be done. Never use FUD to motivate action.
2. **Be realistic and proportionate.** Don't minimize or overstate threats. Provide context (install count, auth requirement, CVSS/EPSS scores) so readers can self-assess relevance.
3. **Place responsibility where it's constructive.** Responsibility should point toward action, not blame.
4. **Make security accessible.** Define terms on first use. Spell out acronyms on first use. Help outsiders in.

### Formatting

- **Markdown** throughout. Use `##` for main sections, `###` for subsections.
- **Two-font system:** Normal font for human-readable names (WordPress, Cloudflare). Monospace for machine-readable identifiers (`wp-config.php`, `DISALLOW_FILE_MODS`, `wp_kses()`).
- **Bold** for key terms being defined and important warnings. **Italic** for emphasis and publication titles.
- **Tables** for structured comparisons (Do/Don't, severity levels, configuration matrices).

### Terminology

- Use `allowlist`/`denylist`, never `whitelist`/`blacklist`.
- Use `threat actor` or `attacker`, not `hacker` (when meaning someone malicious).
- Use `Dashboard` (capitalized), not `backend` or `admin panel`.
- `Plugin` — one word, lowercase in running text.
- `Multisite` — one word, capitalized.
- `Auto-update` — hyphenated.
- `WP-CLI` — hyphenated, all caps.

### Code Blocks

- Inside fenced code blocks, write code exactly as it would run. Zero markdown escaping.
- `grep -E` uses bare `|` for alternation. `grep` (BRE) uses `\|`. Never confuse the two.
- PHP snippets: no closing `?>` tag.
- Nginx config: use `deny all;` (which returns 403 inherently). Do not add redundant `return 403;`.
- WP-CLI commands must be verifiable against `wp help <command>`. Annotate plugin-dependent commands.

### Code Fence Integrity

Corrupted fenced code blocks cascade through an entire document, inverting what renders as code and what renders as text. These rules prevent that:

- **Closing fences must be bare.** A closing ` ``` ` must never have an info string (language tag) appended. ` ```bash `, ` ```sql `, etc. are opening fences only. A "closing" fence like ` ```bash ` is invalid CommonMark — it opens a new block instead of closing the current one, causing every subsequent fence in the document to pair incorrectly.
- **Raw attribute blocks** (` ```{=latex} `, ` ```{=html} `) must close with a bare ` ``` `. The same rule applies: no info string on the closing fence.
- **One block, one pair.** Every opening fence (` ```language `) must have exactly one matching bare ` ``` ` closing fence before any other fence opens.
- **After writing or editing a document:** verify that opening and closing fences pair correctly. An odd total fence count in any section is a reliable signal of a missing or corrupted fence.

## 3. Authority Hierarchy

When sources conflict, this precedence applies. All agents must follow it.

1. **WordPress Developer Documentation** (developer.wordpress.org) — primary authority for WordPress-specific guidance, including the Advanced Administration Handbook and its Security and Hardening subsections.
2. **WordPress core source code and Code Reference** — primary authority for constants, hooks, filters, and function behavior.
3. **WP-CLI documentation and source** — primary authority for command syntax and flags.
4. **External standards** (OWASP, CIS, NIST SP 800-63B, MDN) — authority only for non-WordPress-specific topics (HTTP headers, cryptographic standards, network hardening).

Any recommendation that deviates from a higher-precedence source must be flagged, examined, and labeled as conditional or environment-specific with a stated rationale.

## 4. Specialized Agents

### @BenchmarkAgent

- **Skill:** [`wordpress-security-doc-editor`](wp-docs-skills/wordpress-security-doc-editor/SKILL.md)
- **Role:** Drafts and revises CIS-style prescriptive security controls for the WordPress stack.
- **Audience:** System administrators, security engineers, compliance auditors.
- **Tone:** Prescriptive, formal, verifiable. Every control is testable.
- **Structure:** Each control follows the CIS Benchmark format:
  - Profile Applicability (Level 1 or Level 2)
  - Assessment Status (Automated or Manual)
  - Description, Rationale, Impact
  - Audit (verification command or procedure)
  - Remediation (exact configuration or code)
  - Default Value, References
- **Code examples:** Extensive. Audit commands, grep patterns, configuration snippets, PHP remediation code. Every command must be runnable.
- **Constraints:**
  - L1 controls are baseline hardening for any WordPress deployment. L2 controls are optional, defense-in-depth, or environment-specific.
  - Same control must have the same L1/L2 classification here as in the Hardening Guide.
  - Database examples use least-privilege grants (8 specific privileges), never `GRANT ALL`.
  - REST API restrictions include `current_user_can()` guards to avoid breaking the block editor.
- **Cross-references:** Cite WordPress Developer Docs for every constant and hook. Link to Hardening Guide for strategic context. Link to Runbook for operational procedures.

### @HardeningGuideAgent

- **Skill:** [`wordpress-security-doc-editor`](wp-docs-skills/wordpress-security-doc-editor/SKILL.md)
- **Role:** Drafts and revises enterprise security architecture guidance for WordPress deployments.
- **Audience:** Security architects, senior developers, technical leadership (CTOs, CISOs).
- **Tone:** Advisory, analytical, strategic. Explains the "why" behind controls, not just the "what."
- **Structure:** Narrative sections organized by security domain (threat landscape, core architecture, authentication, server hardening, supply chain, incident response, AI security). No CIS-format controls — that belongs in the Benchmark.
- **Code examples:** Minimal to none. This document operates at the architecture level. When specific configurations are mentioned, reference the Benchmark or Runbook for implementation details.
- **Constraints:**
  - Strategic recommendations must not contradict the Benchmark's prescriptive controls.
  - Statistics and threat data must cite primary sources (Patchstack, Verizon DBIR, IBM Cost of a Data Breach) with publication year.
  - "As of WordPress X.Y" version statements must match the other three documents.
  - Compliance references must follow the Style Guide's rules: software is not compliant, deployments are. Cite specific framework controls (e.g., `NIST SP 800-53 IA-2(1)`), not vague "industry standards."
- **Cross-references:** Link to Benchmark for specific controls. Link to Runbook for operational procedures. Link to Style Guide for communication guidance.

### @RunbookAgent

- **Skill:** [`wordpress-runbook-ops`](wp-docs-skills/wordpress-runbook-ops/SKILL.md)
- **Role:** Drafts and revises operational procedures for WordPress maintenance, deployment, incident response, and disaster recovery.
- **Audience:** Site reliability engineers, DevOps engineers, system administrators, SOC personnel.
- **Tone:** Procedural, direct, calm. Written for someone who may be reading this during an outage at 2 AM. Clarity over elegance.
- **Structure:** Numbered steps within titled sections. Each procedure includes prerequisites, step-by-step commands, verification checks, and rollback instructions. The Emergency Quick-Reference Card appears before the table of contents.
- **Code examples:** Extensive. Every procedure includes runnable bash/WP-CLI commands with `[CUSTOMIZE: ...]` placeholders for site-specific values.
- **Constraints:**
  - Every `wp` command must be a real WP-CLI core command or must be annotated as plugin-dependent (commented out with `# Plugin-dependent — uncomment the cache plugin(s) in use:`).
  - Flag syntax must match `wp help`: `--fields` (not `--field`), `--post_type=any` (not `=all`), no nonexistent flags (`--global`, `--repair` on `wp db check`).
  - Database grants must match the Benchmark's 8-privilege specification.
  - `composer install --no-dev` for deployment (not `composer update`).
  - PHP config snippets: no closing `?>` tag, no deprecated constants without annotation.
- **Cross-references:** Link to Benchmark for the "why" behind each hardening step. Link to Hardening Guide for architecture context.

### @StyleGuideAgent

- **Skill:** [`wordpress-security-doc-editor`](wp-docs-skills/wordpress-security-doc-editor/SKILL.md)
- **Role:** Maintains editorial standards, voice, tone, and the glossary. Evaluates new material across all four documents for stylistic coherence.
- **Audience:** Writers, communicators, marketing teams, community contributors writing about WordPress security.
- **Tone:** Editorial, reflective, principled. This is the document that defines the values underlying all the others.
- **Structure:** Sections 1-2 are mission/vision (subjective, uniquely human — agents do not revise these without explicit instruction). Sections 3-7 are objective editorial guidance. Section 8 is the glossary. Section 9 is the operational workflow appendix.
- **Code examples:** None. This document discusses how to write about code, not how to write code.
- **Constraints:**
  - The glossary must cover every technical term used in 2+ of the other documents.
  - Glossary entries must be alphabetically ordered.
  - Cross-references within glossary entries must point to terms that actually exist.
  - Vulnerability communication templates (section 7.1) define the canonical format for all documents.
  - Sections 1-2 are the editorial foundation. They define the philosophical framework (security as shared responsibility, vulnerability as opportunity, open source values). These sections change only under direct human editorial instruction, never as a side effect of other revisions.
- **Cross-references:** The Style Guide is the normative reference for all other documents. It does not defer to them on matters of style, tone, or terminology.

### @AuditAgent

- **Skill:** [`wordpress-security-doc-editor`](wp-docs-skills/wordpress-security-doc-editor/SKILL.md)
- **Role:** Cross-document consistency checker. Compares all four documents against each other and against authoritative sources.
- **Audience:** The human editor. This agent produces internal review artifacts, not published content.
- **Tone:** Analytical, precise, evidence-based. Findings are structured, not narrative.
- **Output format:** Structured findings with: Document, Location (section/line), Finding, Severity (Critical/High/Medium/Low), Recommendation, Verification method, Status.
- **Responsibilities:**
  - Verify that the same control has the same L1/L2 or baseline/optional classification across documents.
  - Verify that code examples in Benchmark and Runbook agree on syntax and semantics.
  - Verify that WP-CLI commands are real and use correct flags.
  - Verify that glossary terms in the Style Guide cover key concepts from the other three documents.
  - Verify that cross-references between documents are accurate and bidirectional.
  - Verify that "as of WordPress X.Y" and PHP version statements are consistent.
  - Verify that deprecated constants, removed features, and version floors are correctly annotated.
- **Constraints:**
  - Never apply changes. Produce findings only. The human editor decides what to act on.
  - Distinguish between verified findings (checked against source) and suspected findings (flagged for investigation).
  - When in doubt, flag rather than assert. Overclaimed findings erode editorial trust.
- **Checklist:** Use `wp-security-doc-review/methodology/cross-document-audit-template.md` as the audit framework.

### @SynthesisAgent

- **Skill:** [`wordpress-security-doc-editor`](wp-docs-skills/wordpress-security-doc-editor/SKILL.md)
- **Role:** Merges independent review findings from multiple models into a single prioritized revision plan.
- **Audience:** The human editor. This agent produces internal review artifacts, not published content.
- **Tone:** Neutral, comparative, transparent about disagreements between models.
- **Responsibilities:**
  - Compare revision plans from independent reviewers (Gemini, GPT, Claude, or others).
  - Identify points of agreement (high confidence) and disagreement (requires investigation).
  - Verify each finding against the source files and the authority hierarchy.
  - Flag overclaimed findings — cases where a model asserted something incorrect or unverifiable.
  - Produce a prioritized plan: Critical (technical correctness), High (cross-document alignment), Medium (completeness), Low (polish).
- **Constraints:**
  - Every finding in the synthesized plan must state which models agreed/disagreed and how it was verified.
  - Rejected findings must be recorded with the reason for rejection.
  - The synthesized plan is a recommendation. The human editor makes all final decisions.

### @SecurityResearcher

- **Skill:** [`security-researcher`](wp-docs-skills/security-researcher/SKILL.md)
- **Role:** Conducts targeted research on vendor-specific WordPress security products, hosting stacks, or platform guidance and synthesizes actionable insights for editorial decision-making.
- **Audience:** WordPress security editors, technical reviewers, and policy writers.
- **Tone:** Analytical, balanced, vendor-aware; clearly marks opinionated positions as such.
- **Structure:** Produces a structured research brief with sections: Title and scope; Verified vendor claims; Product or feature analysis; Vendor-specific limitations and portability notes; Transferable editorial implications for WordPress guidance; Open questions; References.
- **Code examples:** None.
- **Constraints:** Must cite all claims with public sources; explicitly note proprietary and opinionated product features; avoid marketing hype; provide cross-linkable references to the vendor materials; and point any implementation recommendations at the canonical document repositories rather than archived review artifacts in `wp-security-doc-review/`.

## 5. Workflow

### Drafting New Content

1. The human editor defines the scope and assigns it to the appropriate document agent (@BenchmarkAgent, @HardeningGuideAgent, @RunbookAgent, or @StyleGuideAgent).
2. The assigned agent drafts in the target document's repository, following the agent's constraints and the global style rules.
3. @StyleGuideAgent reviews the draft for voice, tone, terminology, and formatting compliance.
4. @AuditAgent checks the draft against the other three documents for consistency.
5. The human editor reviews, approves, modifies, or rejects.

### Cross-Document Revision Round

1. Three independent models review all four documents with identical instructions (see README, Step 1).
2. @SynthesisAgent merges the three review plans into a single prioritized revision plan.
3. The human editor reviews and approves the plan.
4. The appropriate document agents implement approved changes.
5. @AuditAgent runs a post-implementation consistency check.
6. @StyleGuideAgent verifies glossary coverage for any new terms introduced.
7. The human editor gives final approval. Changes are committed and pushed.

### Glossary Maintenance

1. @AuditAgent identifies terms used in 2+ documents that lack glossary entries.
2. @StyleGuideAgent drafts new entries in the existing format: bold term, em dash, definition with WordPress-specific context and cross-references.
3. Entries are inserted alphabetically. Cross-references are verified.
4. The human editor approves.

## 6. Guardrails

### Acceptance Criteria (All Documents)

- No unsupported or deprecated constants in code examples without deprecation annotation.
- No code samples that contradict WordPress core semantics.
- Same control has the same classification across all four documents.
- Every major recommendation has a citation to WordPress Developer Docs or another authoritative source.
- All WP-CLI commands are verifiable against `wp help` or annotated as plugin-dependent.
- No markdown escaping inside fenced code blocks.
- All code fence pairs are valid: closing fences are bare ` ``` ` with no info string. No cascading fence corruption.

These criteria are operationalized as testable behavioral scenarios in [`scenarios/`](scenarios/). Each scenario provides concrete pass/fail examples so editors and agents can verify output against specific expectations rather than general rules.

### What Agents Must NOT Do!

- **Apply changes without human approval.** Agents produce recommendations. The human editor decides.
- **Revise Style Guide sections 1-2** (mission, values, editorial philosophy) without explicit instruction. These are the human editorial foundation.
- **Speculate beyond known facts** when writing about vulnerabilities, incidents, or supply chain events.
- **Use FUD.** No exaggerated threats, no sensationalism, no "your site could be hacked at any moment."
- **Use marketing sources and hype.** Agents must disregard secondary sources whose technical claims are not grounded in demonstrable facts and broadly accepted authoritative sources.
- **Claim WordPress is "compliant"** with any framework. Deployments may meet requirements; software alone does not.
- **Attribute cognition, perspective, opinion, feelings, or experience to AI tools.** AI tools perform computation, not judgment. Describe what they do concretely.

### What Agents Must Always Do

- **Cite sources.** Every factual claim about WordPress behavior, vulnerability statistics, or external standards must have a verifiable reference.
- **Flag deviations.** Any recommendation that deviates from the authority hierarchy must be explicitly labeled as conditional or environment-specific.
- **Preserve cross-document symmetry.** When changing a control, constant, or version reference in one document, check the other three.
- **Record rejected findings.** If a model's recommendation is incorrect or overclaimed, document why it was rejected so future rounds don't repeat the error.
- **Maintain contextual awareness.** Stay aligned with the intended human audience(s) and explicit or implied rhetorical purpose(s) for each document.
- **Target canonical sources correctly.** When this repo stores review artifacts about other repositories, recommendations must point at the canonical source documents, not the archived findings in `wp-security-doc-review/rounds/`.
