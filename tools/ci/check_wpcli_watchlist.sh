#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

BENCH_FILE="${ROOT_DIR}/../wp-security-benchmark/WordPress-Security-Benchmark.md"
RUNBOOK_FILE="${ROOT_DIR}/../wordpress-runbook-template/WP-Operations-Runbook.md"
STYLE_FILE="${ROOT_DIR}/../wp-security-style-guide/WP-Security-Style-Guide.md"

for file in "$BENCH_FILE" "$RUNBOOK_FILE" "$STYLE_FILE"; do
  if [[ ! -f "$file" ]]; then
    echo "Missing canonical source file: $file"
    exit 1
  fi
done

check_absent() {
  local file="$1"
  local pattern="$2"
  local label="$3"

  if rg -n -e "$pattern" "$file" >/dev/null 2>&1; then
    echo "FAIL: $label"
    rg -n -e "$pattern" "$file"
    exit 1
  fi

  echo "OK: $label"
}

echo "== WP-CLI Regression Watchlist =="
check_absent "$BENCH_FILE" 'wp user update .*--user_login' "Benchmark avoids the invalid --user_login remediation"
check_absent "$RUNBOOK_FILE" '--post_status=scheduled' "Runbook avoids scheduled/future post-status regression"
check_absent "$RUNBOOK_FILE" 'wp term delete .*--default' "Runbook avoids invalid wp term delete --default flag"
check_absent "$STYLE_FILE" 'wp-cli checksum' "Style Guide avoids nonexistent wp-cli checksum command"
check_absent "$STYLE_FILE" 'wp checksum core' "Style Guide avoids nonexistent wp checksum core command"

echo "WP-CLI regression watchlist passed."
