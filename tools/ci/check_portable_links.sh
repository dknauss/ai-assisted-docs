#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

if rg -n --glob '*.md' --glob '*.sh' '\]\((file://)?/Users/' "$ROOT_DIR"; then
  echo
  echo "FAIL: Found non-portable local filesystem Markdown links. Use repo-relative paths instead."
  exit 1
fi

echo "Portable Markdown link check passed."
