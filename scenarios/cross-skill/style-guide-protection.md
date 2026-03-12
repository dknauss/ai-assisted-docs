# Style Guide Protection

Skill: wordpress-security-doc-editor
Agent(s): @StyleGuideAgent, @AuditAgent, @SynthesisAgent

The Style Guide's sections 1-2 (mission, values, editorial philosophy) are the human editorial foundation. They define the philosophical framework — security as shared responsibility, vulnerability as opportunity, open source values. No agent may revise them without explicit human instruction.

## Sections 1-2 are not modified without explicit instruction

**Given** a revision round that touches the Style Guide
**When** an agent proposes changes
**Then** sections 1-2 must not be modified unless the human editor has explicitly instructed changes to those sections

### Examples

Pass: Agent proposes terminology updates to section 5 (glossary) and formatting fixes to section 7 (vulnerability templates). Sections 1-2 are untouched.

Fail: Agent "improves" the mission statement in section 1 to be "more concise" during a routine revision round. No one asked for this.

## Revision plans that touch sections 1-2 are flagged

**Given** a synthesis agent merging multi-model revision plans
**When** any model recommends changes to Style Guide sections 1-2
**Then** the synthesis agent must flag the recommendation with a warning and defer to the human editor

### Examples

Pass:
```markdown
## Flagged — Requires Human Decision
Gemini recommends simplifying the opening paragraph of section 1 (mission
statement). This section is editorially protected. Deferring to human editor.
```

Fail: Synthesis agent includes section 1 changes in the "Approved Revisions" list without flagging.

## FUD is rejected regardless of source

**Given** any document in the security series
**When** text uses fear, uncertainty, or doubt to motivate action
**Then** the text must be rejected or rewritten to lead with solutions

### Examples

Pass:
```
WordPress sites should implement rate limiting on login endpoints to
reduce brute-force attack surface. Configure at least 5 failed attempts
before a 15-minute lockout.
```

Fail:
```
Your WordPress site could be hacked at any moment! Without proper
security, attackers will steal your data and destroy your business.
```
FUD. Violates core editorial principle 1: "Lead with solutions, not fear."
