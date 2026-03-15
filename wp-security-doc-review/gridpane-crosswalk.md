# GridPane Research Crosswalk

Date: 2026-03-14
Status: Internal editorial crosswalk
Research scope: Comprehensive security KB review (32 articles)

This crosswalk maps verified GridPane claims to editorially transferable patterns and to the canonical WordPress security documents. It does not treat archived review files in this repo as the source of truth.

Canonical docs for approved follow-up work:

- Benchmark: `../wp-security-benchmark/WordPress-Security-Benchmark.md`
- Hardening Guide: `../wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md`
- Runbook: `../wordpress-runbook-template/WP-Operations-Runbook.md`
- Style Guide: `../wp-security-style-guide/WP-Security-Style-Guide.md`

Use [`gridpane-crosswalk-template.md`](gridpane-crosswalk-template.md) when adding new vendor-specific research rows.

## Server-Level Security Claims

| GridPane claim | Exact source | Transferable pattern | Canonical target(s) | Current editorial status |
|---|---|---|---|---|
| SSH locked to key-based access; root user secured | KB: Default Security | SSH key-based auth as baseline | Benchmark: SSH hardening | Already covered |
| UFW configured by default | KB: Default Security | Firewall enabled by default | Benchmark: Network controls | Already covered |
| Fail2Ban protects SSH by default | KB: Default Security | Intrusion prevention on SSH | Benchmark: Brute force | Already covered |
| System user isolation per site | KB: Default Security | Multi-tenant isolation | Hardening Guide: Architecture | Already covered |
| /tmp mounted noexec (Ubuntu 22.04+) | KB: Default Security | Disable /tmp execution | Benchmark: Server hardening | Missing — could add |
| Auth logs and Fail2Ban logs configured | KB: Default Security | Logging enabled by default | Runbook: Monitoring | Already covered |
| GridPane handles security updates/patches | KB: Server Updates | Managed updates | Hardening Guide: Maintenance | Already covered |

## WordPress Security Defaults Claims

| GridPane claim | Exact source | Transferable pattern | Canonical target(s) | Current editorial status |
|---|---|---|---|---|
| PHP updated to latest by default | KB: Default Security | Current PHP versions | Hardening Guide: PHP | Already covered |
| Latest WP version on new sites | KB: Default Security | Auto-update WordPress | Benchmark: Updates | Already covered |
| Directory browsing disabled | KB: Default Security | Disable directory listing | Benchmark: Information disclosure | Already covered |
| PHP blocked in uploads/themes | KB: Default Security | Disable PHP execution | Benchmark: File upload security | Already covered |
| wp-config.php outside web root | KB: Default Security | Config file placement | Benchmark: Config security | Already covered |
| Security headers by default | KB: Default Security | HSTS, CSP, X-Frame-Options | Benchmark: Headers | Already covered |
| SFTP/SSH only, no FTP | KB: Default Security | Secure file transfer | Benchmark: Access control | Already covered |
| Rate limiting: wp-login.php 1 req/sec | KB: Default Security | Login rate limiting | Benchmark: Rate limiting | **NEW — Add as L1** |
| Rate limiting: admin-ajax less strict | KB: Default Security | API rate limiting | Benchmark: Rate limiting | Could add |

## WAF Claims

| GridPane claim | Exact source | Transferable pattern | Canonical target(s) | Current editorial status |
|---|---|---|---|---|
| 6G WAF: lightweight, popular | KB: Security Tab | Lightweight server WAF | Benchmark: WAF controls | Already covered |
| 7G WAF: successor to 6G, more secure | KB: 7G WAF | Next-gen server WAF | Benchmark: WAF controls | Already covered |
| 7G supports per-rule whitelisting | KB: 7G WAF | Granular WAF tuning | Runbook: WAF config | Could add detail |
| ModSecurity: OWASP CRS, enterprise | KB: Security Tab | Enterprise WAF | Benchmark: WAF controls | Already covered |
| 6G/7G originally by Jeff Starr | KB: Security Tab | Community-derived rules | — | Internal context |
| 7G Developer+ only (needs verification) | KB: Security Tab | Tiered WAF availability | — | **Needs verification** |

## Fail2Ban Claims

