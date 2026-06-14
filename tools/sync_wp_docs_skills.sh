#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_ROOT="${ROOT_DIR}/wp-docs-skills"
SCENARIOS_ROOT="${ROOT_DIR}/scenarios"
DEST_ROOTS=(
  "${HOME}/.codex/skills"
  "${HOME}/.agents/skills"
)

python3 "${ROOT_DIR}/tools/ci/validate_skill_bundles.py"

if ! command -v rsync >/dev/null 2>&1; then
  echo "ERROR: rsync is required for skill sync/install." >&2
  exit 1
fi

for dest_root in "${DEST_ROOTS[@]}"; do
  home_root="$(dirname "${dest_root}")"
  mkdir -p "${dest_root}"
  echo "== Syncing WordPress doc skills into ${dest_root} =="

  for skill_dir in "${SKILLS_ROOT}"/*; do
    [[ -d "${skill_dir}" ]] || continue
    skill_name="$(basename "${skill_dir}")"
    [[ -f "${skill_dir}/SKILL.md" ]] || continue
    rsync -a --delete "${skill_dir}/" "${dest_root}/${skill_name}/"
    if diff -qr "${skill_dir}" "${dest_root}/${skill_name}" >/dev/null; then
      echo "OK   ${skill_name}"
    else
      echo "ERROR: post-sync verification failed for ${dest_root}/${skill_name}" >&2
      diff -qr "${skill_dir}" "${dest_root}/${skill_name}" || true
      exit 1
    fi
  done

  mkdir -p "${home_root}/scenarios"
  echo "== Syncing scenario mirror into ${home_root}/scenarios =="
  rsync -a --delete "${SCENARIOS_ROOT}/" "${home_root}/scenarios/"
  if diff -qr "${SCENARIOS_ROOT}" "${home_root}/scenarios" >/dev/null; then
    echo "OK   scenarios"
  else
    echo "ERROR: post-sync scenario verification failed for ${home_root}/scenarios" >&2
    diff -qr "${SCENARIOS_ROOT}" "${home_root}/scenarios" || true
    exit 1
  fi
done

echo
echo "WordPress doc skill sync complete."
