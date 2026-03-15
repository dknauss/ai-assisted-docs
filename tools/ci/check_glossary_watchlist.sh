#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
STYLE_FILE="${ROOT_DIR}/../wp-security-style-guide/WP-Security-Style-Guide.md"

if [[ ! -f "$STYLE_FILE" ]]; then
  echo "Missing canonical style guide file: $STYLE_FILE"
  exit 1
fi

check_present() {
  local pattern="$1"
  local label="$2"

  if grep -Eq "$pattern" "$STYLE_FILE"; then
    echo "OK: $label"
  else
    echo "FAIL: $label"
    exit 1
  fi
}

echo "== Glossary Coverage Watchlist =="
check_present '^\*\*Argon2id\*\*' "Argon2id glossary entry exists"
check_present '^\*\*EPSS\*\*' "EPSS glossary entry exists"
check_present '^\*\*KSES\*\*' "KSES glossary entry exists"
check_present '^\*\*mu-plugin \(must-use plugin\)\*\*' "mu-plugin glossary entry exists"
check_present '^\*\*PHP security directives\*\*' "PHP security directives entry covers expose_php and open_basedir"
check_present '^\*\*SBOM \(Software Bill of Materials\)\*\*' "SBOM glossary entry exists"
check_present '^\*\*Shadow AI\*\*' "Shadow AI glossary entry exists"
check_present '^\*\*SIEM \(Security Information and Event Management\)\*\*' "SIEM glossary entry exists"
check_present '^\*\*TLS \(Transport Layer Security\)\*\*' "TLS glossary entry exists"
check_present '^\*\*Virtual patching\*\*' "Virtual patching glossary entry exists"
check_present '^\*\*WP-CLI\*\*' "WP-CLI glossary entry exists"
check_present '^\*\*WP-Cron\*\*' "WP-Cron glossary entry exists"

echo "Glossary coverage watchlist passed."
