# Phase 2 — Reference URL Check (Haiku)

Date: 2026-03-03

## Summary

**Total unique URLs checked:** 105+ (excluding placeholder URLs with `[CUSTOMIZE: ...]`)

**Issues found:** 7 total
- 4 confirmed from Phase 1 findings (superseded revisions, stale/inconsistent resources)
- 3 new issues discovered in Phase 2 (URL inconsistencies, format problems)

---

## Issues Found

| # | Document | Section | URL | Issue | Status |
|---|---|---|---|---|---|
| 1 | WordPress-Security-Hardening-Guide.md | §15.3, line 567 | `https://pages.nist.gov/800-63-3/sp800-63b.html` | Stale NIST revision: Points to SP 800-63B revision 3 (2017). Should be revision 4 (2024). Benchmark uses revision 4 at `https://pages.nist.gov/800-63-4/sp800-63b.html`. Cross-document inconsistency. | Confirmed from Phase 1 |
| 2 | WordPress-Security-Hardening-Guide.md | §15.3, line 568 | `https://csrc.nist.gov/pubs/sp/800/61/r2/final` | Stale NIST revision: Points to SP 800-61 revision 2 (2012). Should be revision 3 (2024). NIST published r3 in 2024, making r2 superseded. | Confirmed from Phase 1 |
| 3 | WordPress-Security-Hardening-Guide.md | §3.1, §15.1, §Related Docs (lines 44, 550, 607) | `https://developer.wordpress.org/apis/security/` | URL/label mismatch: Labeled as "WordPress Security White Paper" but resolves to developer API documentation. Actual White Paper may be at `https://wordpress.org/about/security/`. Used 3 times across document. | Confirmed from Phase 1 |
| 4 | WP-Operations-Runbook.md | §Related Docs, line 2955 | `https://wordpress.org/about/security/` | Correct: Points to WordPress.org Security White Paper. Differs from Hardening Guide's `developer.wordpress.org/apis/security/` at line 550. This is the correct canonical URL per WordPress.org. | New: Cross-doc inconsistency |
| 5 | WordPress-Security-Hardening-Guide.md & WordPress-Security-Benchmark.md (multiple sections) | §15 References | Various OWASP Top 10 citations | Unverified edition: Both documents cite "OWASP Top 10:2025" edition multiple times. As of the knowledge cutoff (August 2025), the 2025 edition had not been published; 2021 was current. If published between cutoff and March 2026, this is correct. Requires verification. | Confirmed from Phase 1 |
| 6 | WordPress-Security-Benchmark.md | §1.3, line 306 | `https://owasp.org/API-Security/editions/2023/en/0xa4-unrestricted-resource-consumption/` | Edition year in URL: OWASP API Security Top 10 2023 edition is referenced. Should verify if a 2024 or 2025 edition exists and if reference should be updated. Currently valid format but may be outdated. | New: Potential stale edition |
| 7 | WP-Operations-Runbook.md | §Related Docs, lines 2952-2956 & Hardening-Guide §Related Docs, lines 604-607 | GitHub URLs: `https://github.com/dknauss/wp-security-benchmark`, `https://github.com/dknauss/wp-security-hardening-guide`, `https://github.com/dknauss/wordpress-runbook-template` | Inconsistent doc references: Runbook references use GitHub URLs; Hardening Guide also uses GitHub but additionally references `developer.wordpress.org/apis/security/` for Security White Paper. Both documents should standardize on whether to reference GitHub repositories or upstream WordPress.org sources for the White Paper. | New: Format/style inconsistency |

---

## Cross-Document URL Consistency

### WordPress Security White Paper (Critical Inconsistency)

