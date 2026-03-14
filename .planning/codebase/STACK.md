# Technology Stack

**Analysis Date:** 2026-03-14

## Languages

**Primary:**
- Bash - Shell scripting for CI/CD pipelines, document building, and validation
- Python 3 - Document post-processing and DOCX manipulation
- Markdown - Document source format for all four canonical documents

**Secondary:**
- YAML - GitHub Actions workflow configuration
- XML - DOCX (Office Open XML) manipulation via Python standard library
- CSS - EPUB styling definitions

## Runtime

**Environment:**
- Bash 5+ (POSIX-compatible shell)
- Python 3.6+ (no version lock specified)
- GitHub Actions runners (ubuntu-latest)

**Package Manager:**
- None for Bash scripts
- Python standard library only (no external pip dependencies)
- Bash: No lock/dependency files

## Frameworks

**Core:**
- Pandoc 3.6.3 - Markdown-to-DOCX/PDF/EPUB conversion pipeline
- GitHub Actions - CI/CD orchestration for cross-repo validation and document generation

**Testing/Validation:**
- epubcheck - EPUB format validation
- pdfinfo (poppler-utils) - PDF metadata and structure validation
- DOCX unzip validation - ZIP integrity check for Office XML format

**Build/Dev:**
- LaTeX (texlive-xetex, texlive-latex-extra) - PDF generation via Pandoc
- Eisvogel template - Professional Pandoc LaTeX template for PDF layouts

## Key Dependencies

**Critical:**
- Pandoc 3.6.3 - Single point of failure; all document format conversions depend on it
- GitHub Actions (workflow_dispatch, pull_request triggers) - Orchestration and remote rebuilds
- Bash scripting framework - Cross-repo validation and build dispatch

**Infrastructure:**
- texlive packages (xetex, recommended, fonts, extra) - PDF typography and layout
- fonts-noto-core, fonts-noto-extra - Broad Unicode support (checkmarks, symbols)
- lmodern - LaTeX font package
- Pandoc Eisvogel template - Professional dark-header layout for PDFs

**Validation:**
- epubcheck (Java-based) - EPUB validation and standards compliance
- unzip - DOCX ZIP integrity checking
- pdfinfo - PDF structure and page count verification

## Configuration

**Environment:**
- Configured via GitHub workflow inputs (primary_markdown, artifact_base, toc_depth, commit_message)
- Pandoc styling configured via:
  - `reference.docx` — DOCX template (generated default or customized in Word)
  - `pdf-defaults.yaml` — PDF typography and layout (fonts, margins, colors)
  - `epub.css` — EPUB visual styling
- All styling assets auto-generated if missing in `.github/pandoc/`

**Build:**
- `.github/workflows/reusable-generate-docs.yml` — Reusable workflow for DOCX/PDF/EPUB generation
- `.github/workflows/validate-cross-repo-metrics.yml` — Cross-repo metrics synchronization validation
- Workflow dispatch entry point for remote rebuilds without code changes

**Key Configurations Required:**
- `reference.docx` must be opened in Word to customize styles and add page numbers (manual step)
- PDF defaults control Noto font family, page geometry (2.5cm margins), title page (deep navy #1A1A2E), WordPress blue rule (#0073AA)
- EPUB CSS sets max-width (46em), color scheme (light), Noto font family

## Platform Requirements

**Development:**
- Git (for workflow_dispatch and push triggers)
- GitHub CLI (`gh` command) for remote workflow dispatch
- Bash shell (local script execution)
- Python 3 (for DOCX manipulation with `add_docx_page_numbers.py`)
- Local sibling repositories for validation in strict mode: `wp-security-benchmark`, `wp-security-hardening-guide`, `wordpress-runbook-template`, `wp-security-style-guide`

**Production:**
- GitHub Actions (ubuntu-latest) — Single deployment target
- Ubuntu Linux 20.04+ (implied by ubuntu-latest runner)
- Pandoc 3.6.3 installation capability via wget+dpkg
- `apt-get` package manager for LaTeX and validation tools

## Build Pipeline

**Conversion Pipeline (3-stage):**
1. Markdown → DOCX (intermediary template layer, uses reference.docx)
2. DOCX → PDF (via LaTeX/Eisvogel template)
3. DOCX → EPUB (direct from DOCX with CSS styling)

**Outputs:**
- `{base}.docx` - Office Open XML format (template layer)
- `{base}.pdf` - PDF with professional styling via Eisvogel
- `{base}.epub` - EPUB3 with custom CSS

**Validation Steps:**
- DOCX: unzip structure check (ZIP integrity)
- EPUB: epubcheck standards compliance
- PDF: pdfinfo metadata and page count verification

**Date Injection:**
- Frontmatter date auto-updated from system clock (`date '+%B %-d, %Y'`)
- PDF metadata updated with version string if present in frontmatter

## Upstream Dependencies

**Canonical Source Documents:**
- `WordPress-Security-Benchmark.md` (2,421 lines)
- `WordPress-Security-Hardening-Guide.md` (621 lines)
- `WP-Operations-Runbook.md` (3,279 lines)
- `WP-Security-Style-Guide.md` (693 lines)

**Sibling Repositories:**
- `dknauss/wp-security-benchmark`
- `dknauss/wp-security-hardening-guide`
- `dknauss/wordpress-runbook-template`
- `dknauss/wp-security-style-guide`

All four repos checked out to validate cross-repo metrics synchronization.

---

*Stack analysis: 2026-03-14*
