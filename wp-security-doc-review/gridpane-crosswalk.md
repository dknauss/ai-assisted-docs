# GridPane Security Crosswalk: GP → WordPress Security Documents

This crosswalk maps GridPane's security patterns to our four WordPress security documents:
- Security Benchmark (L1/L2 controls)
- Hardening Guide (enterprise architecture guidance)
- Operations Runbook (procedural, WP-CLI oriented)
- Style Guide (editorial standards and glossary)

GP Topics and Mappings
- Defense-in-depth pattern (edge, server, app)
  - GP: Edge (7G WAF, ModSecurity), Server (Fail2Ban, hardening), App (Fortress).
  - Benchmark: Defends against threat vectors, aligns with CIS-like controls across layers.
  - Hardening Guide: Architecture guidance for multi-layer defense, network-layer protection vs. application-layer controls.
  - Runbook: Procedures to configure WAF, fail2ban, and fortress-related settings on servers.
  - Style Guide: Terminology alignment (defense-in-depth, edge, server, app).
  - References: gridpane.com/kb/security-strategies-and-tools/; gridpane.com/kb/; gridpane.com/fortress/

- Fortress: GP’s must-use plugin for WordPress hardening integrated with the GridPane stack
  - GP: Argon2 hashing, 2FA, login protection, session protection, vaults/pillars, code freeze; lazy-loaded codebase; WP-CLI-first; 1200+ tests; licensing options.
  - Benchmark: Authentication hardening, session management, data protection, and defense-in-depth controls.
  - Runbook: Steps for enabling Fortress, configuring secrets management, and verifying integration with GridPane server stack.
  - Hardening Guide: Architecture-level discussion of Fortress within the deployment model.
  - Style Guide: Glossary terms (argon2, vaults, pillars, code freeze) – ensure consistency across docs.
  - References: gridpane.com/fortress/; gridpane.com/kb/; Fortress content.

- Strengths and caveats (GP):
  - GP: Defense-in-depth across layers; strong QA; performance-conscious; vendor-specific stance for Fortress.
  - Benchmark/Hardening: Strengths align with multi-layer defense and modern cryptography; caveats: vendor-specificity; portability concerns.
  - Runbook: Operational considerations for Fortress updates and integration tests.
  - Style Guide: Editorial labeling and glossary coverage.
  - References: Fortress content; KB entries.

- Editorial implications for WordPress guidance:
  - Treat GP materials as a vendor-specific case study; label Fortress content accordingly.
  - Map GP patterns to non-vendor WP guidance; use cross-links.
  - Ensure cross-document alignment using the standard audit templates and glossary terms.

- Crosswalk artifacts (internal use):
  - Links to GP sources: https://gridpane.com/kb/, https://gridpane.com/knowledgebase/security-strategies-and-tools/, https://gridpane.com/fortress/
  - Links to WP docs in our repo: wp-security-doc-review/rounds/2026-03-03/phase1-benchmark.md; phase1-hardening-guide.md; phase1-runbook.md; phase1-style-guide.md; cross-document-audit-template.md

Notes
- Fortress is a GP product; annotate vendor-specific content in any general WP guidance.
- This crosswalk is intended to support editors during cross-document revision rounds and to guide future governance.
