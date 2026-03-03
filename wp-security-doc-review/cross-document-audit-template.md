# Cross-Document Audit Template

Reusable checklist for auditing the four WordPress security documents against each other. Run this after any significant revision to any document.

## Pre-Audit Setup

1. Pull latest from all four repos.
2. Note the current version and date in each document's YAML frontmatter.
3. Record the commit hash at audit start for each repo.

## Checklist

### Technical Accuracy

- [ ] All `wp-config.php` constants match WordPress core behavior for the stated version.
- [ ] No deprecated constants appear in examples without a deprecation note.
- [ ] PHP version requirements are consistent (e.g., Argon2id requires 7.3+, not 7.2+).
- [ ] WordPress version floor for auto-updates is consistent (3.7, not 4.1).
- [ ] Database privilege grants use least-privilege (8 specific privileges, never `GRANT ALL`).
- [ ] `DISABLE_WP_CRON` is always paired with system cron replacement guidance.
- [ ] REST API endpoint removal includes `current_user_can()` guards.

### WP-CLI Commands (Benchmark and Runbook)

- [ ] Every `wp` command is a real WP-CLI core command or is annotated as plugin-dependent.
- [ ] Flag syntax is correct (`--fields` not `--field` for multi-value, `--post_type=any` not `=all`).
- [ ] No compound flags that don't exist (`--global`, `--repair` on `wp db check`).
- [ ] Plugin-dependent commands (`wp w3-total-cache`, `wp redis`, `wp wordfence`) are commented as such.
- [ ] Commands that were removed or renamed are updated (e.g., `wp db table list` to `wp db tables`).

### Cross-Document Consistency

- [ ] Same control has the same baseline/optional or L1/L2 classification across documents.
- [ ] When Benchmark prescribes a specific remediation, Runbook's procedure matches.
- [ ] Hardening Guide's strategic recommendations don't contradict Benchmark's prescriptive controls.
- [ ] All four documents have the same Related Documents section with correct links.
- [ ] Version numbers in "as of WordPress X.Y" statements are consistent.

### Code Block Quality

- [ ] No markdown escaping inside fenced code blocks (`\|`, `\*`, `\_`, `\[`).
- [ ] `grep -E` uses bare `|` for ERE alternation (never `\|`).
- [ ] Nginx config blocks use correct directive syntax.
- [ ] PHP snippets have no closing `?>` tag.
- [ ] SQL examples use correct MySQL/MariaDB syntax for the stated version.

### Style Guide Glossary Coverage

- [ ] Every technical term used in 2+ of the other documents has a glossary entry.
- [ ] Glossary entries are alphabetically ordered.
- [ ] Cross-references within glossary entries point to terms that actually exist.
- [ ] New terms added during this round are reflected in the glossary.

### Infrastructure

- [ ] YAML frontmatter is present and well-formed in all four documents.
- [ ] `generate-docs.yml` workflow succeeds (PDF, DOCX, EPUB).
- [ ] Date in frontmatter matches the build date (updated by CI).
- [ ] Version in frontmatter matches the git tag.

## Audit Output

For each finding, record:

| Field | Description |
|---|---|
| **Document** | Which document(s) are affected |
| **Location** | Section number and/or line number |
| **Finding** | What is wrong or inconsistent |
| **Severity** | Critical / High / Medium / Low |
| **Recommendation** | What should change |
| **Verification** | How to confirm the fix is correct |
| **Status** | Open / Fixed / Rejected (with reason) |
