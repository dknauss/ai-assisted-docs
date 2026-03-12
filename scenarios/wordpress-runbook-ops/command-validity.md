# Command Validity

Skill: wordpress-runbook-ops
Agent(s): @RunbookAgent

Every WP-CLI command in a runbook must be a real command with correct flags. Fabricated subcommands or nonexistent flags cause silent failures or confusing errors for operators.

## WP-CLI commands use real subcommands and flags

**Given** a runbook procedure with WP-CLI commands
**When** the commands are finalized
**Then** every `wp` command must be verifiable against `wp help <command>` — correct subcommand, correct flags, correct argument syntax

### Examples

Pass:
```bash
wp plugin list --status=active --fields=name,version,update
```

Fail:
```bash
wp plugin list --status=active --field=name,version,update
```
`--field` (singular) is not a valid flag for `wp plugin list`. The correct flag is `--fields` (plural).

Fail:
```bash
wp db check --repair
```
`--repair` is not a valid flag for `wp db check`. The repair command is `wp db repair`.

## Plugin-dependent commands are annotated

**Given** a command that requires a specific plugin to be installed
**When** the command appears in a runbook
**Then** it must be commented out with the exact annotation pattern: `# Plugin-dependent - uncomment the cache plugin(s) in use:`

### Examples

Pass:
```bash
# Plugin-dependent - uncomment the cache plugin(s) in use:
# wp w3-total-cache flush all
# wp wp-super-cache flush
```

Fail:
```bash
wp w3-total-cache flush all
```
Not annotated. An operator without W3 Total Cache installed gets an unexplained error.

## Placeholders use the explicit format

**Given** a command containing environment-specific values
**When** the command is written
**Then** placeholders must use the format `[CUSTOMIZE: description]`

### Examples

Pass:
```bash
wp search-replace '[CUSTOMIZE: old_url]' '[CUSTOMIZE: new_url]' --dry-run
```

Fail:
```bash
wp search-replace 'OLD_URL' 'NEW_URL' --dry-run
```
`OLD_URL` looks like it could be a literal value. The `[CUSTOMIZE: ...]` pattern makes it unambiguous that the operator must substitute their own values.
