#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
METRICS_FILE="${ROOT_DIR}/docs/current-metrics.md"

if [[ ! -f "$METRICS_FILE" ]]; then
  echo "Missing metrics source file: $METRICS_FILE"
  exit 1
fi

echo "== Editorial Review Preflight =="
echo "Metrics source of truth: $METRICS_FILE"
echo

echo "-- Phase status snapshot --"
sed -n '/## Phase Completion/,/## Update Procedure/p' "$METRICS_FILE"
echo

echo "-- Cross-repo metrics sync --"
bash "${ROOT_DIR}/tools/ci/validate_cross_repo_metrics.sh"
echo

echo "-- WP-CLI regression watchlist --"
bash "${ROOT_DIR}/tools/ci/check_wpcli_watchlist.sh"
echo

echo "-- Glossary coverage watchlist --"
bash "${ROOT_DIR}/tools/ci/check_glossary_watchlist.sh"
echo

echo "-- Workflow lint --"
if command -v actionlint >/dev/null 2>&1; then
  (
    cd "$ROOT_DIR"
    actionlint
  )
else
  echo "SKIP: actionlint not installed locally. Use .github/workflows/validate-reusable-generate-docs.yml for workflow lint and smoke coverage."
fi

echo
echo "Editorial review preflight passed."
