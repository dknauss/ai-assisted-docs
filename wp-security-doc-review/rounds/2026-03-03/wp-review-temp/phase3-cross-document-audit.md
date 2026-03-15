# Phase 3 — Cross-Document Audit (@AuditAgent, Opus)

Date: 2026-03-03

## Summary

Phase 1 produced 62 findings across four Sonnet agents (17 Benchmark, 12 Hardening Guide, 20 Runbook, 13 Style Guide). Phase 2 produced 78 findings across four Haiku validators (15 WP-CLI commands, 48 code-block lint, 7 glossary coverage, 7 reference URLs), with significant overlap confirming Phase 1.

This Phase 3 audit confirms 51 Phase 1-2 findings, challenges 5 as overclaimed or partially incorrect, and identifies 11 new cross-document issues visible only when comparing all four documents simultaneously.

| Category | Count |
|---|---|
| Phase 1-2 findings confirmed | 51 |
| Phase 1-2 findings challenged | 5 |
| New cross-document findings | 11 |
| **Total actionable findings** | **62** |

**Severity distribution of all actionable findings:**

| Severity | Count |
|---|---|
| Critical | 5 |
| High | 14 |
| Medium | 24 |
| Low | 19 |

---

## Cross-Document Contradictions

These issues span multiple documents and were either missed by single-document agents or require cross-document context to assess properly.

### XD-1. `wp-config.php` permissions: Benchmark vs. Style Guide (High)

**Documents:** Benchmark 6.2 (lines 1439-1454), Style Guide glossary (line 575)

The Benchmark prescribes `400` or `440` as the preferred steady-state permissions for `wp-config.php`, with `600`/`640` as an acceptable minimum when write access is operationally required. The Style Guide glossary entry for `wp-config.php` states: "Should be restricted to file permission `600` or `640`." The Hardening Guide (Section 6.4, line 193) agrees with the Benchmark: "400 or 440 preferred steady-state; 600/640 may be used temporarily."

This is a direct contradiction between the Style Guide and the other two documents. The Style Guide presents `600`/`640` as the recommendation without qualifying it as a minimum or fallback. This was correctly identified by Phase 1 Benchmark Finding #3.

**Recommendation:** Update the Style Guide glossary entry to: "Should be restricted to file permission `400` or `440` (owner/group read-only) as the preferred steady-state; `600` or `640` may be used temporarily when deployment automation requires write access." This aligns with the Benchmark and Hardening Guide.

### XD-2. NIST SP 800-63B revision mismatch (High)

**Documents:** Hardening Guide 15.3 (line 567), Benchmark 5.1/5.5/5.7 (lines 1048, 1224, 1316)

The Benchmark consistently links to NIST SP 800-63B revision 4 (`pages.nist.gov/800-63-4/`). The Hardening Guide links to revision 3 (`pages.nist.gov/800-63-3/`). This was flagged independently by Phase 1 Hardening Guide Finding #2 and Phase 2 Reference URL Finding #1.

**Status:** Confirmed. The Benchmark has the correct URL; the Hardening Guide must be updated.

### XD-3. WordPress Security White Paper URL inconsistency (Medium)

**Documents:** Hardening Guide (lines 44, 550, 607), Style Guide (lines 635, 650), Runbook (line 2955)

The Hardening Guide and Style Guide both label `developer.wordpress.org/apis/security/` as the "WordPress Security White Paper." The Runbook uses `wordpress.org/about/security/` for the same label. The `developer.wordpress.org/apis/security/` URL resolves to developer API documentation (nonces, data validation, escaping), not the Security White Paper. The canonical White Paper has historically been at `wordpress.org/about/security/`.

However, there is a complication: WordPress reorganized its developer documentation significantly in 2024-2025. It is possible that the White Paper content was moved to the developer.wordpress.org domain. This requires human verification before correction.

**Status:** Suspected. Flagged by Phase 1 Hardening Guide Finding #11 and Phase 2 Reference URL Finding #3-4. Requires verification of whether the White Paper content migrated to the new URL.

