# WordPress VIP Research Crosswalk

Date: 2026-03-14
Status: Internal editorial crosswalk

This crosswalk maps verified WordPress VIP claims to editorially transferable patterns and to the canonical WordPress security documents.

Canonical docs for approved follow-up work:

- Benchmark: `../wp-security-benchmark/WordPress-Security-Benchmark.md`
- Hardening Guide: `../wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md`
- Runbook: `../wordpress-runbook-template/WP-Operations-Runbook.md`
- Style Guide: `../wp-security-style-guide/WP-Security-Style-Guide.md`

## Infrastructure Claims

| VIP claim | Exact source | Transferable pattern | Canonical target(s) | Editorial status |
|---|---|---|---|---|
| Read-only web containers | docs: Infrastructure | Filesystem read-only as defense-in-depth | Benchmark: File security | **Add as L2** |
| Git-based deployment only | docs: Infrastructure | No direct file upload; code via Git | Benchmark: Deployment | Could add |
| Media in separate object store | docs: Infrastructure | Separate media storage | Benchmark: File security | Already covered (CDN) |
| Hourly encrypted backups | docs: Infrastructure | Backup frequency/encryption | Runbook: Backups | Could reference |
| ISO 27001, SOC2, FedRAMP | docs: Infrastructure | Compliance certifications | Benchmark: Compliance | **Add to refs** |

## Authentication Claims

| VIP claim | Exact source | Transferable pattern | Canonical target(s) | Editorial status |
|---|---|---|---|---|
| 2FA enforced by default for Admin+ | docs: Security Controls | 2FA enforcement baseline | Benchmark: Authentication | Could reference |
| Configurable session timeouts | docs: Security Controls | Session duration limits | Benchmark: Session | Already covered |
| Step-up authentication for sensitive actions | docs: Step-up authentication | Action-gated reauthentication for higher-risk resources and irreversible admin actions | Hardening Guide, Runbook | Could reference |
| Application passwords for XML-RPC | docs: Security Controls | Alternative to password auth | Benchmark: XML-RPC | Already covered |
| SSO available | docs: Security Controls | Single Sign-On | Benchmark: SSO | Could add |

## Monitoring Claims

| VIP claim | Exact source | Transferable pattern | Canonical target(s) | Editorial status |
|---|---|---|---|---|
| Traffic anomaly detection | docs: Infrastructure | Behavioral monitoring | Runbook: Monitoring | Internal |
| Brute-force built-in | docs: Infrastructure | Network-level blocking | Benchmark: Brute force | Already covered |
| Audit log all actions | docs: Customer Responsibility | Comprehensive logging | Runbook: Audit | Could add detail |
| WP-CLI command logging | docs: Customer Responsibility | CLI audit trail | Runbook: Audit | Could add |

## Shared Responsibility Claims

| VIP claim | Exact source | Transferable pattern | Canonical target(s) | Editorial status |
|---|---|---|---|---|
| Customer manages user access | docs: Customer Responsibility | User governance | Hardening Guide | Already covered |
| Code review required | docs: Customer Responsibility | Pre-deploy review | Hardening Guide | Could add |
| Third-party dependency management | docs: Customer Responsibility | Plugin/theme updates | Benchmark: Updates | Already covered |
| VIP as data processor | docs: Customer Responsibility | Processor/controller distinction | Style Guide | Could add to glossary |

## WordPress-Specific Claims

| VIP claim | Exact source | Transferable pattern | Canonical target(s) | Editorial status |
|---|---|---|---|---|
| Auto security patches | docs: Infrastructure | Automated patch deployment | Benchmark: Updates | Could reference |
| WP Cron disabled | docs: Infrastructure | External cron required | Benchmark: WP-Cron | Already covered |
| Plugin vulnerability scanning | docs: Security Controls | Automated vuln detection | Benchmark: Updates | Could add |
| Code Analysis Bot | docs: Code Analysis | Pre-commit scanning | Hardening Guide | Could reference |

## Priority Editorial Actions

1. **Add SOC2/FedRAMP to Benchmark compliance references** — enterprise requirements
2. **Add read-only filesystem as L2 control** — distinctive VIP feature
3. **Adopt "shared responsibility" framing** — explicit in VIP docs
4. **Add comprehensive audit logging** to Runbook
