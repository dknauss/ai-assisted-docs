# STRUCTURE.md — Directory Layout & Organization

## Top-Level Layout

```
ai-assisted-docs/
├── AGENTS.md                        # Agent behavior guidelines
├── CHANGELOG.md                     # Project changelog
├── CHANGELOG_TEMPLATE.md            # Template for changelog entries
├── README.md                        # Project overview
├── LICENSE
│
├── docs/                            # Shared metrics and reference docs
│   └── current-metrics.md           # Cross-repo metrics (manually maintained)
│
├── wp-docs-skills/                  # AI skill definitions (per skill)
│   ├── README.md
│   ├── security-researcher/
│   │   ├── SKILL.md                 # Skill definition and instructions
│   │   ├── agents/
│   │   │   ├── claude.yaml          # Claude agent config
│   │   │   └── openai.yaml          # OpenAI agent config
│   │   └── references/
│   │       └── canonical-sources.md # Authority hierarchy for this skill
│   ├── wordpress-runbook-ops/       # (same structure)
│   └── wordpress-security-doc-editor/ # (same structure)
│
├── scenarios/                       # BDD test scenarios
│   ├── README.md
│   ├── security-researcher/         # Scenarios for security-researcher skill
│   │   ├── source-grounding.md
│   │   ├── vendor-editorial-separation.md
│   │   └── verification-with-veloria.md
│   ├── wordpress-runbook-ops/       # Scenarios for runbook ops skill
│   │   ├── code-fence-integrity.md
│   │   ├── command-validity.md
│   │   ├── destructive-command-safety.md
│   │   └── procedure-schema-completeness.md
│   ├── wordpress-security-doc-editor/ # Scenarios for doc editor skill
│   │   ├── authority-hierarchy.md
│   │   ├── benchmark-structure.md
│   │   ├── cross-document-alignment.md
│   │   └── terminology-consistency.md
│   ├── cross-skill/                 # Multi-skill workflow scenarios
│   │   ├── audit-workflow.md
│   │   ├── style-guide-protection.md
│   │   └── synthesis-workflow.md
│   └── test-runs/                   # Dated records of scenario test executions
│       ├── 2026-03-11-runbook-ops-domain-migration.md
│       └── 2026-03-12-doc-editor-security-docs.md
│
├── tools/                           # Automation and CI scripts
│   ├── rebuild-all-docs.sh          # Master rebuild script for all docs
│   ├── ci/
│   │   ├── validate_cross_repo_metrics.sh  # Validates metric consistency
│   │   └── validate_gp_alignment.sh        # Validates GP alignment
│   └── docs/
│       └── add_docx_page_numbers.py  # Adds page numbers to DOCX exports
│
├── wordpress-runbook-template/      # Canonical runbook template
│   └── CHANGELOG.md
│
├── wp-security-benchmark/           # WordPress security benchmark docs
│   └── CHANGELOG.md
│
├── wp-security-doc-review/          # Multi-AI review artifacts
│   ├── contributions/               # AI-contributed reviews (per model)
│   │   ├── claude.md
│   │   ├── codex.md
│   │   └── gemini.md
│   └── early-examples/              # Historical examples
│
├── wp-security-hardening-guide/     # Hardening guide canonical docs
│
├── wp-security-style-guide/         # WordPress security style guide
│
└── .github/
    └── workflows/
        ├── reusable-generate-docs.yml       # Reusable doc generation workflow
        └── validate-cross-repo-metrics.yml  # CI metric validation
```

## Key Locations

| Purpose | Path |
|---|---|
| Skill definitions | `wp-docs-skills/<skill-name>/SKILL.md` |
| Agent configs | `wp-docs-skills/<skill-name>/agents/` |
| Authority references | `wp-docs-skills/<skill-name>/references/canonical-sources.md` |
| BDD scenarios | `scenarios/<skill-name>/` |
| Cross-skill scenarios | `scenarios/cross-skill/` |
| Test run records | `scenarios/test-runs/` |
| CI validation scripts | `tools/ci/` |
| Shared metrics | `docs/current-metrics.md` |
| CI workflows | `.github/workflows/` |

## Naming Conventions

### Files
- Scenario files: `kebab-case.md` (descriptive of the behavior tested)
- Test run records: `YYYY-MM-DD-<skill>-<topic>.md`
- Skill definitions: always `SKILL.md`
- Agent configs: always `claude.yaml` / `openai.yaml`
- Scripts: `snake_case.sh` or `kebab-case.sh`

### Directories
- Skills: `kebab-case` matching the skill name (e.g., `wordpress-runbook-ops`)
- Scenario categories: match skill directory name exactly
- Canonical doc directories: `wp-<doc-type>` pattern

## Where to Add New Things

| Task | Location |
|---|---|
| New skill | `wp-docs-skills/<new-skill>/` with `SKILL.md`, `agents/`, `references/` |
| New scenarios for existing skill | `scenarios/<skill-name>/` |
| New cross-skill scenario | `scenarios/cross-skill/` |
| New test run record | `scenarios/test-runs/YYYY-MM-DD-<description>.md` |
| New CI validation script | `tools/ci/` |
| New canonical doc section | `wp-<doc-type>/` at root |
