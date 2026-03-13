#!/usr/bin/env bash
# Dispatch generate-docs workflow in all four canonical document repos.
# Requires: gh CLI authenticated with repo scope.
#
# Usage:
#   ./tools/rebuild-all-docs.sh          # dispatch all four
#   ./tools/rebuild-all-docs.sh --wait   # dispatch and poll until complete

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

for repo in "${REPOS[@]}"; do
  echo "Dispatching generate-docs.yml in ${repo}..."
  gh workflow run generate-docs.yml --repo "$repo"
done

echo ""
echo "All four workflows dispatched."

if $WAIT; then
  echo ""
  echo "Waiting for runs to complete..."
  sleep 5  # give GitHub a moment to register the runs
  for repo in "${REPOS[@]}"; do
    echo ""
    echo "--- ${repo} ---"
    # Get the most recent run for generate-docs.yml
    gh run list --repo "$repo" --workflow generate-docs.yml --limit 1 --json databaseId,status --jq '.[0].databaseId' \
      | xargs -I{} gh run watch {} --repo "$repo"
  done
  echo ""
  echo "All runs complete."
fi
