#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ROUNDS_DIR="${ROOT_DIR}/wp-security-doc-review/rounds"

if [[ ! -d "$ROUNDS_DIR" ]]; then
  echo "Missing rounds directory: $ROUNDS_DIR"
  exit 1
fi

check_absent() {
  local pattern="$1"
  local label="$2"
  shift 2
  local files=("$@")

  if rg -n -i -e "$pattern" "${files[@]}" >/dev/null 2>&1; then
    echo "FAIL: $label"
    rg -n -i -e "$pattern" "${files[@]}"
    exit 1
  fi

  echo "OK: $label"
}

closed_rounds=0

echo "== Review Archive Freshness Lint =="

while IFS= read -r -d '' round_dir; do
  readme="${round_dir}/README.md"
  execution_guide="${round_dir}/EXECUTION-GUIDE.md"
  synthesis="${round_dir}/synthesis.md"

  if [[ ! -f "$readme" ]]; then
    continue
  fi

  if ! grep -Eq '^Round complete\.' "$readme"; then
    continue
  fi

  closed_rounds=$((closed_rounds + 1))
  echo "-- Checking closed round: $(basename "$round_dir")"

  if [[ ! -f "$synthesis" ]]; then
    echo "FAIL: closed round is missing synthesis.md"
    exit 1
  fi

  files=("$readme" "$synthesis")
  if [[ -f "$execution_guide" ]]; then
    files+=("$execution_guide")
  fi

  check_absent 'awaiting model execution' "closed round does not retain pre-execution status language" "${files[@]}"
  check_absent 'needs verification' "closed round does not retain unresolved archival status language" "${files[@]}"
  check_absent '\([~0-9][0-9, ]* lines\)' "closed round execution guide does not hard-code volatile line counts" "${files[@]}"

  if ! grep -Eq 'docs/current-metrics\.md' "$readme" "$execution_guide" 2>/dev/null; then
    echo "FAIL: closed round does not point back to docs/current-metrics.md"
    exit 1
  fi
  echo "OK: closed round points back to docs/current-metrics.md"

  if ! grep -Eq '\|\s*(applied|rejected|stale)\s*\|' "$synthesis"; then
    echo "FAIL: closed round synthesis does not record archival finding states"
    exit 1
  fi
  echo "OK: closed round synthesis records archival finding states"
done < <(find "$ROUNDS_DIR" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

if [[ "$closed_rounds" -eq 0 ]]; then
  echo "WARN: no closed rounds found for archive linting"
else
  echo "Review archive freshness lint passed for ${closed_rounds} closed round(s)."
fi
