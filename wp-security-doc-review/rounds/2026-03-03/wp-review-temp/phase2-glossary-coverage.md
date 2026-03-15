# Phase 2 — Glossary Coverage Check (Haiku)

Date: 2026-03-03

## Summary

- **Current glossary terms:** 125 entries in WP-Security-Style-Guide.md (Section 8, lines 343–590)
- **Alphabetical ordering issues:** 2 (confirmed from Phase 1)
- **Cross-reference formatting issues:** 4 (confirmed from Phase 1)
- **Missing terms (appear in 2+ documents, no glossary entry):** 7
- **Glossary coverage gaps:** 7 technical terms identified in Phase 1, all confirmed in Phase 2

---

## Current Glossary Terms

All 102 terms, extracted from Section 8 (lines 343–590) in alphabetical order as they appear in the document:

1. 2FA / MFA
2. Account takeover (ATO)
3. Action-gated reauthentication
4. Admin (role)
5. AICPA
6. AI-generated phishing
7. AI-powered tool
8. Anomaly detection
9. Application password
10. Arbitrary file upload
11. Argon2id
12. Attack surface
13. Auth cookie
14. Authentication
15. Authentication keys and salts
16. Authorization
17. Auto-update
18. Backdoor
19. bcrypt
20. BLAKE2b
21. Breach
22. Brute-force attack
23. Build pipeline
24. Capability
25. CDN (Content Delivery Network)
26. Composer
27. Content Security Policy (CSP)
28. CORS (Cross-Origin Resource Sharing)
29. Credential stuffing
30. Cross-Site Request Forgery (CSRF)
31. Cross-Site Scripting (XSS)
32. CVE
33. CVSS
34. Cybercriminal
35. Dashboard
36. Deepfake
37. Denial of service (DoS) / Distributed denial of service (DDoS)
38. Dependency confusion
39. DISALLOW_FILE_EDIT
40. DISALLOW_FILE_MODS
41. Directory traversal
42. DOM-based XSS
43. EPSS
44. Fail2Ban
45. FedRAMP
46. File integrity monitoring
47. FUD
48. FORCE_SSL_ADMIN
49. GDPR
50. GPU-accelerated brute-force attack
51. Hardening
52. HIPAA
53. HMAC
54. HSTS
55. Incident response
56. Information disclosure
57. Infostealer
58. Insecure AI-generated code
59. IoC (Indicators of Compromise)
60. Local file inclusion (LFI) / Remote file inclusion (RFI)
61. Malware
62. Malware signature
63. ModSecurity
64. Multisite
65. mu-plugin (must-use plugin)
66. NIST SP 800-53
67. Nonce
68. npm
69. Object cache
70. OWASP Top 10
71. Passkey / WebAuthn
72. Patch / Patching
73. Path traversal
74. PCI DSS
75. Phishing
76. phpass
77. Plugin
78. Plugin ownership transfer
79. PoC (Proof of Concept)
80. Prevention
81. Principle of Least Privilege (PoLP)
82. Privilege escalation
83. Prompt injection
84. Rate limiting
85. Reflected XSS
86. Remote code execution (RCE)
87. Resilience
88. Responsible disclosure
89. REST API
90. Rogue commit
91. Role
92. SBOM (Software Bill of Materials)
93. SHA-384
94. Shadow AI
95. Session hijacking
96. Severity rating
97. SOC 2
98. Sodium
99. SQL injection (SQLi)
100. SSRF (Server-Side Request Forgery)
101. Stored XSS
102. Supply chain attack
103. Super Admin
104. Theme
105. Threat actor
106. TOTP
107. TLS (Transport Layer Security)
108. Training-data poisoning
109. Transient
110. User enumeration
111. Virtual patching
112. Vulnerability
113. Vulnerability disclosure
114. WAF
115. Wordfence
116. wp-admin
117. wp-config.php
118. WP-CLI
119. WP-Cron
120. wp-login.php
121. xmlrpc.php
122. XML-RPC
123. XXE (XML eXternal Entity)
124. Zero-day
125. Zero Trust

**Total count:** 125 distinct glossary entries (note: "Directory traversal" at line 423 is a cross-reference to "Path traversal," not a separate entry).

---

## Missing Terms (appear in 2+ documents, no glossary entry)

| # | Term | Benchmark | Hardening Guide | Runbook | Status | Recommendation |
|---|---|---|---|---|---|---|
| 1 | **SIEM** (Security Information and Event Management) | Yes (2 refs) | Yes (1 ref) | No | Confirmed from Phase 1 | Add entry in S section between "Shadow AI" and "SOC 2" |
| 2 | **UFW** (Uncomplicated Firewall) | Yes (6 refs) | Yes (1 ref) | Yes (1 ref) | Confirmed from Phase 1; **now appears in 3 documents** | Add entry in U section between "User enumeration" and "Virtual patching" |
| 3 | **PHP-FPM** (FastCGI Process Manager) | Yes (9 refs) | No | Yes (7 refs) | Confirmed from Phase 1; **appears in 2 documents** | Add entry in P section between "Phishing" and "phpass" |
| 4 | **AIDE** (Advanced Intrusion Detection Environment) | Yes (1 ref) | No | Yes (7 refs) | Confirmed from Phase 1; **now appears in 2 documents per recount** | Add entry in A section between "AI-powered tool" and "Anomaly detection" |
| 5 | **Snuffleupagus** | Yes (1 ref) | Yes (1 ref) | No | Confirmed from Phase 1 | Add entry in S section between "Session hijacking" and "Severity rating" |
| 6 | **SIM-swapping** | Yes (1 ref) | Yes (1 ref) | No | Confirmed from Phase 1 | Add entry in S section between "SHA-384" and "Shadow AI" |
| 7 | **Ransomware** | Yes (1 ref) | Yes (1 ref) | Yes (2 refs) | Confirmed from Phase 1; **now appears in all 3 documents** | Add entry in R section between "Rate limiting" and "Reflected XSS" |

