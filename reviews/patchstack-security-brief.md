# Patchstack Security Research Brief

Date: 2026-03-14 (updated)
Audience: Internal WordPress security editors and reviewers
Status: Internal research artifact; not canonical product guidance
Research scope: Patchstack documentation, articles (37+ pages), and whitepapers

## Scope

This brief summarizes what Patchstack publicly says about its WordPress security model and maps those claims to editorial implications for the canonical WordPress security docs. This is an expanded version that includes deeper review of Patchstack's articles section.

Canonical source docs for any approved follow-up work:

- `../wp-security-benchmark/WordPress-Security-Benchmark.md`
- `../wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md`
- `../wordpress-runbook-template/WP-Operations-Runbook.md`
- `../wp-security-style-guide/WP-Security-Style-Guide.md`

## Verified Vendor Claims

### Core Product: Virtual Patching

1. **Virtual Patching Definition**: Security policy enforcement layer that prevents exploitation of known vulnerabilities without modifying the vulnerable code. Source: https://patchstack.com/articles/virtual-patching/

2. **Endpoint WAF vs Cloud WAF**: Patchstack is an endpoint WAF installed inside the application, more aware of environment than cloud firewalls. Source: https://patchstack.com/articles/virtual-patching/

3. **vPatch System**: Auto-mitigation through crowdsourced security research and AI/ML-based source code analysis. Source: https://patchstack.com/articles/virtual-patching/

4. **Zero-Day Protection**: Protected sites receive protection even for 0days not yet publicly known while Patchstack triages non-disclosed vulnerabilities. Source: https://patchstack.com/articles/virtual-patching/

5. **Automatic Deployment**: Virtual patches are deployed automatically to protected sites. Source: https://patchstack.com/articles/virtual-patching/

### Hosting Security Study (January 2026)

6. **Hosting Defense Ineffectiveness**: Patchstack conducted a study testing 30 vulnerabilities against hosting companies. **74% of attacks succeeded** — hosts blocked only 26% of exploits. Source: https://patchstack.com/articles/myth-of-secure-hosting-only-26-percent-of-vulnerability-exploits-blocked-by-hosts/

7. **Privilege Escalation Worst**: Of high-impact vulnerabilities, privilege escalation attacks were blocked only **12% of the time**. Source: https://patchstack.com/articles/myth-of-secure-hosting-only-26-percent-of-vulnerability-exploits-blocked-by-hosts/

8. **Generic Attacks Better Blocked**: Hosts performed better against non-WordPress-specific vulnerabilities (SQL injection, directory traversal). Arbitrary file uploads blocked 60% of the time. Source: https://patchstack.com/articles/myth-of-secure-hosting-only-26-percent-of-vulnerability-exploits-blocked-by-hosts/

9. **WAF Inconsistency**: Same commercial WAF products showed wildly varying efficacy between hosts. Hosts likely limit WAF capabilities to reduce false positives. Source: https://patchstack.com/articles/myth-of-secure-hosting-only-26-percent-of-vulnerability-exploits-blocked-by-hosts/

10. **In-House Firewalls Better**: Hosts with custom in-house firewall solutions performed better than those relying solely on commercial WAFs. Source: https://patchstack.com/articles/myth-of-secure-hosting-only-26-percent-of-vulnerability-exploits-blocked-by-hosts/

11. **CSRF Unblockable**: CSRF attacks cannot be reasonably blocked by hosts — requires specific targeting and social engineering. Source: https://patchstack.com/articles/myth-of-secure-hosting-only-26-percent-of-vulnerability-exploits-blocked-by-hosts/

12. **Time-to-Exploit Negative**: Google reported time-to-exploit hit negative values in 2024 — attacks happening faster than official updates roll out. Source: https://patchstack.com/articles/myth-of-secure-hosting-only-26-percent-of-vulnerability-exploits-blocked-by-hosts/

### Vulnerability Statistics

13. **2024 Vulnerability Numbers**: 7,966 new vulnerabilities found in WordPress ecosystem (34% increase from 2023). Source: https://patchstack.com/whitepaper/state-of-wordpress-security-in-2025/

14. **Plugin Dominance**: 99%+ of vulnerabilities originate from plugins and themes, not core. Source: https://patchstack.com/articles/virtual-patching/

15. **Unpatched Vulnerabilities**: 33% of vulnerabilities in 2024 received no fix from developers. Source: https://patchstack.com/wordpress-security/