**Recommendation:** The human editor should visit both URLs and determine which hosts the current White Paper content. Then standardize all three documents to the correct URL.

### XD-4. Version floor discrepancies across documents (Medium)

**Documents:** All four

| Claim | Benchmark | Hardening Guide | Runbook | Style Guide |
|---|---|---|---|---|
| WordPress version | "6.x" (generic) | "6.9 (2026)" (specific) | "6.4+" (placeholder) | No version claim |
| PHP minimum | "8.2+" | "PHP 8.2 security-only; 8.3+ recommended" | "8.1+" (placeholder) and "8.2" (upgrade examples) | No version claim |
| bcrypt default | Not stated (implied 6.8) | "As of WordPress 6.8" (line 76) | Not stated | "since version 6.8" (glossary) |
| Nginx default TLS | "1.23.4+" | Not version-specific | Not version-specific | Not applicable |

The Hardening Guide pins to "version 6.9 (2026)" while the Benchmark covers "WordPress 6.x" generically. This is not a conflict per se (both are accurate), but it means the Hardening Guide makes version-specific claims that the Benchmark does not. The Runbook's "6.4+" and "8.1+" are template placeholders, not version claims.

The PHP floor is the more significant discrepancy: the Runbook's template defaults to "8.1+" which is below the Benchmark's "8.2+" floor and the Hardening Guide's "8.2 in security-only support" language. PHP 8.1 reached end-of-life in November 2025, making it an outdated default for a March 2026 document.

**Recommendation:** Update the Runbook template placeholder from "8.1+" to "8.2+" to match the Benchmark and Hardening Guide. Add a note in the Runbook that the PHP version should match the Benchmark's minimum.

### XD-5. TLS 1.2+ enforcement classification (High)

**Documents:** Benchmark 1.1, Hardening Guide 6.1

The Benchmark classifies TLS 1.2+ enforcement as **Level 2**. The Hardening Guide presents TLS 1.2+ enforcement as a general recommendation without L1/L2 qualification (which is appropriate for an architecture document). However, AGENTS.md requires "Same control must have the same L1/L2 classification here as in the Hardening Guide."

The Hardening Guide's Section 15.6 cross-document matrix does not list TLS classification, and the Hardening Guide does not use L1/L2 terminology at all. This means there is no explicit contradiction, but Phase 1 Benchmark Finding #5 correctly notes that TLS 1.2+ enforcement is universally applicable and the Benchmark's own Default Value section notes that Nginx 1.23.4+ already defaults to TLS 1.2+/1.3. The Hardening Guide treats it as baseline ("Enforce TLS 1.2+" appears in the first bullet of Section 6.1 without qualification).

**Status:** The finding that TLS 1.2+ should be L1 in the Benchmark is well-supported. The Hardening Guide implicitly treats it as baseline. However, since the Hardening Guide does not use L1/L2 terminology, the AGENTS.md cross-document alignment rule does not strictly apply. This is an editorial judgment call.

**Recommendation:** Reclassify Benchmark 1.1 to Level 1 with a note that modern Nginx defaults already enforce this.

### XD-6. REST API user-endpoint restriction: Benchmark vs. Runbook code disagreement (High)

**Documents:** Benchmark 5.4 (lines 1171-1177), Benchmark 5.6 (lines 1262-1268), Runbook 5.4 (lines 601-608)

Three code blocks address the same security objective (restricting the `/wp/v2/users` REST API endpoint) using three different permission guards:

| Location | Guard | Effect |
|---|---|---|
| Benchmark 5.4 | `is_user_logged_in()` | Blocks unauthenticated users; allows any subscriber to enumerate |
| Benchmark 5.6 | `current_user_can('list_users')` | Blocks users without `list_users` capability (correct) |
| Runbook 5.4 | No guard (unconditional `unset`) | Blocks everyone, including the block editor |

The Runbook's unconditional removal is the most aggressive but may break the block editor's user mention/author features. The Benchmark's 5.6 implementation is the most correct per AGENTS.md constraints. This was flagged as Critical by Phase 1 Benchmark Findings #1-2 but the Runbook's divergent implementation was not caught by any Phase 1 agent.

