#!/usr/bin/env bash
set -euo pipefail

STRICT_MODE="${GP_ALIGNMENT_STRICT:-0}"

usage() {
  cat <<'EOF'
Usage: bash tools/ci/validate_gp_alignment.sh [--strict]

Modes:
  default (portable): validates in-repo artifacts and canonical-target references,
                      but does not require sibling canonical repos on disk.
  --strict / GP_ALIGNMENT_STRICT=1: also requires sibling canonical repos to exist
                                    at expected relative paths.
EOF
}

if [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "${1:-}" = "--strict" ]; then
  STRICT_MODE=1
elif [ -n "${1:-}" ]; then
  echo "Unknown argument: $1"
  usage
  exit 1
fi

echo "== GP Alignment Validation =="
if [ "$STRICT_MODE" = "1" ]; then
  echo "Mode: strict"
else
  echo "Mode: portable"
fi

REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT"

required_files=(
  "wp-security-doc-review/gridpane-security-brief.md"
  "wp-security-doc-review/gridpane-briefing-card.md"
  "wp-security-doc-review/gridpane-crosswalk.md"
  "wp-security-doc-review/gridpane-crosswalk-template.md"
  "wp-security-doc-review/gridpane-gap-analysis.md"
  "wp-security-doc-review/gridpane-security-prompt.md"
  "wp-docs-skills/security-researcher/SKILL.md"
  ".planning/ROADMAP.md"
  ".planning/STATE.md"
  ".planning/config.json"
)

canonical_targets=(
  "../wp-security-benchmark/WordPress-Security-Benchmark.md"
  "../wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md"
  "../wordpress-runbook-template/WP-Operations-Runbook.md"
  "../wp-security-style-guide/WP-Security-Style-Guide.md"
)

# Guard against empty glob when no PLAN.md files exist (set -u would crash).
plan_files=()
for f in .planning/phases/01-revisions-gp-alignment/*-PLAN.md; do
  [ -f "$f" ] && plan_files+=("$f")
done

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

echo "- Checking required files..."
for file in "${required_files[@]}"; do
  if [ -f "$file" ]; then
    echo "  OK: $file"
  else
    echo "  FAIL: missing $file"
    exit 1
  fi
done

echo "- Checking exact GridPane URLs in research artifacts..."
check_contains 'https://gridpane\.com/' "wp-security-doc-review/gridpane-security-brief.md" "brief includes exact GridPane URLs"
check_contains 'https://gridpane\.com/' "wp-security-doc-review/gridpane-briefing-card.md" "briefing card includes exact GridPane URLs"
check_contains 'https://gridpane\.com/' "wp-security-doc-review/gridpane-crosswalk.md" "crosswalk includes exact GridPane URLs"
check_contains 'https://gridpane\.com/' "wp-security-doc-review/gridpane-gap-analysis.md" "gap analysis includes exact GridPane URLs"
check_contains 'https://gridpane\.com/' "wp-security-doc-review/gridpane-security-prompt.md" "prompt includes exact GridPane URLs"

echo "- Checking canonical source-repo targets..."
missing_targets=0
for target in "${canonical_targets[@]}"; do
  if [ -f "$target" ]; then
    echo "  OK: local canonical target exists: $target"
  else
    if [ "$STRICT_MODE" = "1" ]; then
      echo "  FAIL: missing canonical target: $target"
      exit 1
    fi
    missing_targets=1
    echo "  WARN: missing canonical target (portable mode): $target"
  fi
done

if [ "$missing_targets" = "1" ] && [ "$STRICT_MODE" != "1" ]; then
  echo "  NOTE: Set GP_ALIGNMENT_STRICT=1 or pass --strict to enforce local sibling repo presence."
fi

echo "- Checking cross-references to canonical repos..."
check_contains '\.\./wp-security-benchmark/WordPress-Security-Benchmark\.md' "wp-security-doc-review/gridpane-crosswalk.md" "crosswalk points at canonical benchmark source"
check_contains '\.\./wp-security-hardening-guide/WordPress-Security-Hardening-Guide\.md' "wp-security-doc-review/gridpane-gap-analysis.md" "gap analysis points at canonical hardening guide source"
check_contains '\.\./wordpress-runbook-template/WP-Operations-Runbook\.md' "wp-security-doc-review/gridpane-security-prompt.md" "prompt points at canonical runbook source"
check_contains '\.\./wp-security-style-guide/WP-Security-Style-Guide\.md' "wp-security-doc-review/gridpane-security-prompt.md" "prompt points at canonical style guide source"

echo "- Checking for stale archived-review targets in plans and GP artifacts..."
# Check for any stale round references, not just a specific date.
if grep -rE "wp-security-doc-review/rounds/[0-9]{4}-[0-9]{2}-[0-9]{2}/(phase|round)" .planning/phases/01-revisions-gp-alignment wp-security-doc-review/gridpane-*.md >/dev/null 2>&1; then
  echo "  FAIL: stale archived review targets remain"
  exit 1
else
  echo "  OK: no stale archived review targets found"
fi

echo "- Checking plan file integrity..."
if [ ${#plan_files[@]} -eq 0 ]; then
  echo "  WARN: no PLAN.md files found in .planning/phases/01-revisions-gp-alignment/"
else
  for plan in "${plan_files[@]}"; do
    check_contains '<objective>' "$plan" "$(basename "$plan") has objective tag"
    # Guard: detect malformed objective tags with an embedded space (e.g., '<object ive>').
    # This intentional misspelling in the grep pattern catches copy-paste corruption.
    if grep -Eq '<object ive>' "$plan"; then
      echo "  FAIL: malformed objective tag in $plan"
      exit 1
    fi
  done
fi

echo "- Checking planning scaffold..."
check_contains '"mode": "interactive"' ".planning/config.json" "config.json initialized"
check_contains '^# Roadmap:' ".planning/ROADMAP.md" "roadmap initialized"
check_contains '^# Project State' ".planning/STATE.md" "state initialized"

echo "All checks completed."
