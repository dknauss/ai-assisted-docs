# Procedure Schema Completeness

Skill: wordpress-runbook-ops
Agent(s): @RunbookAgent

Every procedure in a runbook must include all required sections in the correct order. Missing sections make runbooks dangerous — operators skip verification, rollback, or escalation because the procedure doesn't mention them.

## All required sections are present

**Given** a runbook procedure
**When** the procedure is finalized
**Then** it must contain all of these sections in this order:
1. Procedure Metadata (Owner, Last Tested, Review Cadence)
2. Purpose
3. Prerequisites
4. Commands
5. Expected Output
6. Rollback
7. Verification
8. Escalate If

### Examples

Pass: A procedure with all eight sections in order.

Fail:
```markdown
## Clear Object Cache

### Commands
```bash
wp cache flush
```

### Expected Output
Success: The cache was flushed.
```
Missing: Metadata, Purpose, Prerequisites, Rollback, Verification, Escalate If.

## Incident response procedures include Last Drill Date

**Given** a procedure classified as incident response or disaster recovery
**When** the procedure metadata is written
**Then** it must include `Last Drill Date` in addition to the standard metadata fields

### Examples

Pass:
```markdown
### Procedure Metadata
- Owner: SRE Team Lead
- Last Tested: 2026-03-01
- Review Cadence: Monthly
- Last Drill Date: 2026-02-15
```

Fail:
```markdown
### Procedure Metadata
- Owner: SRE Team Lead
- Last Tested: 2026-03-01
- Review Cadence: Monthly
```
Missing Last Drill Date on an incident response procedure.

## Routine maintenance omits Last Drill Date

**Given** a procedure for routine maintenance (not incident response)
**When** the procedure metadata is written
**Then** Last Drill Date must be omitted (not present as "N/A")

### Examples

Pass:
```markdown
### Procedure Metadata
- Owner: WordPress Admin
- Last Tested: 2026-03-01
- Review Cadence: Quarterly
```

Fail:
```markdown
### Procedure Metadata
- Owner: WordPress Admin
- Last Tested: 2026-03-01
- Review Cadence: Quarterly
- Last Drill Date: N/A
```
Routine procedures should not include Last Drill Date at all.
