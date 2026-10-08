#!/usr/bin/env bash
# Dispatch generate-docs workflow in all four canonical document repos.
# Requires: gh CLI authenticated with repo scope.
#
# Usage:
#   ./tools/rebuild-all-docs.sh          # dispatch all four
#   ./tools/rebuild-all-docs.sh --wait   # dispatch, wait, and exit non-zero if any run fails

set -euo pipefail

REPOS=(
  dknauss/wp-security-benchmark
  dknauss/wp-security-hardening-guide
  dknauss/wordpress-runbook-template
  dknauss/wp-security-style-guide
)

WAIT=false
if [[ "${1:-}" == "--wait" ]]; then
  WAIT=true
fi

# Recorded before dispatch so --wait can tell this script's runs from earlier ones.
DISPATCHED_AT="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

for repo in "${REPOS[@]}"; do
  echo "Dispatching generate-docs.yml in ${repo}..."
  gh workflow run generate-docs.yml --repo "$repo"
done

echo ""
echo "All four workflows dispatched."

if $WAIT; then
  echo ""
  echo "Waiting for runs to complete..."
  failed=0
  for repo in "${REPOS[@]}"; do
    echo ""
    echo "--- ${repo} ---"
    # Find the workflow_dispatch run created at or after this script's dispatch.
    run_id=""
    for _ in 1 2 3 4 5 6; do
      sleep 5  # give GitHub a moment to register the run
      run_id="$(gh run list --repo "$repo" --workflow generate-docs.yml --event workflow_dispatch \
        --limit 5 --json databaseId,createdAt \
        --jq "[.[] | select(.createdAt >= \"${DISPATCHED_AT}\")] | sort_by(.createdAt) | .[0].databaseId // empty")"
      [[ -n "$run_id" ]] && break
    done
    if [[ -z "$run_id" ]]; then
      echo "ERROR: no dispatched run found for ${repo}" >&2
      failed=1
      continue
    fi
    # --exit-status makes gh return non-zero when the run fails.
    if ! gh run watch "$run_id" --repo "$repo" --exit-status; then
      echo "ERROR: run ${run_id} failed in ${repo}" >&2
      failed=1
    fi
  done
  echo ""
  if (( failed )); then
    echo "One or more rebuilds failed." >&2
    exit 1
  fi
  echo "All runs completed successfully."
fi
