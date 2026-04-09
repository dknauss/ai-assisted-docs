#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PORTABILITY_PATTERN='/Users/|file:///|[A-Za-z]:\\\\Users\\\\|/mnt/c/Users/'

if command -v rg >/dev/null 2>&1; then
  SEARCH_CMD=(
    rg -n
    --glob '*.md'
    --glob '*.sh'
    --glob '!**/check_portable_links.sh'
    "$PORTABILITY_PATTERN"
    "$ROOT_DIR"
  )
else
  SEARCH_CMD=(
    grep -RInE
    --include='*.md'
    --include='*.sh'
    --exclude='check_portable_links.sh'
    "$PORTABILITY_PATTERN"
    "$ROOT_DIR"
  )
fi

if "${SEARCH_CMD[@]}"; then
  echo
  echo "FAIL: Found non-portable machine-local paths or file URIs. Use repo-relative paths or generic placeholders instead."
  exit 1
fi

echo "Portable path check passed."
