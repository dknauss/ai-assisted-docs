# GridPane Security Research Brief

Date: 2026-03-06
Audience: Internal WordPress security editors and reviewers
Status: Internal research artifact; not canonical product guidance

## Scope

This brief summarizes what GridPane publicly says about its WordPress security model and the Fortress plugin, then maps those claims to editorial implications for the canonical WordPress security docs. The canonical docs live in separate repositories; this repo stores research and review artifacts only.

Canonical source docs for any approved follow-up work:

- `../wp-security-benchmark/WordPress-Security-Benchmark.md`
- `../wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md`
- `../wordpress-runbook-template/WP-Operations-Runbook.md`
- `../wp-security-style-guide/WP-Security-Style-Guide.md`

## Verified Vendor Claims

- GridPane positions Fortress as "the only security plugin" it officially recommends and says Fortress covers the controls that can only be handled effectively at the plugin level, with GridPane providing server-level integration. Source: https://gridpane.com/fortress/
- GridPane also says that if a site is already using its 7G or ModSecurity WAF, Fail2Ban, and additional security measures, most WordPress security plugins are unnecessary, with Fortress as the stated exception. Source: https://gridpane.com/kb/do-i-need-a-security-plugin-when-using-gridpanes-security-features/
- GridPane's Fortress page groups the plugin's application-layer claims around two-factor authentication, Argon2-based password hashing, login protection, session protection, Vaults and Pillars, and Code Freeze. Source: https://gridpane.com/fortress/
- GridPane explicitly argues that some common "security plugin" features are better handled at the web server or CDN layer, including general-purpose WAF behavior and malware scanning. Sources: https://gridpane.com/fortress/ ; https://gridpane.com/kb/do-i-need-a-security-plugin-when-using-gridpanes-security-features/
- GridPane markets Fortress as operationally lightweight: custom tables, cached configuration, a lazy-loaded codebase, no frontend assets on non-Fortress pages, WP-CLI-first behavior, and 1200+ automated tests before release. Source: https://gridpane.com/fortress/
- GridPane's Fortress offering includes GridPane-specific pricing, client distribution terms, and white-label / branded options. Source: https://gridpane.com/fortress/

## Editorial Reading

- The transferable idea is not "use Fortress." The transferable idea is to distinguish controls that belong at the application layer from controls that belong at the server or edge layer, then explain the tradeoffs clearly.
- Fortress-specific terms such as `Vaults`, `Pillars`, and `Code Freeze` are proprietary product language. They should stay labeled as vendor-specific unless the editor deliberately introduces them as part of a clearly marked case study.
- GridPane's performance and QA claims are useful as evaluation criteria for security tooling, but they remain vendor claims unless independently verified elsewhere.
- Any implementation recommendation derived from this material must still be validated against the project authority hierarchy: WordPress developer docs, WordPress core, WP-CLI docs, then external standards.

## Current Fit Against The Canonical Docs

- The canonical docs already cover several non-vendor concepts that overlap with the GridPane material: Argon2id, WAF placement, virtual patching, Fail2Ban, and must-use plugins all already appear in the Benchmark, Hardening Guide, or Style Guide.
- The current evidence does not justify importing Fortress-specific feature names into the canonical docs as if they were WordPress-general terminology.
- The Runbook currently has less explicit security-taxonomy language than the Benchmark and Hardening Guide. If the editor wants a follow-up, the safer change is a vendor-neutral cross-reference about edge, server, and application layers, not Fortress integration steps.

## Recommended Use In This Repo

- Use this brief as a research input for review rounds, revision planning, and discussion with the human editor.
- Keep follow-up tasks pointed at the canonical source repos, not at `wp-security-doc-review/rounds/...` review snapshots.
- Treat proprietary licensing, branding, and product positioning as internal context unless the editor explicitly wants a vendor case study.

## References

- https://gridpane.com/fortress/
- https://gridpane.com/kb/do-i-need-a-security-plugin-when-using-gridpanes-security-features/
