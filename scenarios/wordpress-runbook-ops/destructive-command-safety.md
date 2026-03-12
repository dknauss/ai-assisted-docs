# Destructive Command Safety

Skill: wordpress-runbook-ops
Agent(s): @RunbookAgent

Destructive operations must be preceded by backup steps and followed by verification. Rollback sections must contain concrete commands, not guidance prose.

## Destructive commands have preceding backup steps

**Given** a procedure containing a destructive command (search-replace, database mutation, file deletion, plugin deactivation)
**When** the Commands section is written
**Then** a backup or snapshot step must appear before the destructive command in the same procedure

### Examples

Pass:
```bash
# Backup database before search-replace
wp db export /tmp/backup-$(date +%Y%m%d-%H%M%S).sql

# Dry run first
wp search-replace 'http://old.example.com' 'https://new.example.com' --dry-run

# Execute
wp search-replace 'http://old.example.com' 'https://new.example.com'
```

Fail:
```bash
wp search-replace 'http://old.example.com' 'https://new.example.com'
```
No backup. No dry run. An operator running this at 2 AM could destroy data with no recovery path.

## Destructive warnings are immediately before destructive commands

**Given** a command that modifies or deletes data
**When** the command appears in the Commands section
**Then** a warning comment must appear on the line immediately preceding the command

### Examples

Pass:
```bash
# WARNING: This drops all transients. Cached data will be regenerated on next request.
wp transient delete --all
```

Fail:
```bash
# This section clears caches for the site.

wp transient delete --all
wp cache flush
```
Warning is separated from the destructive commands by a blank line. Operators scanning for copy-paste commands may miss it.

## Rollback contains concrete commands

**Given** a procedure with a Rollback section
**When** the section is written
**Then** it must contain specific, runnable commands — not guidance prose

### Examples

Pass:
```markdown
### Rollback
1. Restore the database from the backup taken in step 1:
```bash
wp db import /tmp/backup-YYYYMMDD-HHMMSS.sql
```
2. Flush caches:
```bash
wp cache flush
```
```

Fail:
```markdown
### Rollback
- If something goes wrong, restore from your backup.
- Contact your hosting provider if needed.
```
Not actionable. An operator needs exact commands, not suggestions.
