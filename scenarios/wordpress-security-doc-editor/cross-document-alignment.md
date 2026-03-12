# Cross-Document Alignment

Skill: wordpress-security-doc-editor
Agent(s): @AuditAgent, @SynthesisAgent

The four documents form a coherent set. Controls, versions, and glossary terms must be consistent across all of them. Contradictions between documents erode trust.

## Same control has same classification across documents

**Given** a security control appears in both the Benchmark and the Hardening Guide
**When** the control has a profile level (L1/L2) or classification (baseline/optional)
**Then** the classification must match in both documents

### Examples

Pass:
- Benchmark: File editing restriction — Level 1
- Hardening Guide: File editing restriction — baseline

Fail:
- Benchmark: REST API restriction — Level 1
- Hardening Guide: REST API restriction — optional, defense-in-depth

If the classifications genuinely differ, the discrepancy must be documented with a rationale in both documents.

## Version references match across documents

**Given** a statement like "as of WordPress X.Y" or "requires PHP X.Y+"
**When** the statement appears in multiple documents
**Then** the version numbers must be identical across all documents

### Examples

Fail:
- Benchmark: "As of WordPress 6.5, application passwords are enabled by default."
- Hardening Guide: "As of WordPress 6.4, application passwords are enabled by default."

This is a critical finding — one document has the wrong version.

## Database privilege grants use the 8-privilege specification

**Given** a document contains a MySQL/MariaDB GRANT statement
**When** the statement grants database privileges
**Then** it must use the 8 specific privileges, never `GRANT ALL`

### Examples

Pass:
```sql
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX
ON wordpress_db.* TO 'wp_user'@'localhost';
```

Fail:
```sql
GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wp_user'@'localhost';
```
`GRANT ALL` includes dangerous privileges like `FILE`, `PROCESS`, and `SUPER` that WordPress does not need.

## Glossary covers terms used in 2+ documents

**Given** a technical term is used in two or more documents
**When** the Style Guide glossary is reviewed
**Then** the term must have a glossary entry

### Examples

Pass: "KSES" appears in both Benchmark and Hardening Guide. The Style Guide glossary contains:

```markdown
**KSES** — WordPress's HTML sanitization library. Strips disallowed tags
and attributes from content. Named recursively: "KSES Strips Evil Scripts."
```

Fail: "KSES" appears in two documents but has no glossary entry. Readers encounter it without context.