**Recommendation:** Standardize all three to the Benchmark 5.6 implementation (`current_user_can('list_users')`). The Runbook should add the capability check and cross-reference the Benchmark.

### XD-7. Nginx `deny all; return 403;` redundancy (Medium)

**Documents:** Runbook 5.4 (lines 585-588), Runbook 6.6 (lines 1038-1041), Benchmark 4.7 (lines 999-1001), Benchmark 4.4 (lines 862-864)

The Runbook uses `deny all;` followed by `return 403;` in both the `xmlrpc.php` and `wp-cron.php` Nginx blocks. AGENTS.md explicitly states: "Nginx config: use `deny all;` (which returns 403 inherently). Do not add redundant `return 403;`." The Benchmark correctly uses `deny all;` without `return 403;` in both locations.

**Status:** Confirmed. Phase 1 Runbook Finding #7 correctly flagged this.

**Recommendation:** Remove `return 403;` from both Runbook Nginx blocks to match the Benchmark and AGENTS.md.

### XD-8. Database privileges: consistent 8-privilege specification (Verified — No Finding)

**Documents:** Benchmark 3.1 (line 538), Hardening Guide 7.3 (line 234), Runbook 8.2 (line 1459)

All three documents consistently specify the same 8 privileges: SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, DROP. The Runbook's database migration procedure (Section 8.2, line 1459) correctly uses the same GRANT statement. No contradiction found.

### XD-9. HSTS header: `preload` directive inconsistency (Low — New Finding)

**Documents:** Benchmark 1.2 (line 142), Runbook 3.5 (line 259), Runbook 5.3 (line 563)

The Benchmark's HSTS header example uses: `max-age=31536000; includeSubDomains` (no `preload`). The Runbook uses: `max-age=31536000; includeSubDomains; preload` (with `preload`).

The `preload` directive is a significant commitment: it submits the domain to browser HSTS preload lists, which cannot be easily reversed. Including `preload` without explicit organizational approval can create operational issues. The Hardening Guide (Section 6.1) says "Enforce HTTPS for a specified duration (e.g., one year)" without specifying `preload`.

**Status:** New finding. Not caught by any Phase 1 agent.

**Recommendation:** Standardize the HSTS examples. Remove `preload` from the Runbook template or add an explicit note: "Add `preload` only after confirming all subdomains support HTTPS and organizational approval is obtained." The Benchmark's more conservative example (without `preload`) is more appropriate for a default template.

### XD-10. CSP header: `unsafe-eval` in Runbook but not in Benchmark (Low — New Finding)

**Documents:** Benchmark 1.2 (line 150), Runbook 5.3 (line 560)

The Benchmark CSP example uses: `script-src 'self'` (no `unsafe-eval`). The Runbook CSP example uses: `script-src 'self' 'unsafe-inline' 'unsafe-eval' cdn.example.com` (includes `unsafe-eval`).

`unsafe-eval` allows `eval()` and similar constructs in JavaScript, significantly weakening CSP. The Benchmark explicitly notes that for Level 2, "aim to remove `unsafe-inline` by using nonces or hashes." Including `unsafe-eval` in the Runbook template without annotation contradicts the Benchmark's hardening direction.

**Status:** New finding.

**Recommendation:** Add a comment in the Runbook's CSP block noting that `unsafe-eval` weakens CSP and should be removed where possible, with a cross-reference to Benchmark 1.2 for guidance.

### XD-11. Roles defined in `wp-config.php` — cross-document claim (Critical)

**Documents:** Hardening Guide 8.5 (line 333), Benchmark 5.8 (lines 1327, 1336)

The Hardening Guide states: "Define user roles and capabilities in code (`wp-config.php` or a must-use plugin)." The Benchmark control 5.8 states roles should be "defined in a must-use plugin or `wp-config.php`-adjacent include file." Phase 1 Hardening Guide Finding #1 correctly identified that roles **cannot** be defined in `wp-config.php` because the roles API (`WP_Roles`, `add_role()`, `add_cap()`) is initialized on the `init` hook, after `wp-config.php` is loaded.

