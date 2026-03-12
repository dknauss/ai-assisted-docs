# Authority Hierarchy

Skill: wordpress-security-doc-editor
Agent(s): @BenchmarkAgent, @HardeningGuideAgent, @StyleGuideAgent, @AuditAgent

When sources conflict, precedence follows a fixed order. Deviations from higher-authority sources must be flagged and labeled as conditional. Silently contradicting WordPress Developer Documentation is a critical finding.

## WordPress Developer Docs outrank external standards

**Given** a security recommendation
**When** the WordPress Developer Documentation says one thing and an external standard (OWASP, CIS, NIST) says something different
**Then** the WordPress Developer Documentation prevails for WordPress-specific topics, and the deviation must be labeled conditional with a stated rationale

### Examples

Pass:
```markdown
The WordPress Developer Handbook recommends using `wp_kses_post()` for
post content sanitization. While OWASP's XSS Prevention Cheat Sheet suggests
context-specific encoding functions, WordPress's KSES library is the primary
tool within the WordPress ecosystem. Use `wp_kses_post()` for post content
and `esc_html()` / `esc_attr()` for other contexts.
```

Fail:
```markdown
Use OWASP's recommended `htmlspecialchars()` for all output escaping.
```
Contradicts WordPress core's escaping API without acknowledgment. WordPress provides `esc_html()`, `esc_attr()`, `esc_url()`, and `wp_kses_*()` — these are the correct functions in a WordPress context.

## Core source is authoritative for hooks and constants

**Given** a claim about a WordPress constant, hook, filter, or function
**When** the claim appears in any document
**Then** the behavior described must match WordPress core source code, verified via the Code Reference or Veloria

### Examples

Pass:
```markdown
Setting `DISALLOW_FILE_EDIT` to `true` prevents editing plugin and theme files
through the WordPress Dashboard editor. It does not prevent file uploads
or plugin installation.
```
Accurately describes the constant's scope per core source.

Fail:
```markdown
Setting `DISALLOW_FILE_EDIT` to `true` prevents all file modifications
on the server.
```
Overstates the constant's scope. It only disables the in-Dashboard file editor.

## Deviations are labeled conditional

**Given** a recommendation that deviates from a higher-precedence source
**When** the recommendation is included in a document
**Then** it must be labeled as conditional or environment-specific with a rationale

### Examples

Pass:
```markdown
**Conditional — environment-specific:** Some managed hosts disable
`DISALLOW_FILE_MODS` at the server level, making this constant redundant.
Verify with your hosting provider before relying on it as a control.
```

Fail:
```markdown
Always set `DISALLOW_FILE_MODS` to `true`.
```
Does not account for environments where this is managed at the server level. Missing conditional label.
