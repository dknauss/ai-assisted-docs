# BDD Cycle Test: Domain Migration Runbook

**Date:** 2026-03-11
**Skill tested:** `wordpress-runbook-ops`
**Procedure type:** Routine maintenance
**Test subject:** Domain Migration (URL Search-Replace)

## Method

1. Generated a complete runbook procedure using the `wordpress-runbook-ops` skill constraints.
2. Checked the output against all 4 scenario files in `scenarios/wordpress-runbook-ops/`.
3. Each scenario's Then-clause was evaluated as Pass, Fail, or N/A with evidence.

## Prompt

> Write a runbook procedure for migrating a WordPress site's domain (URL change via search-replace).

## Results Summary

| Scenario File | Scenario | Result |
|---|---|---|
| procedure-schema-completeness | All required sections present | Pass |
| procedure-schema-completeness | Incident response includes Last Drill Date | N/A (routine) |
| procedure-schema-completeness | Routine maintenance omits Last Drill Date | Pass |
| destructive-command-safety | Destructive commands have preceding backup | Pass |
| destructive-command-safety | Warnings immediately before destructive commands | **Fail** |
| destructive-command-safety | Rollback contains concrete commands | Pass |
| command-validity | WP-CLI commands use real subcommands and flags | Pass |
| command-validity | Plugin-dependent commands are annotated | Pass |
| command-validity | Placeholders use explicit format | Pass |
| code-fence-integrity | Closing fences are bare | Pass |
| code-fence-integrity | Opening/closing fence count match | Pass |
| code-fence-integrity | No markdown escaping inside code blocks | Pass |

**Score: 10/11 passed, 1 failed, 1 N/A**

## Failure Detail

### destructive-command-safety: Warnings immediately before destructive commands

`wp rewrite flush` regenerates rewrite rules and may modify `.htaccess`. The line immediately before it was a step label, not a WARNING:

```
# 7. Flush rewrite rules and object cache
wp rewrite flush
```

The scenario requires a warning comment on the line immediately preceding the destructive command. Corrected:

```
# 7. Flush rewrite rules and object cache
# WARNING: This regenerates rewrite rules and may modify .htaccess.
wp rewrite flush
```

## Bonus Finding (scenario gap)

The verification section contained:

```bash
wp post list --fields=ID --posts_per_page=5 --format=ids | xargs -I {} wp post get {} --field=content | grep -c '[CUSTOMIZE: old_domain]'
```

The `[CUSTOMIZE: old_domain]` brackets are interpreted by grep as a character class, not a literal string. The correct command would use `grep -Fc` (fixed-string mode). This falls in a gap between current scenarios:

- **command-validity** checks WP-CLI flags but not shell pipeline correctness.
- **code-fence-integrity** checks markdown escaping but not shell metacharacter semantics.

Potential new scenario: **"Verification commands produce deterministic results"** under `command-validity.md` or a new `verification-correctness.md`.

## Observations

1. **Scenarios catch real defects.** The missing WARNING is the kind of oversight an operator would miss during a late-night migration.
2. **Coverage gaps are identifiable.** The grep character-class bug reveals where new scenarios could add value.
3. **Pass/fail is unambiguous.** The Given/When/Then structure eliminates subjective judgment.
4. **N/A is a valid result.** The incident-response scenario correctly didn't apply to routine maintenance, which itself validated the complementary scenario (routine procedures omit Last Drill Date).
