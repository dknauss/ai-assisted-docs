#!/usr/bin/env python3

import re
import shutil
import subprocess
import sys
import urllib.request
from pathlib import Path
from typing import Optional


ROOT_DIR = Path(__file__).resolve().parents[2]
DOC_FILES = [
    ROOT_DIR.parent / "wp-security-benchmark" / "WordPress-Security-Benchmark.md",
    ROOT_DIR.parent / "wordpress-runbook-template" / "WP-Operations-Runbook.md",
]

for doc_file in DOC_FILES:
    if not doc_file.is_file():
        print(f"Missing canonical source file: {doc_file}")
        sys.exit(1)

PHP_BIN = shutil.which("php")
if not PHP_BIN:
    print("Missing php runtime for WP-CLI validation")
    sys.exit(1)

wp_path = shutil.which("wp")
downloaded_phar = False

if not wp_path:
    tmp_dir = ROOT_DIR / ".tmp"
    tmp_dir.mkdir(parents=True, exist_ok=True)
    wp_path = str(tmp_dir / "wp-cli.phar")
    if not Path(wp_path).exists():
        urllib.request.urlretrieve(
            "https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar",
            wp_path,
        )
    downloaded_phar = True


def wp_command(*args: str) -> list[str]:
    if downloaded_phar:
        return [PHP_BIN, wp_path, *args]
    return [wp_path, *args]


def run_wp_help(command_path: str) -> tuple[bool, str]:
    cmd = wp_command("--skip-plugins", "--skip-themes", "help", *command_path.split())
    result = subprocess.run(cmd, capture_output=True, text=True, check=False)
    return result.returncode == 0, result.stdout


def extract_command_path(line: str) -> Optional[str]:
    tokens = line.lstrip().split()
    if not tokens or tokens[0] != "wp":
        return None

    path_tokens: list[str] = []
    for token in tokens[1:]:
        if len(path_tokens) >= 3:
            break
        if re.fullmatch(r"[a-z][a-z0-9-]*", token):
            path_tokens.append(token)
            continue
        break

    if not path_tokens:
        return None
    return " ".join(path_tokens)


help_cache: dict[str, tuple[bool, str]] = {}
invalid = False
checked_paths = 0

print("== Source-Driven WP-CLI Validation ==")

for doc_file in DOC_FILES:
    for line_no, line in enumerate(doc_file.read_text().splitlines(), start=1):
        if not re.match(r"^\s*wp ", line):
            continue

        command_path = extract_command_path(line)
        if not command_path:
            continue

        checked_paths += 1

        if command_path not in help_cache:
            help_cache[command_path] = run_wp_help(command_path)

        ok, help_output = help_cache[command_path]
        if not ok:
            print(f"FAIL: invalid WP-CLI command path: {command_path}")
            print(f"  Source: {doc_file}:{line_no}")
            print(f"  Line:   {line}")
            invalid = True

if invalid:
    sys.exit(1)

print(f"WP-CLI source-driven command-path validation passed ({checked_paths} command lines checked).")