The Benchmark's wording is slightly different — it says "`wp-config.php`-adjacent include file" which could mean a file loaded by `wp-config.php` via `require_once`, but this would still fail because the WordPress API is not yet available at that bootstrap stage.

**Status:** Confirmed as Critical for the Hardening Guide. The Benchmark's language is ambiguous — "wp-config.php-adjacent include file" could be interpreted as a file in the same directory loaded later in the bootstrap, but this is unclear and potentially misleading.

**Recommendation:** Both documents should state: "Define user roles and capabilities in a must-use plugin." Remove all references to `wp-config.php` for role definitions.

---

## Phase 1-2 Finding Review

### Confirmed High-Confidence Findings (convergent across agents)

The following findings were independently flagged by multiple Phase 1 agents or confirmed by Phase 2 validators. These represent the highest-confidence issues.

| Finding | Flagged By | Phase 2 Confirmed | Cross-Doc Impact |
|---|---|---|---|
| `wp core update --dry-run` is not a valid flag | Runbook Agent (Critical #1) | WP-CLI Validator (Confirmed) | Runbook only |
| `wp user session destroy` is not a WP-CLI core command | Runbook Agent (Critical #3) | WP-CLI Validator (Confirmed) | Runbook only |
| `wp site switch-language` is not a valid command | Runbook Agent (High #8) | WP-CLI Validator (Confirmed) | Runbook only |
| `update_available` is not a valid WP-CLI field name | Benchmark Agent (High #4) | WP-CLI Validator (Confirmed) | Benchmark only |
| REST API 5.4 vs. 5.6 duplicate with different permission guards | Benchmark Agent (Critical #1, #2) | Not in Phase 2 scope | Benchmark + Runbook (XD-6 above) |
| NIST SP 800-63B revision mismatch | Hardening Guide Agent (High #2) | Reference URL Validator (Confirmed) | Hardening Guide vs. Benchmark |
| NIST SP 800-61 revision superseded | Hardening Guide Agent (High #5) | Reference URL Validator (Confirmed) | Hardening Guide only |
| Nginx `deny all; return 403;` redundancy | Runbook Agent (High #7) | Not in Phase 2 scope | Runbook (violates AGENTS.md) |
| `wp-config.php` permissions contradiction | Benchmark Agent (High #3) | Not in Phase 2 scope | Benchmark vs. Style Guide (XD-1 above) |
| Roles cannot be defined in `wp-config.php` | Hardening Guide Agent (Critical #1) | Not in Phase 2 scope | Hardening Guide + Benchmark (XD-11 above) |
| Glossary alphabetical ordering (2 entries) | Style Guide Agent (High #1, #2) | Glossary Validator (Confirmed) | Style Guide only |
| 7 missing glossary terms | Style Guide Agent (Low #7-13) | Glossary Validator (Confirmed) | Style Guide (cross-doc coverage) |
| 48 missing `bash` language annotations in Benchmark | Not in Phase 1 scope | Code Block Lint (48 findings) | Benchmark only |
| Broken grep pattern in Runbook (line 1849) | Runbook Agent (Medium #11) | WP-CLI Validator (Confirmed) | Runbook only |
| `wp redis flush` vs. `wp redis flush-db` inconsistency | Runbook Agent (High #4) | WP-CLI Validator (Confirmed) | Runbook only |
| IBM Cost of a Data Breach figure ($4.44M) possibly stale | Hardening Guide Agent (High #3) | Not in Phase 2 scope | Hardening Guide (all downstream figures depend on this) |

### Challenged Findings (possible false positives)

| # | Original Finding | Source | Challenge | Status |
|---|---|---|---|---|
| 1 | Phase 2 Code Block Lint classified all 48 missing `bash` annotations as "High" severity | Phase 2 Code Block Lint | Missing language annotations are a formatting deficiency, not a correctness or security issue. They affect syntax highlighting and copy-paste convenience but do not cause commands to fail or produce incorrect output. A severity of "Medium" or "Low" is more appropriate. The Phase 2 validator's blanket "High" classification is overclaimed. | **Severity downgraded to Low.** The fix is mechanical and can be applied in batch; it does not require editorial judgment. |
| 2 | Phase 1 Benchmark Finding #10: `grep` BRE vs. ERE inconsistency (Medium) | Benchmark Agent | The finding correctly notes that `grep 'A\|B'` (BRE) and `grep -E 'A|B'` (ERE) are both syntactically correct for their respective tools. The agent then suggests normalizing all to `grep -E` for consistency. However, the Benchmark uses BRE `grep` where only one pattern is needed (e.g., line 639: `grep 'table_prefix'` — no alternation at all) and ERE `grep -E` where multiple patterns are needed. The mixed usage is idiomatic and not confusing. | **Downgraded from Medium to Low.** The suggestion to add an inline comment is reasonable but normalizing all to `grep -E` is unnecessary. |
| 3 | Phase 1 Runbook Finding #2: `--field=user_login` and `--field=ID` (Critical) | Runbook Agent | The Runbook agent initially flagged these as Critical, then immediately self-corrected in the same finding: "`--field` (singular) IS valid for a single field." The finding should not have been classified as Critical since the agent's own verification showed the commands are correct. | **Rejected as false positive.** The commands are valid. This was self-corrected within the Phase 1 report. |
| 4 | Phase 1 Hardening Guide Finding #7: OWASP Top 10:2025 unverified | Hardening Guide Agent | The agent flagged "OWASP Top 10:2025" as unverified because the 2025 edition had not been published as of August 2025 (the agent's knowledge cutoff). Both documents cite it consistently, and the document date is March 2026, allowing 7 months for publication. The OWASP Top 10:2025 URL (`owasp.org/Top10/2025/`) is cited in the Style Guide glossary as well. This is more likely correct than incorrect. | **Downgraded from Medium to Low (flag for verification only).** The human editor should verify the URL resolves, but this is likely not an error. |
| 5 | Phase 2 WP-CLI Validator Finding #10-12: Plugin-dependent commands in comments lacking annotation | Phase 2 WP-CLI Validator | The Runbook already uses the annotation pattern `# Plugin-dependent -- uncomment the cache plugin(s) in use:` at multiple locations (e.g., lines 437-440, 777-779). The Phase 2 validator flagged some instances where the comment prefix `#` was present but the explicit "Plugin-dependent" annotation was missing. However, several of these lines are in blocks that already carry the annotation at the top (e.g., line 437 introduces the pattern; lines 438-439 are the commented commands beneath it). The validator counted individual lines rather than blocks. | **Partially challenged.** Some instances genuinely lack the annotation (e.g., `wp elasticpress` at line 1748), but others are within already-annotated blocks. Reduce the count from 6 to 2 that need new annotations. |

### New Findings (not caught by Phase 1-2)

These issues are visible only when comparing all four documents simultaneously or when cross-referencing findings from multiple agents.

| # | Finding | Documents | Severity | Recommendation |
|---|---|---|---|---|
| N-1 | HSTS `preload` directive present in Runbook but absent in Benchmark | Benchmark 1.2, Runbook 3.5/5.3 | Low | Standardize; see XD-9 above |
| N-2 | CSP `unsafe-eval` present in Runbook but absent in Benchmark | Benchmark 1.2, Runbook 5.3 | Low | Annotate; see XD-10 above |
| N-3 | Runbook REST API code uses unconditional `unset()` while Benchmark uses capability check | Benchmark 5.6, Runbook 5.4 | High | Standardize to `current_user_can('list_users')`; see XD-6 above |
| N-4 | PHP version floor in Runbook template placeholder ("8.1+") is below Benchmark/Hardening Guide floor ("8.2+") | All three technical docs | Medium | Update Runbook placeholder; see XD-4 above |
| N-5 | Hardening Guide NIST SP 800-61 citation is r2; Benchmark has no corresponding citation — documents should cross-reference the same revision | Hardening Guide 15.3, Benchmark (absent) | Medium | If the Benchmark adds an incident response reference, it should cite r3 to match the corrected Hardening Guide |
| N-6 | Runbook `wp-config.php` SMTP constants (`SMTP_HOST`, `SMTP_PORT`, etc.) are not recognized by WordPress core — this same pattern is also described in the Hardening Guide's recommendation to "store keys in `wp-config.php` constants" for AI API keys (Section 14.3), which IS a valid pattern when consumed by custom code | Runbook 6.7, Hardening Guide 14.3 | Medium | The Runbook should clarify that the SMTP constants require consuming code (a plugin or mu-plugin). The Hardening Guide's AI key storage recommendation is valid because it recommends `define('OPENAI_API_KEY', getenv('OPENAI_API_KEY'))` — consumed by plugin code. No change needed in the Hardening Guide. |
| N-7 | The Benchmark control 5.5 references `wp-sudo` by the document editor (github.com/dknauss/wp-sudo); the Hardening Guide 8.2 recommends "action-gated reauthentication" but does not reference `wp-sudo` — only Fortress (Snicco). The Style Guide glossary entry for "Action-gated reauthentication" does not reference either tool. | Benchmark 5.5, Hardening Guide 8.2 | Low | Align cross-references: either both documents reference both tools (with disclosure of authorial relationship for `wp-sudo`), or lead with Fortress in both and mention `wp-sudo` as an alternative. Phase 1 Benchmark Finding #15 flagged the transparency concern. |
| N-8 | NordVPN citation (Hardening Guide 8 callout) has no equivalent in any other document. The Style Guide's Infostealer glossary entry cites Verizon DBIR instead. | Hardening Guide 8, Style Guide glossary | Medium | Replace NordVPN citation with Verizon DBIR data per Phase 1 Hardening Guide Finding #4 and AGENTS.md source authority hierarchy |
| N-9 | Gartner citation (Hardening Guide 12.4) has no equivalent in any other document. Not an approved primary source per AGENTS.md. | Hardening Guide 12.4 | Medium | Replace with Verizon DBIR data per Phase 1 Hardening Guide Finding #9 |
| N-10 | The Benchmark's `sshd_config` code block (lines 2055-2059) has a leading space before `PasswordAuthentication no`. The Runbook's `sshd_config` block (Section 5.1, lines 475-478) does NOT have this inconsistency. | Benchmark 12.1, Runbook 5.1 | Low | Remove leading space in Benchmark to match Runbook formatting |
| N-11 | Glossary cross-reference formatting: Style Guide uses monospace backticks for glossary cross-references to `wp-admin`, `wp-login.php`, and `xmlrpc.php` in "See also" lines, while all other cross-references use italic. This creates a rule-within-rule ambiguity: these terms are file paths/URL paths AND glossary entries simultaneously. | Style Guide glossary (lines 573, 581, 587) | Low | Adopt italic format for all glossary cross-references, since the cross-reference function overrides the file-path formatting rule in this context. Phase 1 Style Guide Findings #3-5 flagged this correctly. |

---

## Prioritized Revision Plan

| Priority | Finding | Documents | Severity | Recommendation |
|---|---|---|---|---|
| 1 | `wp core update --dry-run` nonexistent flag | Runbook 6.2 | Critical | Replace with `wp core check-update` |
| 2 | `wp user session destroy` nonexistent subcommand | Runbook 10.3 | Critical | Annotate as plugin-dependent or replace with `wp db query` to clear session tokens |
| 3 | `wp site switch-language` nonexistent command | Runbook (lines 2780, 2899) | Critical | Replace with `wp language core activate` |
| 4 | REST API 5.4/5.6 duplicate with different permission guards + Runbook divergence | Benchmark 5.4, 5.6; Runbook 5.4 | Critical | Consolidate to single `current_user_can('list_users')` implementation; cross-reference across documents |
| 5 | Roles cannot be defined in `wp-config.php` | Hardening Guide 8.5; Benchmark 5.8 | Critical | Remove `wp-config.php` from role-definition claims in both documents |
| 6 | NIST SP 800-63B revision mismatch (r3 vs. r4) | Hardening Guide 15.3 | High | Update URL to revision 4 |
| 7 | NIST SP 800-61 revision superseded (r2 vs. r3) | Hardening Guide 15.3 | High | Update URL to revision 3 |
| 8 | `update_available` field name incorrect in WP-CLI commands | Benchmark 8.2, 8.3 (3 occurrences) | High | Verify via `wp help plugin list`; likely correct field is `update` |
| 9 | `wp-config.php` permissions contradiction (400 vs. 600) | Benchmark 6.2 vs. Style Guide glossary | High | Update Style Guide to match Benchmark's 400/440 guidance |
| 10 | TLS 1.2+ enforcement classified as L2 (should be L1) | Benchmark 1.1 | High | Reclassify to Level 1 |
| 11 | Nginx `deny all; return 403;` redundancy in Runbook | Runbook 5.4, 6.6 | High | Remove `return 403;` per AGENTS.md code block rules |
| 12 | NordVPN citation (non-authoritative source) | Hardening Guide 8 | High | Replace with Verizon DBIR data |
| 13 | `wp redis flush` vs. `wp redis flush-db` inconsistency | Runbook 4.3 (line 439) | High | Standardize to `wp redis flush-db` |
| 14 | Runbook REST API code lacks capability check | Runbook 5.4 | High | Add `current_user_can('list_users')` guard |
| 15 | IBM Cost of a Data Breach $4.44M figure possibly stale | Hardening Guide 2 | High | Verify against actual 2025 report; update if incorrect |
| 16 | Fictional `wp shell` revision-deletion procedure | Runbook 6.4 (lines 882-885) | High | Replace with functional WP-CLI or SQL approach |
| 17 | `wp db query "ROLLBACK;"` misleading no-op | Runbook 8.3 (line 1542) | High | Remove; document that backup import is the only reliable rollback |
| 18 | Glossary alphabetical ordering (2 entries out of order) | Style Guide glossary | High | Move `FORCE_SSL_ADMIN` before `FUD`; move `mu-plugin` before `Multisite` |
| 19 | WordPress Security White Paper URL inconsistency | Hardening Guide, Style Guide, Runbook | Medium | Verify canonical URL; standardize across all documents |
| 20 | PHP version floor discrepancy in Runbook template | Runbook 2.1 | Medium | Update placeholder from "8.1+" to "8.2+" |
| 21 | Gartner citation (non-approved source) | Hardening Guide 12.4 | Medium | Replace with Verizon DBIR data |
| 22 | `wp option update mailer*` commands plugin-specific without annotation | Runbook 6.7 | Medium | Add plugin-dependency annotation |
| 23 | `wp-config.php` SMTP constants not consumed by WordPress core | Runbook 6.7 | Medium | Add note that constants require consuming code |
| 24 | `sshd_config` leading space formatting artifact | Benchmark 12.1 | Medium | Remove leading space |
| 25 | "admin panel" terminology violation | Hardening Guide 7.1 | Medium | Change to "Dashboard" |
| 26 | OWASP API Security vs. OWASP Top 10 distinction unclear | Benchmark 1.5 | Medium | Clarify which OWASP publication is cited |
| 27 | WP-CLI `wp-cli` lowercase in Benchmark prose | Benchmark 4.7 | Medium | Change to "WP-CLI" per Style Guide |
| 28 | `WP_AUTO_UPDATE_CORE` `'minor'` value version annotation missing | Runbook Appendix B.9 | Medium | Add version note: "available since WordPress 5.6" |
| 29 | `wp maintenance-mode` version requirement overstated (2.8+ vs. 2.1+) | Runbook 10.3 | Medium | Correct to "WP-CLI 2.1+" |
| 30 | `--allow-root` antipattern in audit command | Benchmark 11.1 | Medium | Remove; run as site user |
| 31 | IBM AI breach statistics internal inconsistency (13% vs. 20%) | Hardening Guide 14/14.2 | Medium | Clarify that 13% is overall AI breach rate, 20% is shadow AI subset |
| 32 | Incident response framework reference non-specific | Hardening Guide 12.3 | Medium | Add "NIST SP 800-61r3, Section 3" |
| 33 | Mixed Nginx/bash syntax in single code block | Runbook 9.1 (lines 1596-1609) | Medium | Split into separate `bash` and `nginx` fences |
| 34 | Revision count query counts wrong meta key | Runbook 6.4 (line 879) | Medium | Change comment; add correct revision count query |
| 35 | 7 missing glossary terms (SIEM, UFW, PHP-FPM, AIDE, Snuffleupagus, SIM-swapping, Ransomware) | Style Guide | Low | Add entries per Phase 1 Style Guide recommendations |
| 36 | 4 glossary cross-reference formatting errors (monospace vs. italic) | Style Guide glossary | Low | Convert to italic format |
| 37 | 48 missing `bash` language annotations on Benchmark code blocks | Benchmark | Low | Add `bash` language tags; mechanical fix |
| 38 | HSTS `preload` inconsistency between Benchmark and Runbook | Benchmark 1.2, Runbook 3.5/5.3 | Low | Annotate `preload` implications; standardize |
| 39 | CSP `unsafe-eval` in Runbook not annotated | Runbook 5.3 | Low | Add annotation noting security trade-off |
| 40 | PHP remediation snippets as inline backticks instead of fenced blocks | Benchmark 4.1-4.3, 4.7 | Low | Convert to fenced `php` code blocks |
| 41 | Missing `<?php` opening tags in mu-plugin examples | Runbook 5.4 | Low | Add opening tags |
| 42 | RHEL/CentOS binary name (`httpd` vs. `apache2`) omission | Benchmark 8.4 | Low | Add portability note |
| 43 | `wp-sudo` authorial relationship disclosure | Benchmark 5.5 | Low | Disclose relationship or lead with Fortress |
| 44 | Missing WP-CLI docs reference for `wp plugin verify-checksums` | Benchmark 7.2 | Low | Add reference link |
| 45 | Emergency Quick-Reference Card first command may fail during 500 error | Runbook (line 40) | Low | Consider `tail /var/log/php-errors.log` as alternative |

---

## Convergence Analysis

The strongest signals come from findings independently identified by multiple agents:

1. **WP-CLI command validity** — The Runbook Agent, WP-CLI Validator, and Benchmark Agent all flagged invalid WP-CLI commands from different angles. The WP-CLI Validator confirmed 7 of 8 Phase 1 WP-CLI findings, making this the highest-confidence category.

2. **NIST URL staleness** — The Hardening Guide Agent and Reference URL Validator independently identified the same two stale NIST URLs. High confidence.

3. **Glossary coverage gaps** — The Benchmark Agent, Style Guide Agent, Runbook Agent, and Glossary Validator all identified overlapping sets of missing terms. The Glossary Validator's final list of 7 is a convergent superset.

4. **REST API permission guard inconsistency** — The Benchmark Agent flagged the internal Benchmark contradiction. This Phase 3 audit adds the Runbook's third divergent implementation. The cross-document dimension was not visible to single-document agents.

5. **`wp-config.php` permissions** — The Benchmark Agent flagged the Style Guide contradiction. This Phase 3 audit confirms the Hardening Guide agrees with the Benchmark, making the Style Guide the outlier.

---

## Scope Notes

- **Sections 1-2 of the Style Guide** were not reviewed per AGENTS.md constraints.
- **Deprecated constants:** No documents use deprecated constants without annotation. The Hardening Guide's Section 15.5 guardrail and the Runbook's Appendix D both correctly list deprecated/invalid constants.
- **Compliance language:** No document claims WordPress software is compliant with any framework. All compliance references are correctly attributed to deployments or organizations.
- **OWASP Top 10:2025** is cited consistently across both the Benchmark and Hardening Guide. The Style Guide glossary also references it. If the 2025 edition does not exist, all three documents need updating simultaneously.
- **bcrypt/Argon2id version claims** are consistent across all documents that reference them (Hardening Guide, Benchmark, Style Guide glossary): bcrypt since WordPress 6.8, Argon2id via `wp_hash_password_algorithm` filter, PHP 7.3+ requirement.