| GridPane claim | Exact source | Transferable pattern | Canonical target(s) | Current editorial status |
|---|---|---|---|---|
| Server-level Fail2Ban for wp-login.php | KB: Fail2Ban | Brute force prevention | Benchmark: Brute force | Already covered |
| Server-level Fail2Ban for xmlrpc.php | KB: Fail2Ban | Brute force prevention | Benchmark: XML-RPC | Already covered |
| WP Fail2Ban plugin integration | KB: Fail2Ban | Application-layer integration | Runbook: Security config | Could add |
| User enumeration blocking | KB: Fail2Ban | Prevent username discovery | Benchmark: User enumeration | Already covered |
| Comment/pingback/spam logging | KB: Fail2Ban | Log-based monitoring | Runbook: Logging | Could add |
| Cloudflare/Stackpath/Sucuri real IP | KB: Fail2Ban | CDN-aware blocking | Runbook: CDN config | Could add |

## Hardening Options Claims

| GridPane claim | Exact source | Transferable pattern | Canonical target(s) | Current editorial status |
|---|---|---|---|---|
| XML-RPC can be disabled | KB: Fail2Ban | Disable XML-RPC | Benchmark: XML-RPC | Already covered |
| Nginx hardening: block wp-content PHP | KB: Nginx Hardening | Disable plugin/theme PHP | Benchmark: File security | Already covered |
| Nginx hardening: block comments/trackbacks | KB: Nginx Hardening | Disable feedback | Benchmark: Spam control | Could add |
| CSP via GP-CLI | KB: CSP Header | Content Security Policy | Benchmark: CSP | Already covered |
| HTTP Auth available | KB: HTTP Auth | Basic auth on login | Benchmark: Authentication | Already covered |
| Site suspension capability | KB: Security Tab | Emergency disable | Runbook: Incident response | Could add |

## Malware/Scanning Claims

| GridPane claim | Exact source | Transferable pattern | Canonical target(s) | Current editorial status |
|---|---|---|---|---|
| Maldet and ClamAV available | KB: Malware | Server malware scanning | Runbook: Malware response | Could add |
| BitNinja available | KB: BitNinja | Comprehensive server security | Hardening Guide: Tools | Could add reference |
| Bad bot blocking tools | KB: Bad Bots | Bot management | Benchmark: Automated threats | Could add |

## Fortress Claims

| GridPane claim | Exact source | Transferable pattern | Canonical target(s) | Current editorial status |
|---|---|---|---|---|
| "Only security plugin recommended" | Fortress page | Vendor recommendation | — | Internal context |
| 2FA, Argon2, login/session protection | Fortress page | App-layer security | Benchmark: Authentication | Already covered (Argon2id) |
| Vaults, Pillars, Code Freeze | Fortress page | Proprietary features | — | Vendor-specific |
| Lazy loading, no frontend assets | Fortress page | Performance-conscious | — | Internal context |
| 1200+ automated tests | Fortress page | QA maturity | — | Unverified claim |
| GridPane-specific pricing | Fortress page | Commercial terms | — | Not canonical |

## Layered Security Philosophy

| GridPane claim | Exact source | Transferable pattern | Canonical target(s) | Current editorial status |
|---|---|---|---|---|
| Server-edge first, then plugin | Fortress + KB | Layered security model | Hardening Guide: Architecture | Already covered |
| Most plugins unnecessary with server stack | KB: Do I need security plugin? | Server-first philosophy | Hardening Guide: Strategy | Could frame as editorial |

## Crosswalk Rules

- Point implementation work at the canonical source repos, never at `wp-security-doc-review/rounds/...`.
- Separate verified vendor claims from editorial implications.
- Keep proprietary product terms labeled as such.
- Record "no change recommended" when the canonical docs already cover the transferable concept.
- Mark claims needing verification (e.g., "7G Developer+ only")

## Priority Editorial Actions

1. **Add server-level rate limiting** to Benchmark as L1 control (1 req/sec on wp-login.php)
2. **Verify 7G availability** tier — is it really Developer+ only?
3. **Add /tmp noexec** reference to Benchmark server hardening section
4. **Consider "server-first" framing** in Hardening Guide introduction
