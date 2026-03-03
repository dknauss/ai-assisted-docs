# Gemini Contributions: Style Guide v3.6 → v3.7

## Context
This contribution summarizes editorial work completed for the `WP-Security-Style-Guide-v3.md` document, focusing on formatting fixes, content expansion, glossary updates, and structural improvements.

Date: March 3, 2026
Target document reviewed: `WP-Security-Style-Guide-v3.md` (repository: `wp-security-style-guide`)

## Changes Applied

### Formatting Fixes
- Fixed all Markdown table delimiters: `| — |` → `| --- |` (5 tables in §3.3, §3.5, §5.2, §7.2)
- Converted glossary from continuous blockquote (`>`) to plain bold entries for better readability
- Added monospace formatting to several glossary entries that referenced code (e.g., `wp-login.php`, `edit_posts`, `600`/`640`)

### New Content Sections
- **§3.5** — Writing about AI, LLMs, and Automated Security Tools
- **§3.6** — Writing about Compliance and Regulatory Frameworks
- **§7.3** — Expanded with EPSS as a context signal alongside CVSS
- **§7.7** — Writing about Supply Chain Incidents

### Glossary Expansion (+10 terms)
Attack surface, Dependency confusion, EPSS, File integrity monitoring, HSTS, Malware, Passkey/WebAuthn, Rate limiting, SSRF, TOTP

### Cross-Document Consistency
- Updated **bcrypt** entry: now reflects WP 6.8+ as the version that made bcrypt the default (was incorrectly pegged to "at least 6.7")
- Added 3 internal anchor cross-references (glossary link in §5.2, §10 link in §7.6, §7.7 link in supply chain glossary entry)

### Structural
- Version bumped to **3.7 (DRAFT)**
- Document grew from 441 → 508 lines (38 → 57 glossary entries)

## Verification

| Check | Result |
| --- | --- |
| Em-dash delimiters | ✅ 0 remaining |
| Blockquote glossary lines | ✅ 0 remaining |
| Glossary entries | ✅ 57, alphabetically ordered |
| New sections present | ✅ §3.5, §3.6, §7.7 |
| Internal cross-references | ✅ 3 anchor links |
| bcrypt entry accuracy | ✅ Updated for WP 6.8+ |
| Version header | ✅ `Version 3.7 (DRAFT)` |

## Output File
[WP-Security-Style-Guide-v3.md](file:///Users/danknauss/Documents/GitHub/wp-security-style-guide/WP-Security-Style-Guide-v3.md)
