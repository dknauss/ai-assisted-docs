# Terminology Consistency

Skill: wordpress-security-doc-editor
Agent(s): @StyleGuideAgent, @AuditAgent

All four documents must use the same terminology. Inconsistent terms confuse readers who use multiple documents together.

## Required terminology is used

**Given** any document in the security series
**When** the document discusses security concepts
**Then** it must use the prescribed terminology

| Required term | Disallowed alternatives |
|---|---|
| `allowlist` | whitelist |
| `denylist` | blacklist |
| `threat actor` or `attacker` | hacker (when meaning someone malicious) |
| `Dashboard` (capitalized) | backend, admin panel, admin area |
| `plugin` (lowercase in running text) | Plugin (unless starting a sentence) |
| `Multisite` (one word, capitalized) | Multi-site, multi site, multisite (lowercase) |
| `Auto-update` (hyphenated) | Autoupdate, auto update |
| `WP-CLI` (hyphenated, all caps) | wp-cli, WPCLI, wp cli |
| `WordPress` | Wordpress, wordpress, WP (in running text) |

### Examples

Pass:
```
Add the IP address to the allowlist in your security plugin's settings.
```

Fail:
```
Add the IP address to the whitelist in your security plugin's settings.
```

Pass:
```
A threat actor could exploit this vulnerability to gain admin access.
```

Fail:
```
A hacker could exploit this vulnerability to gain admin access.
```

## Terminology is consistent across documents

**Given** a term appears in multiple documents
**When** the documents are reviewed together
**Then** the same concept must use the same term in all four documents

### Examples

Fail:
- Benchmark uses "allowlist"
- Runbook uses "whitelist" for the same concept

This is a cross-document consistency finding at severity High.
