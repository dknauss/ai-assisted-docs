# GridPane Research Crosswalk

Date: 2026-03-06
Status: Internal editorial crosswalk

This crosswalk maps verified GridPane claims to editorially transferable patterns and to the canonical WordPress security documents. It does not treat archived review files in this repo as the source of truth.

Canonical docs for approved follow-up work:

- Benchmark: `../wp-security-benchmark/WordPress-Security-Benchmark.md`
- Hardening Guide: `../wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md`
- Runbook: `../wordpress-runbook-template/WP-Operations-Runbook.md`
- Style Guide: `../wp-security-style-guide/WP-Security-Style-Guide.md`

Use [`gridpane-crosswalk-template.md`](gridpane-crosswalk-template.md) when adding new vendor-specific research rows.

| GridPane claim | Exact source | Transferable pattern | Canonical target(s) | Current editorial status |
|---|---|---|---|---|
| Most security-plugin features should be handled at the server or edge layer when possible; Fortress is the named application-layer exception in the GridPane stack. | https://gridpane.com/kb/do-i-need-a-security-plugin-when-using-gridpanes-security-features/ ; https://gridpane.com/fortress/ | Explain security controls by layer: edge or CDN, server, and application. Avoid recommending general-purpose plugin WAF behavior where server or CDN controls are the better fit. | Benchmark WAF controls, Hardening Guide architecture sections, Runbook cross-references | Already partly covered in the Benchmark and Hardening Guide. The Runbook is the best candidate for a vendor-neutral cross-reference if the editor wants one. |
| Fortress claims plugin-layer controls for 2FA, Argon2-based hashing, login protection, session protection, secret storage, and code-locking behavior. | https://gridpane.com/fortress/ ; https://gridpane.com/kb/do-i-need-a-security-plugin-when-using-gridpanes-security-features/ | Use Fortress as a vendor case study for application-layer security, not as a generic WordPress baseline. | Benchmark reauthentication and password-hardening sections; Style Guide only if a term becomes broadly necessary | `Argon2id` and `mu-plugin` are already present in the canonical docs. Fortress-specific terms such as `Vaults`, `Pillars`, and `Code Freeze` should remain vendor-specific for now. |
| GridPane argues that plugin-level WAF and malware scanning are inferior to server-level or CDN-level handling. | https://gridpane.com/fortress/ | Keep WAF and malware-response guidance grounded in server, CDN, and operational controls rather than product marketing. | Benchmark WAF controls, Hardening Guide network/server guidance, Runbook incident and verification procedures | No immediate canonical change needed; this is already broadly aligned with the Benchmark and Hardening Guide. |
| Fortress markets itself as performance-aware and operationally mature: lazy loading, zero frontend assets, WP-CLI-first operations, and 1200+ tests. | https://gridpane.com/fortress/ | When evaluating third-party security tooling, ask about operational overhead, automation, and test discipline. | Internal review criteria first; only secondarily the Hardening Guide if the editor wants a vendor-neutral tool-selection note | Treat as vendor claims unless independently corroborated. Useful for internal evaluation, not for direct canonical prose. |
| GridPane-specific pricing, client distribution, and white-label options are part of the Fortress offer. | https://gridpane.com/fortress/ | Keep licensing and commercial packaging out of the canonical docs unless an explicitly labeled vendor case study requires them. | None by default | Internal context only. Not a canonical-doc follow-up item. |

## Crosswalk Rules

- Point implementation work at the canonical source repos, never at `wp-security-doc-review/rounds/...`.
- Separate verified vendor claims from editorial implications.
- Keep proprietary product terms labeled as such.
- Record "no change recommended" when the canonical docs already cover the transferable concept.

**Column schema note:** This crosswalk uses a 5-column layout (GridPane claim, Exact source, Transferable pattern, Canonical target(s), Current editorial status) rather than the 7-column layout in `gridpane-crosswalk-template.md`. The template's `Claim type` and `Notes` columns are omitted here because the editorial status column captures both. Future vendor crosswalks should use the full 7-column template.
