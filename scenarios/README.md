# Behavioral Scenarios

Structured behavioral specifications for the editorial skills in this project. Each scenario describes an expected behavior in Given/When/Then format, derived from the constraints, done criteria, and acceptance rules in the skill files and AGENTS.md.

## Purpose

These scenarios serve two audiences:

1. **Human editors** — readable specifications of what "correct" looks like for each skill. Use them to evaluate whether an AI-generated output meets editorial standards before accepting it.
2. **AI agents** — machine-readable expectations that can be checked against actual output. When a skill's done criteria say "every procedure includes rollback," these scenarios spell out exactly what that means.

## Organization

| Directory | Skill | What it covers |
|---|---|---|
| `security-researcher/` | `security-researcher` | Source grounding, vendor/editorial separation, Veloria verification |
| `wordpress-runbook-ops/` | `wordpress-runbook-ops` | Procedure schema, destructive command safety, WP-CLI validity, code fences |
| `wordpress-security-doc-editor/` | `wordpress-security-doc-editor` | Authority hierarchy, terminology, cross-document alignment, benchmark structure |
| `cross-skill/` | Multiple skills | Audit workflow, synthesis, Style Guide protection, version consistency |

## Scenario Format

Every `.md` file in this directory follows the same structure:

```markdown
# <Scenario Title>

Skill: <skill-name>
Agent(s): <AGENTS.md agent role(s)>

## <Scenario Name>

**Given** <precondition>
**When** <action or trigger>
**Then** <expected outcome>

### Examples

<concrete examples of pass/fail cases>
```

Rules:
- One file per behavioral concern. Keep scenarios focused.
- Each file may contain multiple related scenarios under the same concern.
- Examples use concrete, realistic content from the WordPress security domain.
- Pass/fail examples make the boundary between acceptable and unacceptable output unambiguous.

## How to Use

### During editorial review

Before accepting AI-generated output, check the relevant scenarios:

1. Identify which skill produced the output.
2. Read the scenario files for that skill.
3. Verify each applicable scenario's Then-clause against the actual output.
4. Flag any failures as revision requests.

### During skill development

When modifying a SKILL.md or adding new constraints:

1. Write the scenario first (the behavioral spec).
2. Update the skill to enforce the new behavior.
3. Verify existing scenarios still pass.

### As acceptance criteria

The scenarios in `cross-skill/` define behaviors that span multiple skills and agents. These are particularly useful during cross-document revision rounds (AGENTS.md, section 5) where multiple agents collaborate on a single revision plan.

## Relationship to Other Project Files

| File | Role |
|---|---|
| `AGENTS.md` | Defines agent roles and guardrails. Scenarios operationalize the acceptance criteria from section 6. |
| `wp-docs-skills/*/SKILL.md` | Defines skill constraints and done criteria. Scenarios expand these into testable expectations. |
| `docs/current-metrics.md` | Tracks project counts. Update when adding new scenario files. |
