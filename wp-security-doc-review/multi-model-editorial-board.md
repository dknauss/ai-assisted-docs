# Multi-Model Editorial Board

How to orchestrate the full multi-model review process described in AGENTS.md, PROCESS-SUMMARY.md, and the project README. Three approaches, from simplest to most automated.

## The Problem

The editorial process requires three independent LLM reviews of the same four-document set. Independence is critical — each model must review the documents without seeing the other models' findings. This prevents alignment pressure (models deferring to each other) and maximizes the chance of catching different types of errors.

No single orchestration tool currently manages multi-model editorial reviews out of the box. The approaches below are pragmatic solutions using existing infrastructure.

## Approach 1: Manual (Current Practice)

The human editor operates each model's interface directly.

### Workflow

1. **Prepare the review prompt.** A single prompt instructs the model to review all four documents for technical accuracy, cross-document consistency, and alignment with the authority hierarchy. The prompt is identical across models.

2. **Submit to each model separately:**
   - **Gemini 2.5 Pro**: Upload all four `.md` files to a Gemini session (or use the API via AI Studio). Request a structured revision plan.
   - **GPT-5.3-Codex**: Upload or paste the documents into a ChatGPT or API session. Request a structured revision plan.
   - **Claude Opus 4**: Submit via Claude Code, Claude.ai, or the API. Request a structured revision plan.

3. **Collect the three plans.** Save each as a separate file:
   - `rounds/YYYY-MM-DD/gemini-review.md`
   - `rounds/YYYY-MM-DD/gpt-review.md`
   - `rounds/YYYY-MM-DD/claude-review.md`

4. **Feed the external plans to Claude** (the primary working model) for synthesis:
   - Share the Gemini and GPT plans alongside Claude's own findings.
   - Claude's @SynthesisAgent compares, cross-validates, and produces a unified plan.
   - The human editor reviews and approves.

### Pros

- No tooling or API setup required.
- Works with any model that accepts file uploads.
- Full human control over what each model sees.
- Each model interaction can be tuned (context window, temperature, system prompts).

### Cons

- Time-intensive: 3 separate sessions, manual copy-paste of ~7,000 lines.
- Error-prone: risk of using slightly different prompts or document versions.
- No structured output enforcement — each model formats findings differently.

### When to Use

First revision round. One-off audits. When a new model becomes available and you want to test its review quality before integrating it into automation.

---

## Approach 2: Semi-Automated (Editor-Mediated)

Claude serves as the orchestration hub. The editor manually feeds in external model outputs, but the internal Claude-side review (single-model multi-agent) runs automatically.

### Workflow

1. **Claude runs its internal review** using the single-model multi-agent architecture (see `single-model-multi-agent.md`):
   - Phase 1: Four Sonnet agents audit documents in parallel.
   - Phase 2: Haiku validators check WP-CLI commands, URLs, glossary coverage.
   - Phase 3: Opus @AuditAgent runs cross-document consistency check.
   - Phases 1-3 produce structured findings in `rounds/YYYY-MM-DD/`.

2. **The editor submits the same documents to Gemini and GPT** using their respective interfaces or APIs. Each returns a revision plan.

3. **The editor pastes the external plans into the Claude session:**
   ```
   Here are the independent review plans from the other two models.
   Please run the @SynthesisAgent to merge these with your Phase 1-3 findings.

   ## Gemini Review
   [paste gemini-review.md]

   ## GPT Review
   [paste gpt-review.md]
   ```

4. **Claude's @SynthesisAgent** (Phase 4) merges all three perspectives:
   - Identifies convergent findings (high confidence).
   - Flags divergent findings for investigation.
   - Verifies claims against source documents.
   - Produces a prioritized revision plan with model attribution.

5. **The editor reviews the synthesized plan** and approves, modifies, or rejects each finding.

### Pros

- Claude-side review is fully structured and automated.
- External model outputs are incorporated with full provenance.
- The editor controls when and how external plans are introduced.
- Works with any combination of external models.

### Cons

