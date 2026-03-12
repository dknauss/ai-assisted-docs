# BDD Test Run: wordpress-security-doc-editor scenarios against security docs

**Date:** 2026-03-12
**Scenarios tested:** 3 of 4 wordpress-security-doc-editor scenarios
**Documents tested:** All 4 (Benchmark, Hardening Guide, Style Guide, Runbook)
**Test runner:** Claude Code (parallel agents + manual)

## Scenario Results Summary

| Scenario | File | Status | Findings |
|---|---|---|---|
| Terminology Consistency | terminology-consistency.md | 3 FAIL | 3 violations + 1 borderline |
| Benchmark Structure | benchmark-structure.md | PASS (1 incidental) | 50/50 complete, 1 appendix discrepancy |
| Cross-Document Alignment | cross-document-alignment.md | 5 FAIL | 0 GRANT ALL, 0 version conflicts, 5 glossary gaps |
| Authority Hierarchy | authority-hierarchy.md | Not tested | Deferred to next run |

**Overall: 8 findings across 3 scenarios** (3 terminology, 5 glossary, 1 structural discrepancy).

---

## Scenario 1: Terminology Consistency

**File:** `scenarios/wordpress-security-doc-editor/terminology-consistency.md`
**Tested by:** Agent (a638509f35b17cf7c)

### Results

| Disallowed Term | Benchmark | Hardening Guide | Style Guide | Runbook |
|---|---|---|---|---|
| whitelist | PASS | PASS | EXEMPT (definition) | PASS |
| blacklist | PASS | PASS | EXEMPT (definition) | PASS |
| hacker (malicious) | PASS | PASS | EXEMPT (definition) | PASS |
| backend | PASS | PASS | EXEMPT (definition) | PASS |
| admin panel | PASS | PASS | EXEMPT (definition) | PASS |
| admin area | **FAIL** (line 772) | PASS | EXEMPT (line 206) | PASS |
| Plugin (mid-sentence) | PASS | PASS | PASS | PASS |
| multisite (lowercase prose) | PASS | PASS | PASS | **FAIL** (line 3205) |
| Multi-site / multi site | PASS | PASS | PASS | PASS |
| Autoupdate / auto update | PASS | PASS | PASS | PASS |
| wp-cli (lowercase prose) | **FAIL** (line 1805) | PASS | PASS | PASS |
| WPCLI / wp cli | PASS | PASS | PASS | PASS |
| Wordpress / wordpress | PASS | PASS | PASS | PASS |
| WP (in running text) | PASS | PASS | PASS | PASS |

### Findings

1. **FAIL — Benchmark line 772**: "All users must access the admin area over HTTPS." Should use "Dashboard" per Style Guide rule.

2. **FAIL — Benchmark line 1805**: `` `wp-cli` `` used as a tool name reference in running prose. Even in backticks, the proper noun form "WP-CLI" should be used when referring to the tool (not typing a command).

3. **FAIL — Runbook line 3205**: "...server access, and multisite. This runbook's hardening procedures..." Should use "Multisite" (capitalized) in running prose.

4. **Borderline — Style Guide line 206**: Uses "admin area" in its own terminology definitions section while its own rule at lines 200 and 432 says to prefer "Dashboard." Internal inconsistency.

---

## Scenario 2: Benchmark Control Structure

**File:** `scenarios/wordpress-security-doc-editor/benchmark-structure.md`
**Tested by:** Agent (ab8c6d6bc188cf040)

### Section Completeness

**Result: PASS — All 50 controls have all 9 required CIS sections.**

Every control contains: Profile Applicability, Assessment Status, Description, Rationale, Impact, Audit, Remediation, Default Value, References. All use the bold-label format (`**Section:**`) consistently.

### Audit Quality

**Result: PASS — All 31 Automated controls have runnable commands.**

No Automated control has an Audit section that merely says "check" or "verify" without a command. Command types include grep, curl, php -i, SQL queries, wp-cli, stat, ss, ufw.

### REST API Controls

**Result: PASS — 2/2 REST API controls include `current_user_can()`.**

| Control | current_user_can() |
|---|---|
| 5.4 Ensure user enumeration is prevented | PRESENT (line 1189-1195) |
| 5.6 Ensure REST API exposure is intentionally scoped | PRESENT (line 1280-1286) |

Control 1.5 (rate limiting) mentions REST API but implements at the web server level — `current_user_can()` not applicable.

### Incidental Finding (outside test scope)

**Control 1.1 profile applicability mismatch:**
- Control body (line 60): `**Profile Applicability:** **Level 1**`
- Appendix A summary table (line 2333): `| 1.1 | ... | L2 |`

This is an internal consistency error — the appendix table says L2 but the control body says Level 1. Severity: Medium.

---

## Scenario 3: Cross-Document Alignment

