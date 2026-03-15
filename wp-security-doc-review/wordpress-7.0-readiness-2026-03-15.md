# WordPress 7.0 Readiness Brief — 2026-03-15

This brief captures the next cross-document version-reference update pass for the canonical WordPress security document set.

The immediate goal is to avoid drifting into stale `WordPress 6.x` and `PHP 8.2+` framing as WordPress 7.0 approaches.

## Verified External Facts

1. WordPress 7.0 is currently scheduled for release on **April 9, 2026**.
   Source: [WordPress 7.0 Release Party Schedule](https://make.wordpress.org/core/2026/02/12/wordpress-7-0-release-party-schedule/).
2. The public WordPress requirements page currently recommends **PHP 8.3 or greater**.
   Source: [Requirements](https://wordpress.org/about/requirements/).
3. Core has already announced that WordPress 7.0 will drop support for PHP 7.2 and 7.3, making **PHP 7.4** the minimum supported version.
   Source: [Dropping support for PHP 7.2 and 7.3](https://make.wordpress.org/core/2026/01/09/dropping-support-for-php-7-1-2/).
4. Core currently describes WordPress as fully compatible with **PHP 8.0 to 8.3** and **beta compatible with PHP 8.4 and 8.5**.
   Source: [Dropping support for PHP 7.2 and 7.3](https://make.wordpress.org/core/2026/01/09/dropping-support-for-php-7-1-2/).

## Current Canonical Version-Reference Surface

### Benchmark

| Current reference | Why it needs review |
|---|---|
| `subtitle: "Full Stack Hardening Guide — WordPress 6.x on Linux (Ubuntu/Debian)"` | Hard-codes the current major version in the title metadata. |
| `WordPress 6.x (latest stable release recommended)` | Still framed around the previous major series. |
| `PHP 8.2+ (8.3+ recommended for new deployments)` | Likely too conservative now that WordPress.org recommends PHP 8.3+. |
| `As of WordPress 6.8` password-hashing note | Technically correct, but should be rechecked once the 7.0 sweep lands so all version references use consistent framing. |

### Hardening Guide

| Current reference | Why it needs review |
|---|---|
| `As of WordPress 6.8` password-hashing paragraph | Still correct, but should be reviewed for wording consistency after 7.0 ships. |
| `As of 2026, PHP 8.2 is in security-only support and PHP 8.3+ is recommended for new deployments.` | Needs a fresh editorial decision on whether to keep `8.3+` as the primary recommendation and how to mention PHP 8.4. |

### Runbook

| Current reference | Why it needs review |
|---|---|
| PHP upgrade note says `Replace 8.2 below with your target PHP version (for example, 8.3)` | This is the most obvious place to add a PHP 8.4 staging/testing note. |
| Runbook currently has little explicit WordPress-major-version framing | Good for longevity, but the runbook-only review should flag any operational steps that assume a pre-7.0 environment. |

### Style Guide

| Current reference | Why it needs review |
|---|---|
| Example prose uses `WordPress 6.5.2` and `WordPress 6.5` | These are examples rather than policy, but they will look stale quickly after 7.0. |
| `phpass` glossary entry says `WordPress 6.8 (April 2025) replaced phpass with bcrypt as the default.` | This is historically correct, but the line should be rechecked for consistency with whatever version-framing convention the rest of the set adopts post-7.0. |

## Editorial Recommendations

1. Run a dedicated cross-document version sweep before April 9, 2026.
2. Remove unnecessary `WordPress 6.x` framing where the guidance is version-stable. Prefer evergreen language unless the major version is materially relevant.
3. Update normative PHP recommendations to align with the current public project posture:
   - keep **PHP 8.3+** as the default recommendation today
   - treat **PHP 8.4** as worth testing and planning for, but label it carefully as a newer target that still requires ecosystem validation
4. Use the focused Runbook review round in [rounds/2026-03-15/README.md](/Users/danknauss/Documents/GitHub/ai-assisted-docs/wp-security-doc-review/rounds/2026-03-15/README.md) to surface any runbook procedures that need 7.0- or 8.4-specific caveats.
5. After canonical edits land, regenerate all downstream outputs and spot-check the generated `DOCX`, `PDF`, and `EPUB` artifacts for version-reference consistency.

## Recommended PHP 8.4 Editorial Position

The current docs should not jump straight from `PHP 8.3+ recommended` to a blanket `PHP 8.4+ recommended` statement.

The safer near-term position is:

- Recommend **PHP 8.3+** for current production deployments.
- Add a brief note that **PHP 8.4** is now on the editorial radar and should be tested in staging for compatibility with WordPress, plugins, themes, and hosting stack components.
- Revisit whether to elevate PHP 8.4 into the default recommendation after the WordPress 7.0 sweep and any ecosystem validation the runbook review surfaces.

This is an editorial recommendation based on current project and hosting signals, not a claim that every WordPress deployment is immediately ready for PHP 8.4 in production.

## Definition Of Done

- All four canonical docs have been searched for version-specific WordPress and PHP references.
- Every normative version reference has been either updated or explicitly left unchanged with a reason.
- Benchmark, Hardening Guide, Runbook, and Style Guide use compatible wording for WordPress 7.0 and PHP recommendations.
- Regenerated outputs reflect the final wording cleanly across Markdown, DOCX, PDF, and EPUB.