- External model submissions are still manual.
- Requires the editor to maintain the standard review prompt for Gemini and GPT.
- Timing coordination: Claude's internal phases should complete before synthesis begins.

### When to Use

Regular revision rounds. This is the recommended approach for most editorial cycles — it balances automation with human oversight.

---

## Approach 3: Scripted (API-Driven)

A script calls all three model APIs in parallel, collects structured outputs, and feeds everything to Claude for synthesis. The human editor reviews only the final synthesized plan.

### Architecture

```
┌──────────────────────────────────────────────────────┐
│                   review-round.sh                     │
│                                                       │
│  1. Read documents from repos                         │
│  2. Build review prompt from template                 │
│  3. Call APIs in parallel:                             │
│     ├── Gemini 2.5 Pro API  ──→  gemini-review.md     │
│     ├── GPT-5.3-Codex API   ──→  gpt-review.md       │
│     └── Claude Opus 4 API   ──→  claude-review.md     │
│  4. Wait for all three to complete                    │
│  5. Feed all three plans to Claude @SynthesisAgent    │
│  6. Output: synthesis.md → human editor               │
└──────────────────────────────────────────────────────┘
```

### Implementation: `review-round.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

# Configuration
ROUND_DIR="wp-security-doc-review/rounds/$(date +%Y-%m-%d)"
PROMPT_TEMPLATE="wp-security-doc-review/review-prompt-template.md"
mkdir -p "$ROUND_DIR"

# Document paths (update to match your local clones)
DOCS=(
  "wp-security-benchmark/WordPress-Security-Benchmark.md"
  "wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md"
  "wordpress-runbook-template/WP-Operations-Runbook.md"
  "wp-security-style-guide/WP-Security-Style-Guide.md"
)

# Build the combined document payload
payload=""
for doc in "${DOCS[@]}"; do
  payload+="## $(basename "$doc" .md)"$'\n\n'
  payload+="$(cat "$doc")"$'\n\n---\n\n'
done

# Read the review prompt template
prompt=$(cat "$PROMPT_TEMPLATE")

echo "=== Starting multi-model review round ==="
echo "Round directory: $ROUND_DIR"

# --- Gemini API call ---
call_gemini() {
  echo "[Gemini] Submitting review..."
  # Uses Google's generativelanguage API
  # Requires GEMINI_API_KEY environment variable
  curl -s "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro:generateContent?key=$GEMINI_API_KEY" \
    -H 'Content-Type: application/json' \
    -d "$(jq -n --arg prompt "$prompt" --arg docs "$payload" '{
      "contents": [{"parts": [{"text": ($prompt + "\n\n" + $docs)}]}],
      "generationConfig": {"temperature": 0.2, "maxOutputTokens": 16384}
    }')" \
    | jq -r '.candidates[0].content.parts[0].text' \
    > "$ROUND_DIR/gemini-review.md"
  echo "[Gemini] Complete → $ROUND_DIR/gemini-review.md"
}

# --- GPT API call ---
call_gpt() {
  echo "[GPT] Submitting review..."
  # Uses OpenAI's chat completions API
  # Requires OPENAI_API_KEY environment variable
  curl -s "https://api.openai.com/v1/chat/completions" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -H 'Content-Type: application/json' \
    -d "$(jq -n --arg prompt "$prompt" --arg docs "$payload" '{
      "model": "gpt-5.3-codex",
      "messages": [
        {"role": "system", "content": $prompt},
        {"role": "user", "content": $docs}
      ],
      "temperature": 0.2,
      "max_tokens": 16384
    }')" \
    | jq -r '.choices[0].message.content' \
    > "$ROUND_DIR/gpt-review.md"
  echo "[GPT] Complete → $ROUND_DIR/gpt-review.md"
}

