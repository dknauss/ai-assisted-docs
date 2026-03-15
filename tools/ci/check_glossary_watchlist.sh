#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BENCH_FILE="${ROOT_DIR}/../wp-security-benchmark/WordPress-Security-Benchmark.md"
HARDEN_FILE="${ROOT_DIR}/../wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md"
RUNBOOK_FILE="${ROOT_DIR}/../wordpress-runbook-template/WP-Operations-Runbook.md"
STYLE_FILE="${ROOT_DIR}/../wp-security-style-guide/WP-Security-Style-Guide.md"

for file in "$BENCH_FILE" "$HARDEN_FILE" "$RUNBOOK_FILE" "$STYLE_FILE"; do
  if [[ ! -f "$file" ]]; then
    echo "Missing canonical source file: $file"
    exit 1
  fi
done

require_if_repeated() {
  local term_pattern="$1"
  local heading_pattern="$2"
  local label="$3"
  local count=0

  grep -Eq "$term_pattern" "$BENCH_FILE" && count=$((count + 1))
  grep -Eq "$term_pattern" "$HARDEN_FILE" && count=$((count + 1))
  grep -Eq "$term_pattern" "$RUNBOOK_FILE" && count=$((count + 1))

  if [[ "$count" -lt 2 ]]; then
    echo "SKIP: $label (used in ${count} canonical document(s))"
    return 0
  fi

  if grep -Eq "$heading_pattern" "$STYLE_FILE"; then
    echo "OK: $label (used in ${count} canonical documents)"
  else
    echo "FAIL: $label (used in ${count} canonical documents)"
    exit 1
  fi
}

echo "== Glossary Coverage Watchlist =="
require_if_repeated '\bAIDE\b' '^\*\*AIDE ' "AIDE glossary coverage"
require_if_repeated '\bArgon2id\b' '^\*\*Argon2id\*\*' "Argon2id glossary coverage"
require_if_repeated '\bEPSS\b' '^\*\*EPSS\*\*' "EPSS glossary coverage"
require_if_repeated '\bKSES\b' '^\*\*KSES\*\*' "KSES glossary coverage"
require_if_repeated '\bmu-plugin\b' '^\*\*mu-plugin \(must-use plugin\)\*\*' "mu-plugin glossary coverage"
require_if_repeated '\bPHP-FPM\b' '^\*\*PHP-FPM ' "PHP-FPM glossary coverage"
require_if_repeated '\b(open_basedir|expose_php|display_errors)\b' '^\*\*PHP security directives\*\*' "PHP security directives glossary coverage"
require_if_repeated '\bRansomware\b' '^\*\*Ransomware\*\*' "Ransomware glossary coverage"
require_if_repeated '\bSBOM\b' '^\*\*SBOM \(Software Bill of Materials\)\*\*' "SBOM glossary coverage"
require_if_repeated '\bShadow AI\b' '^\*\*Shadow AI\*\*' "Shadow AI glossary coverage"
require_if_repeated '\bSIEM\b' '^\*\*SIEM \(Security Information and Event Management\)\*\*' "SIEM glossary coverage"
require_if_repeated '\bSIM-swapping\b' '^\*\*SIM-swapping\*\*' "SIM-swapping glossary coverage"
require_if_repeated '\bSnuffleupagus\b' '^\*\*Snuffleupagus\*\*' "Snuffleupagus glossary coverage"
require_if_repeated '\bTLS\b' '^\*\*TLS \(Transport Layer Security\)\*\*' "TLS glossary coverage"
require_if_repeated '\bUFW\b' '^\*\*UFW \(Uncomplicated Firewall\)\*\*' "UFW glossary coverage"
require_if_repeated '\b[Vv]irtual patching\b' '^\*\*Virtual patching\*\*' "Virtual patching glossary coverage"
require_if_repeated '\bWP-CLI\b' '^\*\*WP-CLI\*\*' "WP-CLI glossary coverage"
require_if_repeated '\bWP-Cron\b' '^\*\*WP-Cron\*\*' "WP-Cron glossary coverage"

echo "Glossary coverage watchlist passed."
