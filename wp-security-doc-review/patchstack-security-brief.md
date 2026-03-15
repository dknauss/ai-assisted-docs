# Patchstack Security Research Brief

Date: 2026-03-14
Audience: Internal WordPress security editors and reviewers
Status: Internal research artifact; not canonical product guidance
Research scope: Patchstack documentation and marketing materials

## Scope

This brief summarizes what Patchstack publicly says about its WordPress security model and maps those claims to editorial implications for the canonical WordPress security docs.

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

### Vulnerability Statistics

6. **2024 Vulnerability Numbers**: 7,966 new vulnerabilities found in WordPress ecosystem (34% increase from 2023). Source: https://patchstack.com/whitepaper/state-of-wordpress-security-in-2025/

7. **Plugin Dominance**: 99%+ of vulnerabilities originate from plugins and themes, not core. Source: https://patchstack.com/articles/virtual-patching/

8. **Unpatched Vulnerabilities**: 33% of vulnerabilities in 2024 received no fix from developers. Source: https://patchstack.com/wordpress-security/

### Platform Claims

9. **Managed WordPress Integration**: Patchstack is trusted by Pagely, Cloudways, GridPane, Plesk. Source: https://wordpress.org/plugins/patchstack/

10. **Community Version**: Free version includes 48-hour early warning for vulnerabilities. Source: https://wordpress.org/plugins/patchstack/

11. **Enterprise Features**: Vulnerability detection, real-time protection, software management. Source: https://patchstack.com/pricing/

### Technology

12. **Endpoint Firewall**: Installed inside application, aware of components and environment settings, adapts firewall efficiently. Source: https://patchstack.com/articles/virtual-patching/

13. **Crowdsourced Research**: Powered by community of ethical hackers. Source: https://wordpress.org/plugins/patchstack/

14. **Vulnerability Database**: Maintains public vulnerability database. Source: https://patchstack.com/database/

### Compliance

15. **PCI-DSS Compliance**: Helps comply with vulnerability management directives. Source: https://patchstack.com/woocommerce-security

16. **EU Cyber Resilience Act (CRA)**: CRA requirements apply from 2026; plugin/theme authors must notify about exploited/severe vulnerabilities. Source: https://patchstack.com/whitepaper/state-of-wordpress-security-in-2025/

## Editorial Reading

1. **Virtual Patching is the Core Differentiator**: Unlike traditional WAFs that block by pattern matching, Patchstack provides specific rules for each vulnerability. This is a transferable concept — "virtual patching" should be in the canonical glossary.

2. **Endpoint vs Cloud WAF Tradeoff**: Patchstack argues endpoint WAFs are more effective than cloud WAFs because they're application-aware and can't be bypassed via IP. This is a nuanced claim — other vendors disagree.

3. **Zero-Day Protection Claim**: Virtual patches can protect against unknown vulnerabilities (0days). This is a strong claim that requires careful verification — the mechanism is blocking exploitation patterns, not the vulnerabilities themselves.

4. **Third-Party Risk**: 99%+ of WordPress vulnerabilities come from plugins/themes. This reinforces the importance of plugin vetting and automated vulnerability scanning.

5. **Unpatched Vulnerabilities**: 33% of vulnerabilities have no fix. Virtual patching addresses this gap — you don't need a code fix to be protected.

6. **GDPR-like "CRA Moment"**: Patchstack compares EU Cyber Resilience Act to GDPR for open-source software. This is a significant regulatory development that could affect WordPress ecosystem.

## Current Fit Against The Canonical Docs

| Canonical Doc | Patchstack Overlap | Gap/Opportunity |
|---|---|---|
| **Benchmark** | Virtual patching, vulnerability scanning | Add virtual patching as defense-in-depth; add vulnerability scanning |
| **Hardening Guide** | Plugin security, third-party risk | Emphasize plugin vetting; reference virtual patching as option |
| **Runbook** | Vulnerability response | Could add virtual patching as incident response option |
| **Style Guide** | "virtual patching" term | Add to glossary |

## Recommended Editorial Actions

1. **Add "virtual patching" to glossary** — It's a key term that appears in 2+ documents (Benchmark, Hardening Guide when discussing Patchstack)
2. **Add vulnerability scanning** as a recommended practice in Benchmark
3. **Add virtual patching** as a defense-in-depth option in Hardening Guide
4. **Reference Patchstack statistics** for plugin vulnerability prevalence (use as citation, not endorsement)

## Open Questions

- How does Patchstack's vPatch coverage compare to WAF rulesets from Wordfence/Sucuri?
- What is the performance impact of endpoint WAF vs. no WAF?
- How quickly are vPatches deployed after vulnerability disclosure?
- Is the "zero-day protection" claim verified, or marketing?

## References

### Primary Sources

- https://patchstack.com/articles/virtual-patching/
- https://patchstack.com/wordpress-security/
- https://patchstack.com/whitepaper/state-of-wordpress-security-in-2025/
- https://wordpress.org/plugins/patchstack/
- https://patchstack.com/pricing/
- https://patchstack.com/database/

### Key Statistics

- 7,966 vulnerabilities in WordPress ecosystem (2024)
- 34% increase from 2023
- 99%+ from plugins/themes
- 33% unpatched by developers