# --- Claude API call ---
call_claude() {
  echo "[Claude] Submitting review..."
  # Uses Anthropic's messages API
  # Requires ANTHROPIC_API_KEY environment variable
  curl -s "https://api.anthropic.com/v1/messages" \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H 'Content-Type: application/json' \
    -d "$(jq -n --arg prompt "$prompt" --arg docs "$payload" '{
      "model": "claude-opus-4-20250514",
      "max_tokens": 16384,
      "messages": [
        {"role": "user", "content": ($prompt + "\n\n" + $docs)}
      ]
    }')" \
    | jq -r '.content[0].text' \
    > "$ROUND_DIR/claude-review.md"
  echo "[Claude] Complete → $ROUND_DIR/claude-review.md"
}

# Run all three in parallel
call_gemini &
call_gpt &
call_claude &

echo "Waiting for all three models..."
wait
echo "=== All reviews complete ==="

# --- Synthesis step ---
echo "[Synthesis] Merging findings..."
# This calls Claude again with all three plans for @SynthesisAgent work
synthesis_prompt="You are the @SynthesisAgent from AGENTS.md. Merge these three independent review plans into a single prioritized revision plan. For each finding, state which models agreed/disagreed and how you verified it. Flag overclaimed findings. Produce the output in the structured format: Finding | Severity | Models | Verification | Recommendation | Status."

all_reviews="## Claude Review\n\n$(cat "$ROUND_DIR/claude-review.md")\n\n---\n\n## Gemini Review\n\n$(cat "$ROUND_DIR/gemini-review.md")\n\n---\n\n## GPT Review\n\n$(cat "$ROUND_DIR/gpt-review.md")"

curl -s "https://api.anthropic.com/v1/messages" \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H 'Content-Type: application/json' \
  -d "$(jq -n --arg prompt "$synthesis_prompt" --arg reviews "$all_reviews" --arg docs "$payload" '{
    "model": "claude-opus-4-20250514",
    "max_tokens": 16384,
    "messages": [
      {"role": "user", "content": ($prompt + "\n\n## Source Documents\n\n" + $docs + "\n\n## Review Plans to Synthesize\n\n" + $reviews)}
    ]
  }')" \
  | jq -r '.content[0].text' \
  > "$ROUND_DIR/synthesis.md"

echo "=== Synthesis complete ==="
echo "Review: $ROUND_DIR/synthesis.md"
echo ""
echo "Next step: Human editor reviews synthesis.md and approves/modifies/rejects each finding."
```

### Review Prompt Template: `review-prompt-template.md`

```markdown
You are reviewing four companion WordPress security documents for technical accuracy,
cross-document consistency, and alignment with authoritative sources.

## Instructions

1. Review all four documents below.
2. For each finding, provide:
   - **Document**: Which document contains the issue.
   - **Location**: Section number and/or line reference.
   - **Finding**: What is wrong or inconsistent.
   - **Severity**: Critical (breaks functionality or security), High (factual error or
     cross-doc contradiction), Medium (incomplete or imprecise), Low (polish/style).
   - **Recommendation**: Specific fix.
   - **Verification**: How to confirm the finding is correct (e.g., "run `wp help cache flush`"
     or "check developer.wordpress.org/reference/functions/wp_kses/").

3. Check these specific areas:
   - WP-CLI commands: Do they exist? Are flags correct? (Use `wp help <command>` as reference.)
   - PHP constants: Do they exist in the stated WordPress/PHP version?
   - Cross-document agreement: Same control, same classification (L1/L2, baseline/optional).
   - Database privileges: Should be 8 specific grants, not `GRANT ALL PRIVILEGES`.
   - Version floors: PHP, WordPress, MySQL version requirements must be consistent.
   - Glossary coverage: Key terms used in multiple documents should have Style Guide entries.

4. Do NOT suggest stylistic rewrites unless they fix a technical error or ambiguity.
5. Do NOT flag sections 1-2 of the Style Guide (mission/values) — these are out of scope.

## Authority Hierarchy

When sources conflict:
1. WordPress Developer Documentation (developer.wordpress.org)
2. WordPress core source code
3. WP-CLI documentation and source
4. External standards (OWASP, CIS, NIST, MDN)

