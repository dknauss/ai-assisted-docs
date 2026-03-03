# Single-Model, Multi-Agent Editorial Review

How the AGENTS.md persona roles map to Claude model tiers (Opus, Sonnet, Haiku) for parallel execution within a single editorial round.

## Architecture

A single-model multi-agent review uses one LLM family (Claude) at three capability tiers to run AGENTS.md roles in parallel. This is the Claude-internal leg of the broader multi-model review process. It produces Claude's independent findings before Gemini and GPT findings arrive.

### Model Tier Assignment

| AGENTS.md Role | Model Tier | Rationale |
|---|---|---|
| @SynthesisAgent | **Opus** | Complex judgment: weighing conflicting findings, evaluating overclaims, editorial recommendations |
| @AuditAgent | **Opus** | Cross-document reasoning: must hold all 4 documents in context simultaneously |
| @BenchmarkAgent | **Sonnet** | Structured review: CIS format compliance, code verification, flag checking |
| @HardeningGuideAgent | **Sonnet** | Factual/citation review: statistics, version statements, strategic alignment |
| @RunbookAgent | **Sonnet** | Command validation: WP-CLI syntax, procedural correctness, high volume |
| @StyleGuideAgent | **Sonnet** | Pattern matching: glossary coverage, terminology, style compliance |
| @ValidationAgent | **Haiku** | Mechanical checks: command existence, URL resolution, alphabetical ordering |

### Execution Phases

```
Phase 1 — Parallel Document Audits (4 × Sonnet, concurrent)
  @BenchmarkAgent      → reads Benchmark, applies its AGENTS.md constraints
  @HardeningGuideAgent → reads Hardening Guide, applies its constraints
  @RunbookAgent        → reads Runbook, applies its constraints
  @StyleGuideAgent     → reads Style Guide, applies its constraints

  Each produces structured findings:
    Document | Section/Line | Finding | Severity | Recommendation

Phase 2 — Validation (N × Haiku, concurrent, informed by Phase 1)
  WP-CLI validator     → every `wp` command in Benchmark + Runbook
  Code block linter    → no markdown escaping, correct grep syntax, no `?>`
  Glossary checker     → terms in Benchmark/Hardening/Runbook vs. glossary
  Reference checker    → URLs in References sections resolve

Phase 3 — Cross-Document Audit (Opus)
  @AuditAgent reads all 4 documents + Phase 1-2 findings
  Checks: classification alignment, version consistency,
  cross-reference accuracy, code agreement between docs

Phase 4 — Synthesis (Opus, after external model plans arrive)
  @SynthesisAgent merges:
    - Phase 1-3 internal findings
    - Gemini's independent review
    - GPT's independent review
  Produces prioritized revision plan for human editor
```

### Why Three Tiers

**Opus** is reserved for work that requires judgment across the full document set. Synthesis and cross-document auditing are not parallelizable — they need to reason about relationships between documents. Using Opus for these roles and Sonnet for everything else keeps costs proportional to cognitive demand.

**Sonnet** handles the document-specific audits. Each agent reads one document (~600–3000 lines) and applies its AGENTS.md constraints. These run in parallel. Sonnet has sufficient capability for structured technical review — checking CIS format compliance, validating code syntax, verifying citations — without the cost of Opus.

**Haiku** handles mechanical validation. These are tasks with clear right/wrong answers: does `wp cache flush --global` accept a `--global` flag? Is "Object cache" before "OWASP Top 10" alphabetically? Haiku is fast and cheap for this class of check, and can run many validators in parallel.

### Isolation Between Agents

Each Sonnet agent in Phase 1 runs independently with no knowledge of the other agents' findings. This is deliberate — it mirrors the multi-model independence principle from the broader review process. If @BenchmarkAgent and @RunbookAgent independently flag the same database privilege issue, that convergence is a high-confidence signal. If they diverge, the @AuditAgent in Phase 3 investigates.

Haiku validators in Phase 2 receive specific items to check (command lists, URL lists) extracted from Phase 1 findings, but do not see the full document context or the other agents' findings.

The @AuditAgent in Phase 3 sees everything: all four documents and all Phase 1-2 findings. This is the integration point where cross-document contradictions surface.

### Relationship to Multi-Model Review

This single-model multi-agent process produces Claude's contribution to the larger editorial round. It does not replace the multi-model review. Gemini and GPT still review independently, and the @SynthesisAgent merges all three perspectives.

The single-model multi-agent approach adds internal rigor to Claude's leg: instead of one monolithic audit, Claude's review is structured into specialized passes that can catch different types of issues. A @RunbookAgent focused on WP-CLI syntax is more likely to catch flag errors than a general-purpose audit scanning 7,000 lines for everything at once.

## Output

Each phase produces a structured findings file in `wp-security-doc-review/rounds/`:

```
rounds/
  YYYY-MM-DD/
    phase1-benchmark.md
    phase1-hardening-guide.md
    phase1-runbook.md
    phase1-style-guide.md
    phase2-validation.md
    phase3-cross-document.md
    phase4-synthesis.md        (after external model plans arrive)
```

The human editor reviews Phase 3 output (or Phase 4, if external plans are available) and approves, modifies, or rejects each finding before implementation.
