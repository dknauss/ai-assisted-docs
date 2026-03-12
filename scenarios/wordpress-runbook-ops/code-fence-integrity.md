# Code Fence Integrity

Skill: wordpress-runbook-ops, wordpress-security-doc-editor
Agent(s): @RunbookAgent, @BenchmarkAgent, @HardeningGuideAgent

Corrupted code fences cascade through an entire document, inverting what renders as code and what renders as prose. One misplaced fence breaks every subsequent block. These scenarios prevent that.

## Closing fences are bare

**Given** a markdown document with fenced code blocks
**When** a code block is closed
**Then** the closing fence must be a bare ` ``` ` with no info string

### Examples

Pass:
````markdown
```bash
wp plugin list --status=active
```
````

Fail:
````markdown
```bash
wp plugin list --status=active
```bash
````
The "closing" fence `\`\`\`bash` is actually an opening fence. Everything after it renders as code until the next bare ` ``` `, corrupting the entire document.

## Every opening fence has exactly one closing fence

**Given** a document section
**When** it contains fenced code blocks
**Then** the count of opening fences must equal the count of bare closing fences in that section

### Examples

Pass: 2 opening fences, 2 closing fences.

Fail: 3 opening fences, 2 closing fences — one block is unclosed and all subsequent content renders incorrectly.

## No markdown escaping inside code blocks

**Given** a fenced code block
**When** it contains shell commands with metacharacters (`|`, `*`, `(`, `)`, `[`, `]`)
**Then** the characters must appear exactly as they would in a running command — no backslash escaping

### Examples

Pass:
```bash
grep -E "error|warning|fatal" /var/log/syslog
```

Fail:
```bash
grep -E "error\|warning\|fatal" /var/log/syslog
```
`\|` inside `grep -E` (ERE mode) matches a literal pipe character, not alternation. This command silently returns wrong results. In ERE, bare `|` is alternation. In BRE (`grep` without `-E`), `\|` is alternation.