### Platform Claims

16. **Managed WordPress Integration**: Patchstack is trusted by Pagely, Cloudways, GridPane, Plesk, GoDaddy, Hostinger. Source: https://docs.patchstack.com/

17. **Community Version**: Free version includes 48-hour early warning for vulnerabilities. Source: https://wordpress.org/plugins/patchstack/

18. **Enterprise Features**: Vulnerability detection, real-time protection, software management. Source: https://patchstack.com/pricing/

### Technology

19. **Endpoint Firewall**: Installed inside application, aware of components and environment settings, adapts firewall efficiently. Source: https://patchstack.com/articles/virtual-patching/

20. **Crowdsourced Research**: Powered by community of ethical hackers. Source: https://wordpress.org/plugins/patchstack/

21. **Vulnerability Database**: Maintains public vulnerability database with 7,966+ entries. Source: https://patchstack.com/database/

### Compliance

22. **PCI-DSS Compliance**: Helps comply with vulnerability management directives. Source: https://patchstack.com/woocommerce-security

23. **EU Cyber Resilience Act (CRA)**: CRA requirements apply from 2026; plugin/theme authors must notify about exploited/severe vulnerabilities. Source: https://patchstack.com/whitepaper/state-of-wordpress-security-in-2025/

## Editorial Reading

1. **Hosting Security Claims Are Testable**: The 74% attack success rate is a testable claim with methodology published. Could be used as citation for "don't rely on hosting security alone."

2. **Privilege Escalation is the Gap**: 12% block rate for privilege escalation is a powerful statistic for emphasizing plugin vetting and application-layer security.

3. **WAF Limitations Well-Documented**: The inconsistency of commercial WAFs and the in-house firewall advantage are nuanced findings that could inform Benchmark recommendations.

4. **Time-to-Exploit Negative**: This is a significant finding — attacks now outpace patches. Supports virtual patching value proposition.

5. **Endpoint vs Cloud WAF Debate**: Patchstack's endpoint WAF claim is contested by cloud WAF vendors. The canonical docs should present both views neutrally.

## Current Fit Against The Canonical Docs

| Canonical Doc | Patchstack Overlap | Gap/Opportunity |
|---|---|---|
| **Benchmark** | Virtual patching, vulnerability scanning, hosting limitations | Add hosting security study data; emphasize plugin vetting |
| **Hardening Guide** | Plugin security, third-party risk, time-to-exploit | Add negative time-to-exploit finding; virtual patching option |
| **Runbook** | Vulnerability response | Could add virtual patching as incident response option |
| **Style Guide** | "virtual patching" term | Already present (verified) |

## Recommended Editorial Actions

1. **Cite hosting security study** in Benchmark — 74% attack success rate supports "defense in depth" philosophy; don't rely solely on hosting security

2. **Add privilege escalation statistic** — 12% block rate emphasizes need for plugin vetting

3. **Add time-to-exploit finding** — Negative time-to-exploit (2024) supports virtual patching value

4. **Present WAF tradeoffs neutrally** — Endpoint vs cloud is contested; present both perspectives

## Open Questions

- How does Patchstack's vPatch coverage compare to WAF rulesets from Wordfence/Sucuri?
- What is the performance impact of endpoint WAF vs. no WAF?
- How quickly are vPatches deployed after vulnerability disclosure?
- Is the "zero-day protection" claim verified, or marketing?
- Are the 30 vulnerabilities in the study independently verified?

## References

### Primary Sources

- https://patchstack.com/articles/virtual-patching/
- https://patchstack.com/articles/myth-of-secure-hosting-only-26-percent-of-vulnerability-exploits-blocked-by-hosts/
- https://patchstack.com/wordpress-security/
- https://patchstack.com/whitepaper/state-of-wordpress-security-in-2025/
- https://wordpress.org/plugins/patchstack/
- https://patchstack.com/pricing/
- https://patchstack.com/database/
- https://docs.patchstack.com/

### Key Statistics

- 74% of vulnerability exploits succeed against hosting companies
- 26% average block rate by hosts
- 12% block rate for privilege escalation attacks
- 60% block rate for arbitrary file uploads (best category)
- 7,966 vulnerabilities in WordPress ecosystem (2024)
- 34% increase from 2023
- 99%+ from plugins/themes
- 33% unpatched by developers
- Negative time-to-exploit (2024 — attacks faster than patches)