| Document | URL | Label | Status |
|---|---|---|---|
| WordPress-Security-Hardening-Guide.md (lines 44, 550, 607) | `https://developer.wordpress.org/apis/security/` | "WordPress Security White Paper" | Incorrect label; actually API docs |
| WP-Operations-Runbook.md (line 2955) | `https://wordpress.org/about/security/` | "WordPress Security White Paper" | Correct canonical URL |
| WP-Security-Style-Guide.md (line 635, 650) | `https://developer.wordpress.org/apis/security/` | "WordPress Security White Paper (developer.wordpress.org)" | Inconsistent with Runbook |

**Recommendation:** The Hardening Guide and Style Guide should update to use `https://wordpress.org/about/security/` and remove the "developer.wordpress.org" reference, or clarify that they are linking to the developer API documentation, not the Security White Paper.

### NIST SP 800-63B (Cross-Document Mismatch)

| Document | URL | Revision |
|---|---|---|
| WordPress-Security-Hardening-Guide.md (line 567) | `https://pages.nist.gov/800-63-3/sp800-63b.html` | Revision 3 (2017) — **STALE** |
| WordPress-Security-Benchmark.md (lines 1048, 1224, 1316) | `https://pages.nist.gov/800-63-4/sp800-63b.html` | Revision 4 (2024) — **CURRENT** |

**Recommendation:** Update Hardening Guide line 567 to use revision 4 URL.

### NIST SP 800-61 (Superseded Revision)

| Document | URL | Revision |
|---|---|---|
| WordPress-Security-Hardening-Guide.md (line 568) | `https://csrc.nist.gov/pubs/sp/800/61/r2/final` | Revision 2 (2012) — **SUPERSEDED** |
| Benchmark (no direct citation) | (none found) | — |

**Recommendation:** Update Hardening Guide line 568 to use revision 3 URL: `https://csrc.nist.gov/pubs/sp/800/61/r3/final`

### OWASP Top 10 Edition

Both Hardening Guide (line 556) and Benchmark cite "OWASP Top 10:2025" edition:
- `https://owasp.org/Top10/2025/`
- Benchmark also references at lines 306 (API Security 2023), 2024

**Status:** Requires verification that the 2025 edition exists. The 2021 edition was the most recent as of August 2025 knowledge cutoff.

---

## URL Format Validation

All URLs follow valid HTTPS format. No malformed URLs detected.

### Valid URL Patterns Confirmed

- `https://developer.wordpress.org/` — WordPress Developer Handbook (valid pattern)
- `https://pages.nist.gov/800-63-x/` — NIST standards (valid pattern)
- `https://csrc.nist.gov/pubs/sp/800/xx/rx/` — NIST publications (valid pattern)
- `https://owasp.org/` — OWASP resources (valid pattern)
- `https://github.com/dknauss/` — GitHub repositories (valid pattern)

### Known Stale Patterns

No `codex.wordpress.org` URLs detected. All WordPress.org references correctly use either `wordpress.org` or `developer.wordpress.org`.

---

## Recommendations

1. **Immediate (High Priority):**
   - Update Hardening Guide §15.3 line 567 NIST SP 800-63B URL from revision 3 to revision 4
   - Update Hardening Guide §15.3 line 568 NIST SP 800-61 URL from revision 2 to revision 3
   - Correct Hardening Guide line 550 label and URL for Security White Paper (use `https://wordpress.org/about/security/`)

2. **Verification Needed:**
   - Confirm OWASP Top 10:2025 edition exists; if not, downgrade to 2021 edition across both documents
   - Verify OWASP API Security 2023 is still current; check for 2024/2025 editions

3. **Style Consistency:**
   - Standardize references to internal documents (GitHub URLs vs. canonical sources)
   - Consider whether Style Guide should mirror Runbook's correct White Paper URL

---

## Notes

- No deprecated `codex.wordpress.org` URLs found in any document.
- No markdown escaping errors detected in URLs.
- All URLs in References sections follow consistent formatting (markdown link style `[text](url)`).
- Placeholder URLs (e.g., `https://[CUSTOMIZE: example.com]`) in templates are excluded from this audit.
