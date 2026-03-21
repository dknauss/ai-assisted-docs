#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PORTABILITY_PATTERN='/Users/|file:///|[A-Za-z]:\\\\Users\\\\|/mnt/c/Users/'

if rg -n \
  --glob '*.md' \
  --glob '*.sh' \
  --glob '!tools/ci/check_portable_links.sh' \
  "$PORTABILITY_PATTERN" \
  "$ROOT_DIR"; then
  echo
  echo "FAIL: Found non-portable machine-local paths or file URIs. Use repo-relative paths or generic placeholders instead."
  exit 1
fi

echo "Portable path check passed."
