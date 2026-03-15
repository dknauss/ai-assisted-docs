# Patchstack Research Crosswalk

Date: 2026-03-14
Status: Internal editorial crosswalk

This crosswalk maps verified Patchstack claims to editorially transferable patterns and to the canonical WordPress security documents.

Canonical docs for approved follow-up work:

- Benchmark: `../wp-security-benchmark/WordPress-Security-Benchmark.md`
- Hardening Guide: `../wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md`
- Runbook: `../wordpress-runbook-template/WP-Operations-Runbook.md`
- Style Guide: `../wp-security-style-guide/WP-Security-Style-Guide.md`

## Core Technology Claims

| Patchstack claim | Exact source | Transferable pattern | Canonical target(s) | Editorial status |
|---|---|---|---|---|
| Virtual patching definition | docs: Virtual Patching | Security layer blocking exploits without code changes | Glossary, Benchmark | **Add to glossary** |
| Endpoint WAF vs Cloud WAF | docs: Virtual Patching | Application-aware firewall vs traffic proxy | Benchmark: WAF | Could add nuance |
| Zero-day protection | docs: Virtual Patching | Protection before official patches | Benchmark: Defense-in-depth | **Add as option** |
| Auto-mitigation | docs: Virtual Patching | Automated vulnerability response | Runbook: Incident response | Could add |

## Statistics Claims

| Patchstack claim | Exact source | Transferable pattern | Canonical target(s) | Editorial status |
|---|---|---|---|---|
| 7,966 vulnerabilities in 2024 | Whitepaper 2025 | Ecosystem vulnerability data | Benchmark: Stats | **Cite with caution** |
| 34% increase from 2023 | Whitepaper 2025 | Vulnerability trend | Benchmark: Stats | **Cite with caution** |
| 99%+ from plugins/themes | docs: Virtual Patching | Third-party risk | Hardening Guide | **Reference** |
| 33% unpatched by developers | marketing: Security | Why virtual patching matters | Hardening Guide | Could reference |

## Product/Platform Claims

| Patchstack claim | Exact source | Transferable pattern | Canonical target(s) | Editorial status |
|---|---|---|---|---|
| Trusted by Pagely, Cloudways, GridPane | plugin: WordPress | Enterprise adoption | — | Internal context |
| 48-hour early warning | plugin: WordPress | Community vs paid tiers | — | Internal context |
| Vulnerability database | database | Public vuln tracking | Benchmark | Could reference |

## Compliance Claims

| Patchstack claim | Exact source | Transferable pattern | Canonical target(s) | Editorial status |
|---|---|---|---|---|
| PCI-DSS compliance | docs: WooCommerce | Vulnerability management | Benchmark: Compliance | Could reference |
| EU CRA requirements | Whitepaper 2025 | Regulatory compliance | Hardening Guide | **Add to compliance** |

## Priority Editorial Actions

1. **Add "virtual patching" to Style Guide glossary** — Essential term for canonical docs
2. **Add vulnerability statistics** to Benchmark — Use Patchstack data with citation
3. **Add virtual patching** as defense-in-depth option in Hardening Guide
4. **Reference EU CRA** compliance requirements — Upcoming regulatory change
