# Coding Conventions

**Analysis Date:** 2026-03-14

## Project Overview

This codebase is a technical documentation and editorial tooling project written in **Bash**, **Python**, and **YAML**. No compiled languages or traditional package managers (npm, cargo, etc.) are present. The focus is on maintaining consistency across a four-document WordPress security series and automating CI/CD workflows for document generation and validation.

## Language-Specific Conventions

### Bash Scripts

**File locations:**
- `tools/rebuild-all-docs.sh` — Main dispatch script
- `tools/ci/validate_cross_repo_metrics.sh` — Metrics validation
- `tools/ci/validate_gp_alignment.sh` — GridPane alignment verification

**Bash conventions:**

- **Shebang:** Always use `#!/usr/bin/env bash` (not `#!/bin/bash`)
- **Error handling:** `set -euo pipefail` at script start (`-e` exit on error, `-u` error on undefined vars, `-o pipefail` fail if any piped command fails)
- **Quoting:** Quote all variable references (`"$var"`, not `$var`) to handle spaces in paths
- **Arrays:** Use `"${array[@]}"` for proper word-splitting behavior when iterating
- **Conditionals:** Use `[[ ]]` (bash built-in) instead of `[ ]` (POSIX) — allows `==` pattern matching
- **Functions:** Define with `func_name() { }` syntax
- **Comments:** Use `#` for single-line; no multi-line comment syntax

**Example pattern from `validate_gp_alignment.sh`:**
```bash
#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: bash tools/ci/validate_gp_alignment.sh [--strict]
EOF
}

check_contains() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if grep -Eq "$pattern" "$file"; then
    echo "  OK: $message"
  else
    echo "  FAIL: $message"
    exit 1
  fi
}
```

**Key patterns:**

1. **Heredocs for multi-line output:** Use `cat <<'EOF'...EOF` to preserve literal content (no variable expansion)
2. **Function-local variables:** Prefix with `local` keyword to avoid polluting global scope
3. **Exit codes:** Use `exit 0` for success, `exit 1` for errors
4. **Path resolution:** Use `$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)` to get script's directory, even if called from another directory
5. **Regex patterns:** Use `grep -E` (ERE mode) with unescaped pipes for alternation: `grep -E "pattern1|pattern2"` (not `pattern1\|pattern2`)
6. **Output prefixing:** Prefix status messages with aligned indicators: `echo "  OK: message"` or `echo "  FAIL: message"`

### Python Scripts

**File locations:**
- `tools/docs/add_docx_page_numbers.py` — DOCX footer insertion utility

**Python conventions:**

- **Shebang:** `#!/usr/bin/env python3` (Python 3 required)
- **Imports:** Organize in groups: standard library, third-party, local
- **Type hints:** Use type annotations for function signatures
- **Docstrings:** Use triple-quoted strings for module and function documentation
- **Code style:** Follow PEP 8; code uses 4-space indentation
- **Imports from `__future__`:** Always include `from __future__ import annotations` for forward-compatible type hints

**Example pattern from `add_docx_page_numbers.py`:**
```python
#!/usr/bin/env python3

from __future__ import annotations

import argparse
import io
import re
import sys
import zipfile
from pathlib import Path
import xml.etree.ElementTree as ET

W_NS = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
R_NS = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"

def qname(ns: str, tag: str) -> str:
    """Build a qualified XML element name."""
    return f"{{{ns}}}{tag}"

def patch_docx(docx_path: Path) -> bool:
    """Modify DOCX file to add footer with page numbering."""
    # Implementation...
    return changed
```

**Key patterns:**

1. **XML namespace handling:** Register namespaces at module top with `ET.register_namespace(prefix, uri)` before parsing
2. **Type signatures:** All function parameters and returns have types: `def func(param: Type) -> ReturnType`
3. **Error messages:** Include file path and context in `RuntimeError()` messages: `raise RuntimeError(f"{docx_path}: missing word body")`
4. **Path handling:** Use `pathlib.Path` for file operations, not `os.path`
5. **Main guard:** Always use `if __name__ == "__main__": sys.exit(main())`

### YAML Workflows

**File locations:**
- `.github/workflows/validate-cross-repo-metrics.yml` — CI metrics validation
- `.github/workflows/reusable-generate-docs.yml` — Reusable doc generation workflow

**YAML conventions:**

- **Indentation:** 2 spaces (not tabs)
- **Job names:** Use kebab-case (`generate-docs`, `validate-metrics`)
- **Step names:** Use title case with clear intent: `Install Pandoc`, `Validate generated outputs`
- **Comments:** Use `#` for inline explanations; GitHub Actions comments preserve structure
- **Heredocs:** Use `cat > file.ext <<'MARKER'...MARKER` to generate multi-line config files

**Example pattern from `reusable-generate-docs.yml`:**
```yaml
name: Reusable DOCX-Derived Docs Generation

on:
  workflow_call:
    inputs:
      primary_markdown:
        description: Primary markdown file to convert
        required: true
        type: string

permissions:
  contents: write

jobs:
  generate-docs:
    runs-on: ubuntu-latest
    steps:
      - name: Install Pandoc
        run: |
          PANDOC_VER=3.6.3
          wget -q "https://github.com/jgm/pandoc/releases/download/${PANDOC_VER}/pandoc-${PANDOC_VER}-1-amd64.deb"
```