---

## Alphabetical Ordering Issues

**Status:** 2 HIGH-severity issues confirmed from Phase 1, not yet corrected.

### Issue 1: `FORCE_SSL_ADMIN` out of order (Line 437)

**Current state:** `FUD` (line 435) appears **before** `FORCE_SSL_ADMIN` (line 437).

**Alphabetical requirement:** "FO" (in `FORCE_SSL_ADMIN`) precedes "FU" (in `FUD`) because 'O' (ASCII 79) < 'U' (ASCII 85).

**Correct sequence should be:**
- File integrity monitoring
- **FORCE_SSL_ADMIN** ← move here
- **FUD**
- GDPR

**Verification:** Inspect lines 433–439 in current file.

---

### Issue 2: `mu-plugin` out of order (Line 471)

**Current state:** `Multisite` (line 469) appears **before** `mu-plugin` (line 471).

**Alphabetical requirement:** When comparing "Mu-p" vs. "Multis" case-insensitively, the hyphen character (ASCII 45) precedes 'l' (ASCII 108), so `mu-plugin` must come **before** `Multisite`.

**Correct sequence should be:**
- ModSecurity
- **mu-plugin** ← move here
- **Multisite**
- NIST SP 800-53

**Verification:** Inspect lines 467–474 in current file.

---

## Cross-Reference Issues

**Status:** 4 formatting errors confirmed from Phase 1, not yet corrected.

All cross-references in the glossary that point to other glossary terms must use **italic format** (`*TermName*`) to match the convention used throughout the glossary. Monospace backtick format (`` `term` ``) should only be used for file paths and code, not for glossary links.

### Issue 1: Line 463 — `Malware` entry

**Current:** `See also: infostealer.`

**Problem:** Target term `infostealer` is neither italicized (`*infostealer*`) nor capitalized to match its glossary heading (`**Infostealer**`).

**Correction:** Change to `See also: *Infostealer*.`

---

### Issue 2: Line 573 — `wp-admin` entry

**Current:** `See also: Dashboard, \`wp-login.php\`.`

**Problem:** `wp-login.php` is a glossary entry (line 581) and should be italicized (`*wp-login.php*`), not monospaced. Monospace backticks are correct for file paths in prose but not for glossary cross-references.

**Correction:** Change to `See also: *Dashboard*, *wp-login.php*.`

---

### Issue 3: Line 581 — `wp-login.php` entry

**Current:** `See also: *brute-force attack*, \`wp-admin\`.`

**Problem:** `wp-admin` is a glossary entry (line 573) and should be italicized (`*wp-admin*`), not monospaced.

**Correction:** Change to `See also: *brute-force attack*, *wp-admin*.`

---

### Issue 4: Line 587 — `XXE` entry

**Current:** `See also: *XML-RPC*, \`xmlrpc.php\`.`

**Problem:** `xmlrpc.php` is a glossary entry (line 583) and should be italicized (`*xmlrpc.php*`), not monospaced.

**Correction:** Change to `See also: *XML-RPC*, *xmlrpc.php*.`

---

## Verification of Existing Cross-References

All other italicized cross-references in the glossary were spot-checked and confirmed to point to existing glossary entries. No broken links detected among the correctly formatted cross-references.

---

## Recommendations for Phase 3

1. **Correct alphabetical ordering** (Issues 1 & 2): Move `FORCE_SSL_ADMIN` before `FUD` and move `mu-plugin` before `Multisite`.

2. **Fix cross-reference formatting** (Issues 1–4): Convert 4 monospace cross-references to italic format to match the glossary convention.

3. **Add 7 missing terms:**
   - **AIDE** (in A section)
   - **PHP-FPM** (in P section)
   - **Ransomware** (in R section)
   - **SIEM** (in S section)
   - **SIM-swapping** (in S section)
   - **Snuffleupagus** (in S section)
   - **UFW** (in U section)

4. **Verify insertion sequence:** Ensure new terms maintain alphabetical order. The S section will have three new entries; verify the ordering of SHA-384 → SIM-swapping → Snuffleupagus → Shadow AI.

---

## Notes on Scope

- Phase 1 identified 13 findings across the Style Guide; Phase 2 validates cross-document glossary coverage against the other three documents (Benchmark, Hardening Guide, Runbook).
- The threshold for mandatory glossary entry is **2 or more documents** citing the term (per AGENTS.md constraint).
- Terms appearing only in the Runbook's own embedded glossary (e.g., LEMP) or only once across all documents are excluded.
- All 7 missing terms meet the 2+ document threshold and are prioritized by frequency (UFW in 3 documents, Ransomware in 3, others in 2).
