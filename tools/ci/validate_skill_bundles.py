#!/usr/bin/env python3
"""Validate local WordPress skill bundles and their referenced resources."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


STD_REQUIRED_FILES = (
    "SKILL.md",
    "agents/claude.yaml",
    "agents/openai.yaml",
    "references/canonical-sources.md",
)

RELATIVE_REF_RE = re.compile(
    r"""
    (?:
        `(?P<code>(?:\.\./)+scenarios/[^`\s]+|references/[^`\s]+|agents/[^`\s]+|scripts/[^`\s]+|assets/[^`\s]+)` |
        \]\((?P<link>(?:\.\./)+scenarios/[^)\s]+|references/[^)\s]+|agents/[^)\s]+|scripts/[^)\s]+|assets/[^)\s]+)\)
    )
    """,
    re.VERBOSE,
)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Validate wp-docs-skills bundle structure and relative references."
    )
    parser.add_argument(
        "--skills-root",
        default=None,
        help="Root directory containing skill bundle directories. Defaults to <repo>/wp-docs-skills.",
    )
    return parser.parse_args()


def resolve_skills_root(arg_value: str | None) -> Path:
    if arg_value:
        return Path(arg_value).expanduser().resolve()
    return Path(__file__).resolve().parents[2] / "wp-docs-skills"


def collect_relative_refs(skill_md: Path) -> list[str]:
    text = skill_md.read_text(encoding="utf-8")
    refs: list[str] = []
    for match in RELATIVE_REF_RE.finditer(text):
        ref = match.group("code") or match.group("link")
        if ref:
            refs.append(ref.rstrip(".,:;"))
    return sorted(set(refs))


def main() -> int:
    args = parse_args()
    skills_root = resolve_skills_root(args.skills_root)

    if not skills_root.is_dir():
        print(f"ERROR: skills root not found: {skills_root}", file=sys.stderr)
        return 1

    skill_dirs = sorted(
        path for path in skills_root.iterdir() if path.is_dir() and (path / "SKILL.md").exists()
    )
    if not skill_dirs:
        print(f"ERROR: no skill bundles found under {skills_root}", file=sys.stderr)
        return 1

    errors: list[str] = []

    for skill_dir in skill_dirs:
        skill_name = skill_dir.name
        print(f"Checking skill bundle: {skill_name}")

        for relpath in STD_REQUIRED_FILES:
            candidate = skill_dir / relpath
            if not candidate.exists():
                errors.append(f"{skill_name}: missing required bundle file {relpath}")

        skill_md = skill_dir / "SKILL.md"
        for ref in collect_relative_refs(skill_md):
            resolved = (skill_dir / ref).resolve()
            if not resolved.exists():
                errors.append(f"{skill_name}: referenced path missing: {ref}")

    if errors:
        print("\nSkill bundle validation failed:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1

    print("\nSkill bundle validation passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
