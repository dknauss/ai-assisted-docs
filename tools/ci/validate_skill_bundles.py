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


ESCAPING_LINK_RE = re.compile(r"\]\(((?:\.\./)+[^)\s]+)\)")

FRONTMATTER_RE = re.compile(r"\A---\n(.*?)\n---\n", re.DOTALL)


def check_frontmatter(skill_md: Path, skill_name: str) -> list[str]:
    """Return problems with the SKILL.md YAML frontmatter required for skill discovery."""
    match = FRONTMATTER_RE.match(skill_md.read_text(encoding="utf-8"))
    if not match:
        return ["SKILL.md has no YAML frontmatter (name and description are required)"]

    fields = {}
    for line in match.group(1).splitlines():
        key, sep, value = line.partition(":")
        if sep:
            fields[key.strip()] = value.strip().strip("\"'")

    problems = []
    if fields.get("name") != skill_name:
        problems.append(f"SKILL.md frontmatter name must be {skill_name!r}, found {fields.get('name')!r}")
    if not fields.get("description"):
        problems.append("SKILL.md frontmatter is missing a description")
    return problems


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
        if skill_md.exists():
            errors.extend(f"{skill_name}: {problem}" for problem in check_frontmatter(skill_md, skill_name))

        for ref in collect_relative_refs(skill_md):
            resolved = (skill_dir / ref).resolve()
            if not resolved.exists():
                errors.append(f"{skill_name}: referenced path missing: {ref}")

        # Links in reference files must not climb out of the bundle: only the bundle
        # and the scenarios mirror are copied on install, so such links break there.
        for ref_md in sorted((skill_dir / "references").glob("*.md")):
            for target in ESCAPING_LINK_RE.findall(ref_md.read_text(encoding="utf-8")):
                if "/scenarios/" not in target:
                    errors.append(
                        f"{skill_name}: {ref_md.name} links outside the bundle ({target}); use a repository URL"
                    )

    if errors:
        print("\nSkill bundle validation failed:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1

    print("\nSkill bundle validation passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