## Naming Patterns

### File Names

**Shell scripts:**
- Full words, kebab-case: `validate-cross-repo-metrics.sh`, `rebuild-all-docs.sh`
- Descriptive verb-first: `validate-*`, `rebuild-*`

**Python scripts:**
- Underscores for multi-word names: `add_docx_page_numbers.py`
- No hyphens (Python import compatibility)

**Documentation/Markdown:**
- Uppercase: `AGENTS.md`, `ROADMAP.md`, `STATE.md`, `SKILL.md`
- Describes content clearly: `gridpane-security-brief.md`, `gridpane-crosswalk.md`

**Directories:**
- Kebab-case for multi-word: `wp-docs-skills/`, `wordpress-runbook-ops/`
- Single words lowercase: `tools/`, `scenarios/`, `archive/`

### Variable Names (Bash)

**Pattern: UPPERCASE_WITH_UNDERSCORES for constants and major variables**

Examples from codebase:
- `REPOS=()` — Array of repository names
- `BENCH_DIR`, `HARDEN_DIR` — Directory paths
- `METRICS_FILE` — Important config file
- `ROOT_DIR` — Project root
- `WAIT=false` — Boolean flags
- `STRICT_MODE` — Conditional behavior flag

**Pattern: lowercase_with_underscores for function-local variables**

Examples:
- `pattern="$1"` — Function parameter copy
- `metric="$metric"` — Loop variable
- `expected="$(table_value ...)` — Computed value
- `bench_lines=$(wc -l < file)` — Command output

### Function Names (Bash)

**Pattern: verb_noun or action_subject**

Examples from codebase:
- `table_value()` — Get a value from a table
- `check_metric()` — Verify a metric matches expectation
- `check_contains()` — Verify a pattern exists in a file
- `build_footer_xml()` — Construct XML footer element

### Function Names (Python)

**Pattern: snake_case, verb-focused**

Examples from codebase:
- `qname()` — Build qualified XML name
- `parse_xml()` — Parse XML bytes to ElementTree
- `to_xml_bytes()` — Serialize ElementTree to bytes
- `next_rel_id()` — Compute next relationship ID
- `ensure_footer_content_type()` — Ensure content type is registered
- `build_footer_xml()` — Build footer XML bytes
- `patch_docx()` — Modify DOCX file
- `main()` — Entry point

## Error Handling

**Bash approach:**

1. **Set error trap immediately:** `set -euo pipefail` at script top — stops execution on any error
2. **Explicit exit codes:** `exit 0` for success, `exit 1` for failure (or specific non-zero codes for different error types)
3. **Informative error messages:** Echo reason before exit
   ```bash
   if [ ! -f "$file" ]; then
     echo "  FAIL: missing $file"
     exit 1
   fi
   ```
4. **Guard against empty globs:** Use pattern `for f in dir/*; do [ -f "$f" ] && array+=("$f"); done` to avoid iterating on literal glob pattern when no files match

**Python approach:**

1. **Raise on problems:** Use `RuntimeError()` with context:
   ```python
   if body is None:
     raise RuntimeError(f"{docx_path}: missing word body")
   ```
2. **Argument validation:** Use `argparse` for CLI; let it handle invalid args
3. **Path validation:** Check existence before opening: `if not path.exists(): raise RuntimeError(...)`

## Logging

**Bash logging:**

- **Informational:** `echo "Message"` for general output
- **Status updates:** `echo "  OK: message"` or `echo "  FAIL: message"` with 2-space indent
- **Section markers:** `echo "- Checking xyz..."` with leading `- `
- **Progress:** `echo "Converting $md_file..."` before major operations
- **Completion:** `echo "All checks completed."` at end

**Python logging:**

- **Status output:** `print(f"status: {path}")` for minimal output (script writes to stdout)
- **No logging framework:** Project uses plain `print()` for simplicity

## Cross-Repo Conventions

**Document organization (shared across four repos):**

- **Primary document:** One `.md` file per repo (e.g., `WordPress-Security-Benchmark.md`)
- **Metrics file:** `docs/current-metrics.md` in each repo tracks structural counts
- **Changelog:** `CHANGELOG.md` tracks revisions
- **Build outputs:** `.docx`, `.pdf`, `.epub` generated from `.md` via Pandoc

**Metrics validation convention:**

All counts in `docs/current-metrics.md` are verifiable by command-line tools. Example from `validate_cross_repo_metrics.sh`:
```bash
bench_lines="$(wc -l < "${BENCH_DIR}/WordPress-Security-Benchmark.md" | tr -d ' ')"
bench_h2="$(grep -cE '^## ' "${BENCH_DIR}/WordPress-Security-Benchmark.md" || true)"
bench_controls="$(grep -cE '^#### [0-9]+\.[0-9]+' "${BENCH_DIR}/WordPress-Security-Benchmark.md" || true)"
```

This allows automated validation that documentation stays aligned with recorded metrics.

---

*Convention analysis: 2026-03-14*