## Documents
```

### Pros

- Fully parallel: all three models review simultaneously.
- Consistent prompts: same template, same document versions.
- Structured output pipeline: all artifacts land in the round directory.
- Reproducible: the script + template define the entire process.
- Can be extended to additional models trivially.

### Cons

- Requires API keys and billing for all three providers.
- Context window limits: ~7,000 lines of markdown may exceed some models' effective context.
  - Mitigation: split into per-document reviews, then a cross-document pass.
- API response formats may change; the `jq` extraction is brittle.
- No retry logic, rate limiting, or error handling in the basic script.
- Token costs: a full four-document review at Opus/Pro/Codex tier runs $5-15 per model per round.

### When to Use

Regular revision cycles where the process is mature and the editor wants to minimize manual steps. Also useful for regression testing: run the full review after a batch of changes to verify nothing was broken.

### Production Hardening

For a production version of the script, add:

- **Retry with exponential backoff** for API failures.
- **Response validation**: check that each model returned a non-empty, well-structured review before proceeding to synthesis.
- **Document versioning**: include git commit SHAs in the round directory so reviews are tied to exact document states.
- **Cost tracking**: log token counts and estimated costs per round.
- **Structured output schemas**: use each API's structured output or JSON mode to enforce consistent finding formats.
- **Diff-based review**: for minor revisions, send only the diff plus surrounding context rather than full documents.

---

## Combining Approaches: Single-Model Multi-Agent + Multi-Model Board

The single-model multi-agent architecture (see `single-model-multi-agent.md`) and the multi-model editorial board are complementary, not competing. They operate at different levels:

```
Multi-Model Editorial Board (this document)
├── Gemini 2.5 Pro  ──→  independent review plan
├── GPT-5.3-Codex   ──→  independent review plan
└── Claude Opus 4   ──→  independent review plan
    └── Single-Model Multi-Agent (single-model-multi-agent.md)
        ├── Phase 1: 4 × Sonnet document agents (parallel)
        ├── Phase 2: N × Haiku validators (parallel)
        ├── Phase 3: 1 × Opus cross-document audit
        └── Phase 4: 1 × Opus synthesis (merges all three model plans)
```

Claude's contribution to the editorial board is not a single monolithic review — it is itself a multi-agent, multi-tier process that produces structured, layered findings. The other models contribute their own independent perspectives. The @SynthesisAgent in Phase 4 is where all perspectives converge.

This layered architecture means:

- **Within Claude's leg**: Specialized agents catch different types of issues (WP-CLI syntax vs. glossary gaps vs. CIS format compliance). Haiku validates mechanical details cheaply. Opus reasons across the full document set.
- **Across models**: Different training data and reasoning approaches catch different blindspots. Gemini, GPT, and Claude fail in different ways — and the editorial board exists to exploit those differences.
- **The human editor** reviews the synthesized output, not the raw findings from 7+ agents and 3 models. The synthesis step compresses the signal.

## Choosing an Approach

| Factor | Manual | Semi-Automated | Scripted |
|---|---|---|---|
| **Setup time** | None | Minimal (Claude Code session) | 1-2 hours (API keys, script, testing) |
| **Per-round effort** | High (3 sessions, manual copy) | Medium (1 session + 2 external submissions) | Low (run script, review output) |
| **Prompt consistency** | Risk of drift | Moderate (template exists, manual use) | Guaranteed (template in version control) |
| **Reproducibility** | Low | Medium | High |
| **Flexibility** | High (can improvise) | High | Medium (script changes needed) |
| **Cost visibility** | Per-session pricing | Mixed | Full token/cost tracking |
| **Best for** | First rounds, testing new models | Regular editorial cycles | Mature process, regression testing |

## References

- [single-model-multi-agent.md](single-model-multi-agent.md) — How Claude's internal multi-agent review works.
- [PROCESS-SUMMARY.md](PROCESS-SUMMARY.md) — How the editorial process works in practice.
- [AGENTS.md](../AGENTS.md) — Agent role definitions and constraints.
- [example-revision-plan.md](example-revision-plan.md) — Sample synthesized output.
