#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: bash tools/review/bootstrap_round.sh [YYYY-MM-DD]

Creates a new review-round directory with:
  - README.md
  - EXECUTION-GUIDE.md
  - review-prompt.md
  - metrics-snapshot.md
  - synthesis.md

Environment:
  ROUND_ROOT  Optional override for the rounds directory (useful for testing).
EOF
}

if [[ "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ROUND_ROOT="${ROUND_ROOT:-${ROOT_DIR}/wp-security-doc-review/rounds}"
ROUND_DATE="${1:-$(date +%F)}"
ROUND_DIR="${ROUND_ROOT}/${ROUND_DATE}"
METRICS_FILE="${ROOT_DIR}/docs/current-metrics.md"

if [[ ! -f "$METRICS_FILE" ]]; then
  echo "Missing metrics source file: $METRICS_FILE"
  exit 1
fi

if [[ -e "$ROUND_DIR" ]]; then
  echo "Round directory already exists: $ROUND_DIR"
  exit 1
fi

mkdir -p "$ROUND_DIR"

last_verified="$(sed -n 's/^Last verified: //p' "$METRICS_FILE" | head -n 1)"

cat > "${ROUND_DIR}/metrics-snapshot.md" <<EOF
# Review Metrics Snapshot — ${ROUND_DATE}

Generated from [docs/current-metrics.md](/Users/danknauss/Documents/GitHub/ai-assisted-docs/docs/current-metrics.md) on ${ROUND_DATE}.
Do not hand-edit volatile counts here; regenerate from the metrics source if needed.

Last metrics verification recorded in source: ${last_verified}

## Canonical Document Set
$(awk '
  /^### Canonical Document Set/ { flag=1 }
  flag { print }
  /^### Files that reference these counts/ { exit }
' "$METRICS_FILE")

## Cross-Repo Document Metrics
$(awk '
  /^## Cross-Repo Document Metrics/ { flag=1 }
  flag { print }
  /^### Cross-Repo Verification/ { exit }
' "$METRICS_FILE")

## Phase Completion
$(awk '
  /^## Phase Completion/ { flag=1 }
  flag { print }
  /^## Update Procedure/ { exit }
' "$METRICS_FILE")
EOF

cat > "${ROUND_DIR}/README.md" <<EOF
# Multi-Model Editorial Review — ${ROUND_DATE}

## Status

Round bootstrapped. Run \`bash tools/ci/review_preflight.sh\` before any model execution.

## Documents Under Review

| Document | Path |
|---|---|
| WordPress Security Benchmark | \`/wp-security-benchmark/WordPress-Security-Benchmark.md\` |
| WordPress Security Hardening Guide | \`/wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md\` |
| WP Operations Runbook | \`/wordpress-runbook-template/WP-Operations-Runbook.md\` |
| WP Security Style Guide | \`/wp-security-style-guide/WP-Security-Style-Guide.md\` |

## Metrics Source Of Truth

- Canonical source: [docs/current-metrics.md](/Users/danknauss/Documents/GitHub/ai-assisted-docs/docs/current-metrics.md)
- Round snapshot: \`metrics-snapshot.md\`

## Review Prompt

See: \`review-prompt.md\`

## Execution

1. Run \`bash tools/ci/review_preflight.sh\`.
2. Submit the four canonical documents plus \`review-prompt.md\` to each independent model.
3. Save outputs as \`gemini-review.md\`, \`gpt-review.md\`, and \`claude-review.md\`.
4. Merge findings into \`synthesis.md\`.
5. Close the round only after every merged finding ends as \`applied\`, \`rejected\`, or \`stale\`.

## Next Step

Run preflight, then collect the independent review outputs.
EOF

cat > "${ROUND_DIR}/EXECUTION-GUIDE.md" <<EOF
# Multi-Model Review Execution Guide

## Before Running Any Models

1. Run \`bash tools/ci/review_preflight.sh\`.
2. Use [docs/current-metrics.md](/Users/danknauss/Documents/GitHub/ai-assisted-docs/docs/current-metrics.md) as the source of truth for current document counts, line totals, and phase status.
3. Use \`metrics-snapshot.md\` for the round-start snapshot generated from the current metrics source.
4. If the preflight finds a mechanical issue, either fix it first or record it explicitly before asking models to review the documents.

## Documents To Upload

1. \`/wp-security-benchmark/WordPress-Security-Benchmark.md\`
2. \`/wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md\`
3. \`/wordpress-runbook-template/WP-Operations-Runbook.md\`
4. \`/wp-security-style-guide/WP-Security-Style-Guide.md\`

For any volatile count or status reference, point reviewers at \`docs/current-metrics.md\` or \`metrics-snapshot.md\` rather than copying numbers into ad hoc notes.

## Output Files

Save each model's output as:
- \`gemini-review.md\`
- \`gpt-review.md\`
- \`claude-review.md\`

Place them in: \`wp-security-doc-review/rounds/${ROUND_DATE}/\`

## After Completion

1. Save each model output in the round directory.
2. Run synthesis and verify every merged finding ends in one archival state: \`applied\`, \`rejected\`, or \`stale\`.
3. Update \`README.md\` to reflect the current round state.
4. Re-verify cross-repo metrics after approved fixes land in the canonical repos.
EOF

cat > "${ROUND_DIR}/review-prompt.md" <<'EOF'
# Multi-Model Editorial Review

## Review Prompt

You are reviewing four companion WordPress security documents for technical accuracy, cross-document consistency, and alignment with authoritative sources.

## Instructions

1. Review all four documents below.
2. For each finding, provide:
   - **Document**: Which document contains the issue.
   - **Location**: Section number and/or line reference.
   - **Finding**: What is wrong or inconsistent.
   - **Severity**: Critical (breaks functionality or security), High (factual error or cross-doc contradiction), Medium (incomplete or imprecise), Low (polish/style).
   - **Recommendation**: Specific fix.
   - **Verification**: How to confirm the finding is correct.

3. Check these specific areas:
   - WP-CLI commands: Do they exist? Are flags correct? (Use `wp help <command>` as reference.)
   - PHP constants: Do they exist in the stated WordPress/PHP version?
   - Cross-document agreement: Same control, same classification (L1/L2, baseline/optional).
   - Database privileges: Should be 8 specific grants, not `GRANT ALL PRIVILEGES`.
   - Version floors: PHP, WordPress, MySQL version requirements must be consistent.
   - Glossary coverage: Key terms used in multiple documents should have Style Guide entries.

4. Do NOT suggest stylistic rewrites unless they fix a technical error or ambiguity.
5. Do NOT flag sections 1-2 of the Style Guide (mission/values) — these are out of scope.
6. Mechanical checks run separately before model review. Prioritize issues that require source-grounded judgment, cross-document reasoning, or substantive technical verification.

## Authority Hierarchy

When sources conflict:
1. WordPress Developer Documentation (developer.wordpress.org)
2. WordPress core source code
3. WP-CLI documentation and source
4. External standards (OWASP, CIS, NIST, MDN)

## Documents

Review these four documents:
- WordPress-Security-Benchmark.md
- WordPress-Security-Hardening-Guide.md
- WP-Operations-Runbook.md
- WP-Security-Style-Guide.md
EOF

cat > "${ROUND_DIR}/synthesis.md" <<EOF
# Multi-Model Review Synthesis — ${ROUND_DATE}

## Overview

Synthesize the independent review outputs in this directory and verify each merged finding against the canonical docs and the authority hierarchy.

## Finding Disposition Ledger

Every merged finding must end in one archival state: \`applied\`, \`rejected\`, or \`stale\`.

| ID | Finding | Models | Status | Notes |
|---|---|---|---|---|

## Next Steps

1. Verify merged findings against the canonical source docs.
2. Record the human editorial decision for each finding.
3. Close the round only after the ledger is complete.
EOF

echo "Created review round scaffold: $ROUND_DIR"
echo "Generated from metrics source: $METRICS_FILE"
