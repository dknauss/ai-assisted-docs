# Editorial Workflow Diagram

Mermaid diagram for the WordPress security document series editorial methodology.

This diagram summarizes the workflow described in:

- [AGENTS.md](../../AGENTS.md)
- [../PROCESS-SUMMARY.md](../PROCESS-SUMMARY.md)
- [single-model-multi-agent.md](single-model-multi-agent.md)
- [multi-model-editorial-board.md](multi-model-editorial-board.md)

## Workflow

```mermaid
flowchart TD
    A["Start editorial round"] --> B["Step 0: Mechanical preflight<br/>metrics / WP-CLI watchlist / glossary drift / workflow health"]

    B --> C{"Preflight passes?"}
    C -- "No" --> C1["Fix or record mechanical issues"] --> B
    C -- "Yes" --> D{"Mode?"}

    D -- "Default" --> E["Single-model multi-agent review"]
    D -- "Escalation" --> F["Independent multi-model review<br/>Gemini / GPT / Claude"]

    E --> E1["Parallel role reviews<br/>Benchmark / Hardening / Runbook / Style Guide"]
    E1 --> E2["Validation pass<br/>commands / code blocks / glossary / references"]
    E2 --> E3["Cross-document audit"]
    E3 --> G["Synthesis"]

    F --> F1["Collect independent review plans"]
    F1 --> F2["Verify agreements and disagreements"]
    F2 --> G["Synthesis"]

    G --> H["Human editorial decision<br/>accept / modify / reject"]
    H --> I{"Approved?"}

    I -- "No" --> J["Archive as rejected or stale"]
    I -- "Yes" --> K["Implement approved changes in canonical repos"]

    K --> L["Update metrics / changelog / regenerate artifacts as needed"]
    L --> M["Post-implementation audit"]
    M --> N["Stateful closeout<br/>applied / rejected / stale"]
    N --> O["Round complete"]
    J --> O
```

## Reading Notes

- **Default mode** is the normal operating path for routine editorial work.
- **Escalation mode** adds independent external-model review when the revision scope or risk justifies it.
- **Synthesis** never bypasses the human editor.
- **Closeout** is not complete until every synthesized finding is archived as `applied`, `rejected`, or `stale`.
