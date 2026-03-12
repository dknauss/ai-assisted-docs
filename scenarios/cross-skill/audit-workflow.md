# Audit Workflow

Skill: wordpress-security-doc-editor
Agent(s): @AuditAgent

The audit agent produces findings, not changes. Every finding must be structured, evidence-based, and distinguish verified facts from suspected issues. Overclaimed findings erode editorial trust.

## Findings are structured, not narrative

**Given** an audit of the document set
**When** the audit agent produces output
**Then** each finding must be a structured record with all required fields

Required fields:
| Field | Description |
|---|---|
| Document | Which document contains the finding |
| Location | Section and/or line number |
| Finding | What is wrong or inconsistent |
| Severity | Critical / High / Medium / Low |
| Recommendation | Specific fix |
| Verification | How to confirm the fix |
| Status | Verified / Open Question |

### Examples

Pass:
```markdown
| Field | Value |
|---|---|
| Document | Security Benchmark |
| Location | Section 4.2, Audit block |
| Finding | `wp config get DISALLOW_FILE_EDIT` — correct command but expected output says "1" instead of "true" |
| Severity | Medium |
| Recommendation | Change expected output to "true" (WP-CLI returns the string value, not a boolean) |
| Verification | Run `wp config get DISALLOW_FILE_EDIT` on a test site with the constant set |
| Status | Verified |
```

Fail:
```
The Benchmark has some issues with the file editing section. The audit
command might return unexpected results. Should probably review this.
```
No structure. No specific location. No severity. Not actionable.

## Verified vs. Open Question distinction is maintained

**Given** an audit finding
**When** the auditor is not certain about the finding
**Then** the finding must be marked "Open Question" — never "Verified"

### Examples

Pass:
```markdown
| Status | Open Question |
| Finding | Hardening Guide references `WP_AUTO_UPDATE_CORE` behavior that may
           have changed in WordPress 6.8. Needs verification against core source. |
```

Fail:
```markdown
| Status | Verified |
| Finding | Hardening Guide's `WP_AUTO_UPDATE_CORE` documentation is outdated. |
```
If it "may have changed" and hasn't been checked, it's not verified. Overclaiming erodes trust.

## Audit produces no changes

**Given** an audit workflow
**When** findings are produced
**Then** the audit agent must not modify any source documents — findings are recommendations only

This is a hard boundary from AGENTS.md section 6: "Never apply changes. Produce findings only. The human editor decides what to act on."
