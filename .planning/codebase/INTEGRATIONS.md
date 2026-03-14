# External Integrations

**Analysis Date:** 2026-03-14

## Version Control & Repository Management

**GitHub:**
- Primary platform for workflow orchestration and repository coordination
- Actions: CI/CD for document generation, cross-repo validation, and metrics synchronization
- Workflows: `reusable-generate-docs.yml` (called by downstream repos), `validate-cross-repo-metrics.yml` (metrics sync)
- Checkout: actions/checkout@v4 for pulling source repos during validation runs
- Cross-repo coordination: All four downstream repos checked out during metrics validation workflow

**GitHub CLI (`gh`):**
- Client: Used in `tools/rebuild-all-docs.sh` for remote workflow dispatch
- Auth: Requires GitHub CLI authentication with repo scope
- Operations: `gh workflow run generate-docs.yml --repo {repo}` to trigger remote rebuilds
- Supported: `--wait` flag for polling workflow completion status

## APIs & External Services

**WordPress.org APIs (referenced, not directly integrated):**
- [WordPress.org Plugin API](https://api.wordpress.org/plugins/info/1.2/) - Plugin metadata lookup (offline reference)
- [WordPress.org SVN](https://plugins.svn.wordpress.org/) - Plugin source verification (offline reference)

**Threat Intelligence Sources (documented references only):**
- [Patchstack](https://patchstack.com/) - WordPress vulnerability statistics and annual reports
- [Verizon DBIR](https://www.verizon.com/business/resources/reports/dbir/) - Cross-industry breach data
- [IBM Cost of a Data Breach](https://www.ibm.com/reports/data-breach) - Economic impact modeling

**Authority & Standards References (offline):**
- [WordPress Developer Documentation](https://developer.wordpress.org/) - Primary authority for all guidance
- [OWASP](https://owasp.org/) - Standards for non-WordPress-specific topics
- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks) - Security control format
- [NIST SP 800-63B](https://pages.nist.gov/800-63-4/sp800-63b.html) - Authentication standards
- [MDN](https://developer.mozilla.org/) - Web standards reference

## Data Storage

**Repositories:**
- Type: Git repositories (local + GitHub remote)
- Markdown files: Single primary document per downstream repo
- Metrics: `docs/current-metrics.md` in all four canonical repos
- Changesets: `CHANGELOG.md` in all four canonical repos

**File Storage:**
- Local filesystem only
- Generated artifacts stored in repo roots (`.pdf`, `.docx`, `.epub`)
- Styling assets cached in `.github/pandoc/` (reference.docx, pdf-defaults.yaml, epub.css)
- No cloud storage integration

**Caching:**
- None. Workflow caches disabled; full rebuild on every run.

## Authentication & Identity

**GitHub Actions:**
- No explicit auth provider configured in codebase
- Implicit: GITHUB_TOKEN automatically available to workflows (write permissions via `permissions: contents: write`)
- SSH: Git CLI can use deploy keys if configured at repo level (not in this codebase)

**User Context:**
- `git config user.email` and `git config user.name` hardcoded for commits (github-actions[bot])
- No OAuth, SAML, or multi-user auth

## Monitoring & Observability

**Error Tracking:**
- None. No integration with Sentry, Rollbar, or similar.

**Logs:**
- GitHub Actions built-in logging only
- Workflow step output visible in GitHub Actions UI
- Scripts use `echo` for status messages (no structured logging)

**Status Reporting:**
- Workflow status visible in GitHub UI (Actions tab)
- Email notifications from GitHub (not configured in codebase)
- No custom dashboards or webhooks

## CI/CD & Deployment

**Hosting:**
- GitHub (repositories and Actions runners)
- Deployment target: GitHub (push back to main branch or PR branches)

**CI Pipeline:**
- Event triggers:
  - `pull_request` on paths: `docs/current-metrics.md`, `tools/ci/validate_cross_repo_metrics.sh`, workflow files
  - `push` to main branch on same paths
  - `workflow_dispatch` for manual remote rebuilds (no branch restriction)
- Jobs:
  1. Validate cross-repo metrics (checkout 5 repos, run bash validation)
  2. Generate DOCX/PDF/EPUB (Pandoc pipeline, validation, auto-commit)

**Deployment Pipeline:**
- Document generation: Markdown → DOCX (template) → PDF (LaTeX) + EPUB (CSS)
- Output commit: Auto-committed to current branch with `git push` (requires write permissions)
- Concurrency control: `concurrency: generate-docs-${{ github.repository }}` with `cancel-in-progress: true`

**Runners:**
- ubuntu-latest (AWS EC2-backed, ~4 vCPU, ~7 GB RAM, ~14 GB disk)

## Environment Configuration

**Required env vars:**
- None hardcoded or required in environment
- GitHub Actions inputs (workflow_call parameters):
  - `primary_markdown` — Path to source document (required)
  - `artifact_base` — Output filename base (optional, derived from markdown filename if omitted)
  - `toc_depth` — Table of contents depth (optional, default 3)
  - `commit_message` — Auto-commit message (optional, default: "docs: regenerate PDF, Word, and EPUB documents [skip ci]")

**Secrets location:**
- GitHub repository secrets (not referenced in workflows)
- Git credentials: Implicit from GITHUB_TOKEN (GitHub Actions automatic)
- No `.env` files, no credential files in codebase

**Configuration files:**
- `.github/workflows/reusable-generate-docs.yml` — Workflow orchestration
- `.github/workflows/validate-cross-repo-metrics.yml` — Cross-repo validation
- `.github/pandoc/reference.docx` — DOCX template (auto-generated or manually customized)
- `.github/pandoc/pdf-defaults.yaml` — Pandoc PDF variables (Noto fonts, navy/blue colors, geometry)
- `.github/pandoc/epub.css` — EPUB styling (Noto fonts, light color scheme, max-width)

## Webhooks & Callbacks

**Incoming:**
- GitHub repository webhooks (configured at org/repo level, not in codebase):
  - pull_request events trigger `validate-cross-repo-metrics.yml`
  - push to main triggers `validate-cross-repo-metrics.yml`
  - workflow_dispatch allows manual trigger

**Outgoing:**
- Git push back to repo (auto-commit of generated artifacts)
- No external API callbacks or webhooks

## Cross-Repository Orchestration

**Relationships:**
- Central repo: `ai-assisted-docs` (this repository)
- Sibling canonical repos (managed separately):
  - `wp-security-benchmark`
  - `wp-security-hardening-guide`
  - `wordpress-runbook-template`
  - `wp-security-style-guide`

**Workflow Pattern:**
1. Human editor updates document in downstream repo
2. GitHub Actions triggers reusable workflow (`reusable-generate-docs.yml`)
3. Reusable workflow generates DOCX/PDF/EPUB
4. Artifacts auto-committed back to downstream repo
5. (Optionally) Metrics validation workflow in central repo verifies cross-repo consistency

**Dispatch Commands:**
- Remote dispatch via `tools/rebuild-all-docs.sh`:
  ```bash
  gh workflow run generate-docs.yml --repo dknauss/wp-security-benchmark
  gh workflow run generate-docs.yml --repo dknauss/wp-security-hardening-guide
  gh workflow run generate-docs.yml --repo dknauss/wordpress-runbook-template
  gh workflow run generate-docs.yml --repo dknauss/wp-security-style-guide
  ```
- All four workflows can be dispatched in parallel; concurrency guards prevent duplicate runs

## Build Tool Integration

**Pandoc:**
- Version: 3.6.3 (pinned)
- Installation: `wget` + `dpkg` in workflow (no package manager lock)
- LaTeX engine: XeLaTeX (supports Noto fonts and Unicode)
- Templates: Eisvogel (downloaded from GitHub releases)

**LaTeX Stack:**
- texlive-xetex — XeLaTeX engine
- texlive-latex-recommended — Standard LaTeX packages
- texlive-latex-extra — Additional packages for Eisvogel template
- texlive-fonts-recommended, texlive-fonts-extra — Font support
- lmodern — Modern LaTeX fonts

**Fonts:**
- Primary: Noto Serif (body text, custom in reference.docx)
- Sans: Noto Sans (headings)
- Monospace: Noto Sans Mono (code blocks)
- Fallback: Georgia, Helvetica Neue, Arial (EPUB CSS)
- Reason: Broad Unicode coverage for checkmarks, symbols, WordPress-specific glyphs

## Research & Reference Integrations

**Vendor Research Framework:**
- GridPane security research artifacts in `wp-security-doc-review/`
- Validated via `tools/ci/validate_gp_alignment.sh`
- References point to canonical repos, not archived findings

**External Data Integration (offline):**
- WordPress.org plugins SVN (manual reference, not automated)
- Security advisory feeds (Patchstack, vendor bulletins) (manual reference)
- CVSS/EPSS scores (mentioned in documents, sourced externally)

---

*Integration audit: 2026-03-14*
