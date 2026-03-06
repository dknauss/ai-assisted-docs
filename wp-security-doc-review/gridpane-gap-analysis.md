# GridPane Alignment Gap Analysis

Date: 2026-03-06
Status: Internal editorial analysis

This analysis compares verified public GridPane material with the canonical WordPress security documents maintained in sibling repositories. It does not treat `wp-security-doc-review/rounds/...` snapshots as the source documents.

## Canonical Docs Reviewed

- `../wp-security-benchmark/WordPress-Security-Benchmark.md`
- `../wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md`
- `../wordpress-runbook-template/WP-Operations-Runbook.md`
- `../wp-security-style-guide/WP-Security-Style-Guide.md`

## Summary

- Several non-vendor concepts highlighted by GridPane are already present in the canonical docs: `Argon2id`, WAF placement, virtual patching, Fail2Ban, and must-use plugins.
- The main gaps were in this repo's artifact quality, not in the canonical docs themselves: missing exact citations, confusion between review artifacts and source docs, and incomplete planning scaffolding.
- Fortress-specific terms remain vendor language. There is not yet a strong editorial basis for promoting them into the canonical glossary or implementation guidance.

## Detailed Findings

**Column schema note:** This gap analysis uses a 4-column layout (Topic, What GridPane says, Current canonical status, Recommendation). This is a simpler schema than the crosswalk template's 7 columns because the gap analysis focuses on editorial gaps rather than claim-by-claim mapping.

| Topic | What GridPane says | Current canonical status | Recommendation |
|---|---|---|---|
| Layering of controls | GridPane says most security-plugin features are unnecessary when its WAF and Fail2Ban stack is already in place, except for Fortress as an application-layer tool. Sources: https://gridpane.com/kb/do-i-need-a-security-plugin-when-using-gridpanes-security-features/ ; https://gridpane.com/fortress/ | The Benchmark and Hardening Guide already describe WAF placement and defense-in-depth, but the Runbook has less explicit security-taxonomy framing. | If the editor wants a follow-up, add a vendor-neutral cross-reference in the Runbook. Do not add Fortress integration steps. |
| Argon2id and password hardening | Fortress markets Argon2-based password hashing. Source: https://gridpane.com/fortress/ | `Argon2id` already appears in the Benchmark, Hardening Guide, and Style Guide. | No glossary work needed here. GridPane does not create a new canonical-doc requirement. |
| Fortress-specific terms | Fortress uses product terms such as `Vaults`, `Pillars`, and `Code Freeze`. Source: https://gridpane.com/fortress/ | These terms do not currently appear as WordPress-general terminology in the canonical docs. | Keep them vendor-specific. Only introduce them in the canonical docs as part of an explicitly labeled case study, if at all. |
| WAF and malware-scanning posture | GridPane argues general-purpose WAF logic and malware scanning belong at the server or CDN layer, not mainly inside a plugin. Source: https://gridpane.com/fortress/ | The Benchmark and Hardening Guide are already broadly aligned with this layering. | No immediate canonical-doc change needed. Keep this as supporting context for future reviews. |
| Internal process quality | Prior iterations of these artifacts lacked exact source URLs, targeted archived review files as if they were canonical docs, and added GSD plans without the normal `.planning` scaffold. | This repo is the right place to fix those process issues. | Correct the research artifacts, add a reusable crosswalk template, and initialize the missing planning metadata. |

## No-Change Calls

- Do not add `Argon2id` or `mu-plugin` glossary work as a GridPane-specific task; those concepts are already covered in the Style Guide.
- Do not add Fortress licensing, branding, or white-label details to the canonical WordPress security docs.
- Do not convert GridPane product terms into WordPress-general terminology without a separate editorial decision.

## Follow-Up Candidates If The Editor Approves

- Add a vendor-neutral note or cross-reference in the Runbook explaining how edge, server, and application controls complement one another.
- Use the crosswalk template to evaluate other vendor stacks without conflating vendor claims with canonical guidance.

## References

- https://gridpane.com/fortress/
- https://gridpane.com/kb/do-i-need-a-security-plugin-when-using-gridpanes-security-features/
