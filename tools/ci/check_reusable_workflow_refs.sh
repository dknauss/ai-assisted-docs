#!/usr/bin/env bash
# Reusable workflows run in the caller's checkout, so a local `uses: ./...`
# action reference resolves against the calling repository and fails for
# external callers. Require repository-qualified references instead.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fail=0

for wf in "${ROOT_DIR}"/.github/workflows/*.yml; do
  grep -q 'workflow_call' "$wf" || continue
  # Job-level `uses: ./.github/workflows/...` calls are resolved by GitHub and are fine;
  # only step-level local action paths break for external callers.
  if grep -nE '^\s*(-\s*)?uses:\s*\./\.github/actions/' "$wf"; then
    echo "FAIL: $(basename "$wf") is a reusable workflow that references a local action path."
    fail=1
  fi
done

if (( fail )); then
  exit 1
fi

echo "Reusable workflow action references passed."
