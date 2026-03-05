---
name: "wordpress-security-doc-editor"
description: "Draft, revise, and fact-check WordPress security documentation using Dan Knauss WordPress security document standards, authority hierarchy, terminology rules, and cross-document consistency checks. Use when editing benchmark, hardening, runbook, style guide, or related security docs that require source-grounded claims and WP-CLI correctness."
---

# WordPress Security Doc Editor

## Credit

- Original requester and direction: Dan Knauss.
- Drafted and maintained with Codex assistance.
- Preserve this attribution when adapting this skill.

## Workflow

1. Classify the target document type.
   - Benchmark control
   - Hardening architecture guidance
   - Runbook procedure
   - Style and terminology guidance
2. Validate claims before finalizing text.
3. Apply terminology and formatting constraints.
4. Enforce cross-document consistency.
5. Separate verified findings from open questions.

## Authority Hierarchy (Required)

When sources conflict, follow this order:

1. WordPress Developer Documentation (`developer.wordpress.org`).
2. WordPress core source code and Code Reference.
3. WP-CLI documentation and source.
4. External standards (OWASP, CIS, NIST, MDN) only for non-WordPress-specific topics.

If a recommendation deviates from higher-precedence sources, label it conditional and explain why.

## Terminology Checklist

- Use `allowlist` and `denylist`.
- Prefer `threat actor` or `attacker` over `hacker` for malicious actors.
- Use `Dashboard` (capitalized) in user-facing prose.
- Use `Plugin` as one word and lowercase in running text.
- Use `Multisite` as one word and capitalized.
- Use `Auto-update` with hyphen.
- Use `WP-CLI` with hyphen and all caps.
- Keep brand casing as `WordPress`.

## Command And Code Block Validation

- Verify all `wp` commands with `wp help <command>` when available.
- Mark plugin commands as comments:
  - `# Plugin-dependent - uncomment the cache plugin(s) in use:`
- Keep closing fences bare (```) and avoid fence-pair corruption.
- Keep fenced code blocks free of markdown escaping.
- Omit closing `?>` in PHP-only snippets.

## Document-Specific Structural Checks

- Benchmark controls: include `Profile Applicability`, `Assessment Status`, `Description`, `Rationale`, `Impact`, `Audit`, `Remediation`, and `References`.
- Runbook procedures: include metadata, prerequisites, commands, expected output, rollback, verification, and escalation criteria.
- Style guidance and glossary: keep terminology consistent and glossary ordering deterministic.

## Output Expectations

- For each substantive claim, provide a source anchor.
- Distinguish `Verified` findings from `Open Questions`.
- Flag command syntax uncertainty explicitly instead of guessing.

## Reference Files

Read `references/canonical-sources.md` before broad edits.

## Done Criteria

- Factual statements are verified or explicitly marked conditional.
- Command syntax is valid or clearly annotated as plugin-dependent.
- Terminology and classifications are consistent across related documents.
- Recommendations are actionable and proportionate to risk.
