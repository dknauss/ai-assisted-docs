# Focused Runbook Review Synthesis — 2026-03-15

## Overview

This synthesis merges the first single-model, multi-agent pass for the focused runbook round. Findings were gathered from:

- `phase1-runbook.md`
- `phase1-benchmark-alignment.md`
- `phase1-hardening-guide.md`
- `phase1-style-guide.md`

## Scope

- Primary target: `/wordpress-runbook-template/WP-Operations-Runbook.md`
- Supporting references: Benchmark, Hardening Guide, Style Guide, and [docs/current-metrics.md](/Users/danknauss/Documents/GitHub/ai-assisted-docs/docs/current-metrics.md)
- Goal: reduce residual runbook risk before another broad four-document review and before the WordPress 7.0 version-reference update pass

## Current Round State

- Deterministic preflight: passed
- Phase 1 specialized agent review: complete
- Human editorial triage: pending
- Canonical Runbook changes: not started

## Prioritized Findings

### Critical

1. Full restore currently deletes the web root and raw MySQL datadir directly with `rm -rf`, which is too dangerous to leave as an approved recovery path.

### High

1. Rollback guidance is incomplete anywhere the runbook mixes release rollback with runtime WordPress.org updates.
2. Deployment procedures still perform live plugin and theme updates during production deploys.
3. Backup directory usage is inconsistent across environment reference, procedures, rollback commands, and quick-reference text.
4. The automated backup script does not set a WordPress path before invoking WP-CLI under cron.
5. Backup upload, verification, and restore commands use inconsistent S3 object paths.
6. Backup generation and restore procedures disagree on `.sql.gz` versus `.sql` database artifacts.
7. `wp db reset --yes` is too destructive as written for shared databases.
8. 2FA scope in the runbook lags the Hardening Guide and Multisite terminology: it should not stop at single-site administrator accounts.
9. The runbook still lacks an operational procedure for action-gated reauthentication / sudo mode aligned to Benchmark 5.5.
10. Backup retention and storage expectations drift from Benchmark 10.1, especially weekly retention and encrypted offsite isolation.

### Medium

1. The runbook still overclaims portability across managed hosting environments while many procedures require self-managed Linux access.
2. Break-glass 2FA recovery currently disables the plugin globally and should move toward per-user recovery or tighter compensating controls.
3. Incident-response procedures do not address application-password revocation even though those credentials bypass 2FA.
4. The glossary and operator vocabulary still need cleanup around `cron` versus `WP-Cron`, `Dashboard` wording, and the ambiguous `WP-CLI OAuth token` label.
5. Public user-enumeration handling is only partially operationalized because the runbook covers REST users but not author-archive enumeration.

## Recommended Implementation Order

1. Fix the restore/recovery path first:
   critical full-restore deletion steps, `wp db reset --yes`, backup artifact mismatches, S3 path mismatches, and rollback dependencies.
2. Fix deployment/update workflow drift next:
   remove live plugin/theme updates from deploy procedures and align rollback expectations to known-good artifacts.
3. Fix auth and access-control operations next:
   broaden 2FA scope, add privileged-action reauthentication, improve break-glass handling, and add application-password incident steps.
4. Finish with scope and terminology cleanup:
   managed-hosting caveats, `Dashboard` wording, glossary alignment, and version-reference updates.

## Finding Disposition Ledger

Every merged finding must end in one archival state: `applied`, `rejected`, or `stale`.

| ID | Finding | Models | Status | Notes |
|---|---|---|---|---|
| R1 | Unsafe full-restore datadir deletion | Single-model multi-agent |  | |
| R2 | Incomplete rollback for runtime updates | Single-model multi-agent |  | |
| R3 | Production deploy performs live plugin/theme updates | Single-model multi-agent |  | |
| R4 | Backup path inconsistency across procedures | Single-model multi-agent |  | |
| R5 | Backup script lacks explicit WordPress path under cron | Single-model multi-agent |  | |
| R6 | Backup upload/restore S3 path mismatch | Single-model multi-agent |  | |
| R7 | Backup artifact format mismatch (`.sql.gz` vs `.sql`) | Single-model multi-agent |  | |
| R8 | `wp db reset --yes` unsafe for shared databases | Single-model multi-agent |  | |
| R9 | 2FA scope too narrow for current hardening guidance and Multisite | Single-model multi-agent |  | |
| R10 | Missing action-gated reauthentication procedure | Single-model multi-agent |  | |
| R11 | Backup retention/storage drift from Benchmark 10.1 | Single-model multi-agent |  | |
| R12 | Managed-hosting scope and terminology cleanup | Single-model multi-agent |  | |

## Next Steps

1. Verify merged findings against the canonical source docs.
2. Record the human editorial decision for each finding.
3. Close the round only after the ledger is complete.
