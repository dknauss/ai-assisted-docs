#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
METRICS_FILE="${ROOT_DIR}/docs/current-metrics.md"

BENCH_DIR="${ROOT_DIR}/../wp-security-benchmark"
HARDEN_DIR="${ROOT_DIR}/../wp-security-hardening-guide"
RUNBOOK_DIR="${ROOT_DIR}/../wordpress-runbook-template"
STYLE_DIR="${ROOT_DIR}/../wp-security-style-guide"

for d in "$BENCH_DIR" "$HARDEN_DIR" "$RUNBOOK_DIR" "$STYLE_DIR"; do
  if [[ ! -d "$d" ]]; then
    echo "Missing sibling repository directory: $d"
    exit 1
  fi
done

table_value() {
  local metric="$1"
  local col="$2"
  awk -F'|' -v metric="$metric" -v col="$col" '
    function trim(s) { gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
    /^\| / {
      m=trim($2)
      if (m == metric) {
        v=trim($(col+2))
        gsub(/,/, "", v)
        print v
        exit
      }
    }
  ' "$METRICS_FILE"
}

check_metric() {
  local metric="$1"
  local col="$2"
  local actual="$3"
  local expected
  expected="$(table_value "$metric" "$col")"
  if [[ -z "$expected" ]]; then
    echo "FAIL [$metric][$col] missing value in docs/current-metrics.md"
    exit 1
  fi
  if [[ "$expected" != "$actual" ]]; then
    echo "FAIL [$metric][$col] expected $expected, got $actual"
    exit 1
  fi
  echo "OK   [$metric][$col] = $actual"
}

bench_lines="$(wc -l < "${BENCH_DIR}/WordPress-Security-Benchmark.md" | tr -d ' ')"
hard_lines="$(wc -l < "${HARDEN_DIR}/WordPress-Security-Hardening-Guide.md" | tr -d ' ')"
runbook_lines="$(wc -l < "${RUNBOOK_DIR}/WP-Operations-Runbook.md" | tr -d ' ')"
style_lines="$(wc -l < "${STYLE_DIR}/WP-Security-Style-Guide.md" | tr -d ' ')"

bench_h2="$(grep -cE '^## ' "${BENCH_DIR}/WordPress-Security-Benchmark.md" || true)"
hard_h2="$(grep -cE '^## ' "${HARDEN_DIR}/WordPress-Security-Hardening-Guide.md" || true)"
runbook_h2="$(grep -cE '^## Section' "${RUNBOOK_DIR}/WP-Operations-Runbook.md" || true)"
style_h2="$(grep -cE '^## ' "${STYLE_DIR}/WP-Security-Style-Guide.md" || true)"

bench_controls="$(grep -cE '^#### [0-9]+\.[0-9]+' "${BENCH_DIR}/WordPress-Security-Benchmark.md" || true)"
style_glossary="$(grep -cE '^\*\*' "${STYLE_DIR}/WP-Security-Style-Guide.md" || true)"

bench_fences="$(grep -c '^```' "${BENCH_DIR}/WordPress-Security-Benchmark.md" || true)"
hard_fences="$(grep -c '^```' "${HARDEN_DIR}/WordPress-Security-Hardening-Guide.md" || true)"
runbook_fences="$(grep -c '^```' "${RUNBOOK_DIR}/WP-Operations-Runbook.md" || true)"
style_fences="$(grep -c '^```' "${STYLE_DIR}/WP-Security-Style-Guide.md" || true)"

bench_wpcli="$(grep -cE '^\s*wp ' "${BENCH_DIR}/WordPress-Security-Benchmark.md" || true)"
hard_wpcli="$(grep -cE '^\s*wp ' "${HARDEN_DIR}/WordPress-Security-Hardening-Guide.md" || true)"
runbook_wpcli="$(grep -cE '^\s*wp ' "${RUNBOOK_DIR}/WP-Operations-Runbook.md" || true)"
style_wpcli="$(grep -cE '^\s*wp ' "${STYLE_DIR}/WP-Security-Style-Guide.md" || true)"

runbook_destructive="$(grep -cE '^\s*wp (search-replace|db import|db reset|db query|post delete|comment delete|user delete|plugin delete|plugin deactivate|option update|option delete|rewrite flush|transient delete|cache flush|eval|eval-file)' "${RUNBOOK_DIR}/WP-Operations-Runbook.md" || true)"
runbook_inline_warning="$(grep -c '# WARNING:' "${RUNBOOK_DIR}/WP-Operations-Runbook.md" || true)"
bench_customize="$(grep -c '\[CUSTOMIZE:' "${BENCH_DIR}/WordPress-Security-Benchmark.md" || true)"
hard_customize="$(grep -c '\[CUSTOMIZE:' "${HARDEN_DIR}/WordPress-Security-Hardening-Guide.md" || true)"
runbook_customize="$(grep -c '\[CUSTOMIZE:' "${RUNBOOK_DIR}/WP-Operations-Runbook.md" || true)"
style_customize="$(grep -c '\[CUSTOMIZE:' "${STYLE_DIR}/WP-Security-Style-Guide.md" || true)"

check_metric "Document lines" 1 "$bench_lines"
check_metric "Document lines" 2 "$hard_lines"
check_metric "Document lines" 3 "$runbook_lines"
check_metric "Document lines" 4 "$style_lines"

check_metric "Major sections (H2)" 1 "$bench_h2"
check_metric "Major sections (H2)" 2 "$hard_h2"
check_metric "Major sections (H2)" 3 "$runbook_h2"
check_metric "Major sections (H2)" 4 "$style_h2"

check_metric "Security controls" 1 "$bench_controls"
check_metric "Glossary terms" 4 "$style_glossary"

check_metric "Code fences" 1 "$bench_fences"
check_metric "Code fences" 2 "$hard_fences"
check_metric "Code fences" 3 "$runbook_fences"
check_metric "Code fences" 4 "$style_fences"

check_metric "WP-CLI commands" 1 "$bench_wpcli"
check_metric "WP-CLI commands" 2 "$hard_wpcli"
check_metric "WP-CLI commands" 3 "$runbook_wpcli"
check_metric "WP-CLI commands" 4 "$style_wpcli"

check_metric "Destructive commands" 3 "$runbook_destructive"
check_metric "Inline WARNINGs" 3 "$runbook_inline_warning"

check_metric "CUSTOMIZE placeholders" 1 "$bench_customize"
check_metric "CUSTOMIZE placeholders" 2 "$hard_customize"
check_metric "CUSTOMIZE placeholders" 3 "$runbook_customize"
check_metric "CUSTOMIZE placeholders" 4 "$style_customize"

echo "Cross-repo metrics sync check passed."