**File:** `scenarios/wordpress-security-doc-editor/cross-document-alignment.md`
**Tested by:** Manual (agent hit rate limit)

### Test 3.1: GRANT ALL Check

**Result: PASS — No `GRANT ALL` found in any document.**

All GRANT statements use the correct 8-privilege specification:
- Benchmark line 561: `GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, DROP`
- Runbook lines 1625, 2493: Same 8-privilege pattern
- Style Guide line 116: References `GRANT ALL PRIVILEGES` only as an explicit example of what NOT to do. EXEMPT.

### Test 3.2: Version Reference Alignment

**Result: PASS — No version conflicts found.**

| Claim | Benchmark | Hardening Guide | Runbook | Style Guide | Status |
|---|---|---|---|---|---|
| Auto-updates since WP 3.7 | line 923 | line 52 | — | — | ALIGNED |
| Bcrypt default since WP 6.8 | line 1313 | line 76 | — | line 516 | ALIGNED |
| PHP 8.2+ (8.3+ recommended) | line 24 | line 161 | — | — | ALIGNED |
| WP_AUTO_UPDATE_CORE since WP 5.6 | — | — | line 2932 | — | Single doc |
| WPLANG deprecated since WP 4.0 | — | — | lines 3013, 3133 | — | Single doc |
| Sitemaps since WP 5.5 | — | — | line 1984 | — | Single doc |

### Test 3.3: Glossary Coverage

**Result: 5 FAIL — Terms appearing in 2+ documents with no glossary entry.**

| Term | Benchmark | Hardening Guide | Runbook | Glossary Entry |
|---|---|---|---|---|
| KSES | 3 uses | 1 use | 0 | **MISSING** |
| open_basedir | 8 uses | 1 use | 0 | **MISSING** |
| wp-cron | 13 uses | 1 use | 13 uses | **MISSING** |
| expose_php | 8 uses | 1 use | 0 | **MISSING** |
| display_errors | 8 uses | 1 use | 0 | **MISSING** |

Terms checked and found covered (partial list of 12+ verified):
XML-RPC (8 refs), bcrypt (6), Argon2id (4), nonce (2), REST API (7), WAF (8), HSTS (3), CSP (1), Fail2Ban (2), ModSecurity (2), PHP-FPM (1), Snuffleupagus (1), disable_functions (1), must-use plugin (2), wp-config.php (11), brute-force (7).

---

## Coverage Assessment

### Scenarios tested: 3/4

| Scenario | Tested | Findings |
|---|---|---|
| terminology-consistency.md | Yes | 3 FAIL |
| benchmark-structure.md | Yes | 0 FAIL (1 incidental) |
| cross-document-alignment.md | Yes | 5 FAIL |
| authority-hierarchy.md | No | Deferred |

### Scenarios NOT yet tested (from other skill directories)

| Directory | Scenario | Status |
|---|---|---|
| security-researcher/ | source-grounding.md | Not tested |
| security-researcher/ | vendor-editorial-separation.md | Not tested |
| security-researcher/ | verification-with-veloria.md | Not tested |
| cross-skill/ | audit-workflow.md | Not tested |
| cross-skill/ | synthesis-workflow.md | Not tested |
| cross-skill/ | style-guide-protection.md | Not tested |
| wordpress-runbook-ops/ | destructive-command-guard.md | Tested 2026-03-11 |
| wordpress-runbook-ops/ | domain-migration.md | Tested 2026-03-11 |
| wordpress-runbook-ops/ | rollback-and-escalation.md | Not tested |
| wordpress-runbook-ops/ | verification-step.md | Not tested |

---

## Action Items

### Terminology fixes (3 violations) — RESOLVED

1. [x] Benchmark line 772: "admin area" → "Dashboard" (f4b0230)
2. [x] Benchmark line 1805: `` `wp-cli` `` → WP-CLI (f4b0230)
3. [x] Runbook line 3205: "multisite" → "Multisite" (ebd31c0)

### Structural fix (1 discrepancy) — RESOLVED

4. [x] Benchmark appendix control 1.1: L2 → L1 to match body (f4b0230)

### Glossary additions (5 missing terms) — 4 RESOLVED, 1 ALREADY COVERED

5. [x] Style Guide glossary: Added **KSES** entry (76c7cd1)
6. [x] Style Guide glossary: Added **PHP security directives** (grouped entry covering open_basedir, expose_php, display_errors) (76c7cd1)
7. [x] **wp-cron**: Already covered as **WP-Cron** at line 612 — false positive in original test (case-sensitive grep missed it)

Glossary count: 137 → 139. See-also cross-references: 53 → 55.

### Style Guide self-consistency (1 borderline) — RESOLVED

8. [x] Style Guide lines 206 and 610: "admin area"/"administrative interface" → "Dashboard" in both `wp-admin` definitions (§5.3 and glossary) for internal consistency (0fd6340)
