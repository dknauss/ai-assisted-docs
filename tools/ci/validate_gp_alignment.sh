#!/usr/bin/env bash
set -euo pipefail

echo "== GP Alignment Validation =="
REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT"

declare -A CHECKS
CHECKS[crosswalk_exists]=1
CHECKS[gp_sources_in_crosswalk]=1
CHECKS[four_docs_presence]=1
CHECKS[fortress_label_in_briefing]=1
CHECKS[gp_to_wp_mapping_present]=1
CHECKS[cross_reference_templates]=1

BRIEF_FILE="wp-security-doc-review/gridpane-security-brief.md"
CROSSWALK_FILE="wp-security-doc-review/gridpane-crosswalk.md"
BRIEF_EXISTS=$(test -f "$BRIEF_FILE" && echo 1 || echo 0)
CROSSWALK_EXISTS=$(test -f "$CROSSWALK_FILE" && echo 1 || echo 0)

echo "- Checking crosswalk presence..."; if [ "$CROSSWALK_EXISTS" -eq 1 ]; then echo "  OK"; else echo "  FAIL: crosswalk missing"; exit 1; fi

echo "- Checking GP sources in crosswalk..."; if grep -E "gridpane|fortress|knowledgebase|gridpane.com" "$CROSSWALK_FILE" >/dev/null 2>&1; then echo "  OK"; else echo "  FAIL: crosswalk missing GP sources"; exit 1; fi

echo "- Checking four WP docs presence in repo..."; for f in wp-security-doc-review/rounds/2026-03-03/phase1-*.md; do if [ -f "$f" ]; then true; else echo "Missing: $f"; fi; done
for f in wp-security-doc-review/rounds/2026-03-03/phase1-benchmark.md wp-security-doc-review/rounds/2026-03-03/phase1-hardening-guide.md wp-security-doc-review/rounds/2026-03-03/phase1-runbook.md wp-security-doc-review/rounds/2026-03-03/phase1-style-guide.md; do if [ -f "$f" ]; then true; else echo "Missing: $f"; exit 1; fi; done
echo "  All four WP doc phases present?"; echo "  (Review manual: content alignment will require human verification)"

echo "- Checking Fortress labeling in briefing..."; if grep -qi "vendor-specific" "$BRIEF_FILE"; then echo "  Fortress labeling present"; else echo "  WARNING: Fortress labeling not explicit in briefing"; fi

echo "- Checking crosswalk mentions of GP-to-WP mapping..."; if grep -qi "Benchmark" "$CROSSWALK_FILE" && grep -qi "Hardening Guide" "$CROSSWALK_FILE" && grep -qi "Runbook" "$CROSSWALK_FILE" && grep -qi "Style Guide" "$CROSSWALK_FILE"; then echo "  GP→WP mappings present"; else echo "  WARNING: GP→WP mappings may be incomplete"; fi

echo "All checks completed."
