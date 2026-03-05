# WordPress Documentation Skills

Machine-readable editorial skill bundles for the WordPress security document series.

## Purpose

Each skill defines the constraints, output templates, authority hierarchy, and done criteria that an LLM needs to produce editorial work matching Dan Knauss's documentation standards. Skills are the machine-readable counterparts to the agent roles defined in [AGENTS.md](../AGENTS.md).

## Available Skills

| Skill | Directory | Agents (AGENTS.md) | Produces |
|---|---|---|---|
| WordPress Runbook Ops | [`wordpress-runbook-ops/`](wordpress-runbook-ops/SKILL.md) | @RunbookAgent | Operational runbook procedures with WP-CLI commands, verification, rollback, and escalation |
| WordPress Security Doc Editor | [`wordpress-security-doc-editor/`](wordpress-security-doc-editor/SKILL.md) | @BenchmarkAgent, @HardeningGuideAgent, @StyleGuideAgent, @AuditAgent, @SynthesisAgent | Benchmark controls, hardening guidance, style/terminology edits, cross-document audit findings |

## Skill Structure

Each skill bundle contains:

```
<skill-name>/
  SKILL.md                       # Authoritative skill definition
  agents/
    claude.yaml                  # Claude Code / Claude agent config stub
    openai.yaml                  # OpenAI Codex agent config stub
  references/
    canonical-sources.md         # Source documents this skill references
```

## Usage

### Claude Code

Reference the skill in a Claude Code session by reading the `SKILL.md` file or including it as project context.

### OpenAI Codex

Use the `agents/openai.yaml` config when setting up a Codex agent. The `SKILL.md` provides the system-level instructions.

### Other LLMs

The `SKILL.md` file is platform-agnostic. Include it as a system prompt or instruction file in any LLM workflow.

## When to Use Which Skill

- **Writing or editing runbook procedures** (step-by-step commands, metadata, rollback) → `wordpress-runbook-ops`
- **Writing or editing benchmark controls, hardening guidance, or style guide content** → `wordpress-security-doc-editor`
- **Cross-document audit or consistency review** → `wordpress-security-doc-editor`
- **Runbook editing with editorial concerns** (terminology, authority hierarchy) → both skills together
- **Generic WP-CLI command execution** (not documentation) → use `wp-wpcli-and-ops` skill instead
