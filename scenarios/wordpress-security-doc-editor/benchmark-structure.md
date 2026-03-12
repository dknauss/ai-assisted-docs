# Benchmark Control Structure

Skill: wordpress-security-doc-editor
Agent(s): @BenchmarkAgent

Every benchmark control follows the CIS Benchmark format. Missing sections make controls untestable — an auditor can't verify a control without an Audit section, and an engineer can't fix a finding without a Remediation section.

## All CIS format sections are present

**Given** a benchmark control
**When** the control is finalized
**Then** it must contain all of these sections in order:
1. Profile Applicability (Level 1 or Level 2)
2. Assessment Status (Automated or Manual)
3. Description
4. Rationale
5. Impact
6. Audit (verification command or procedure)
7. Remediation (exact configuration or code)
8. Default Value
9. References

### Examples

Fail: A control with Description and Remediation but no Audit section. An auditor cannot verify the control is in place.

Fail: A control with Audit but no Remediation. An engineer can detect the problem but not fix it.

## Audit sections contain runnable commands

**Given** an Automated benchmark control
**When** the Audit section is written
**Then** it must contain a runnable command that returns a deterministic pass/fail result

### Examples

Pass:
```markdown
### Audit
```bash
wp config get DISALLOW_FILE_EDIT
```
Expected: `true`. If the command returns an empty value or `false`, the control is not in place.
```

Fail:
```markdown
### Audit
Check your wp-config.php file to see if DISALLOW_FILE_EDIT is set to true.
```
Not deterministic. "Check your file" is not a command an automated scanner can run.

## REST API controls include current_user_can() guards

**Given** a benchmark control that restricts REST API access
**When** the remediation code is written
**Then** it must include `current_user_can()` checks to avoid breaking the block editor, which relies on the REST API

### Examples

Pass:
```php
add_filter( 'rest_authentication_errors', function( $result ) {
    if ( true === $result || is_wp_error( $result ) ) {
        return $result;
    }
    if ( ! is_user_logged_in() ) {
        return new WP_Error(
            'rest_not_logged_in',
            'Authentication required.',
            array( 'status' => 401 )
        );
    }
    return $result;
} );
```

Fail:
```php
add_filter( 'rest_authentication_errors', function() {
    return new WP_Error( 'rest_disabled', 'REST API disabled.', array( 'status' => 403 ) );
} );
```
Disables the REST API entirely, breaking the block editor for logged-in users.
