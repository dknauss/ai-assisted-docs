# GridPane Security Research Brief

Date: 2026-03-14
Audience: Internal WordPress security editors and reviewers
Status: Internal research artifact; not canonical product guidance
Research scope: Comprehensive security KB review (32 articles)

## Scope

This brief summarizes what GridPane publicly says about its WordPress security model across the full security knowledge base. This is an expanded version of the initial March 6 brief which only covered 2 URLs. This version includes all security-related KB articles.

Canonical source docs for any approved follow-up work:

- `../wp-security-benchmark/WordPress-Security-Benchmark.md`
- `../wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md`
- `../wordpress-runbook-template/WP-Operations-Runbook.md`
- `../wp-security-style-guide/WP-Security-Style-Guide.md`

## Verified Vendor Claims

### Server-Level Security Defaults

1. **SSH Lockdown**: Root user is locked down to secure SSH access only. Source: https://gridpane.com/kb/default-gridpane-security-and-additional-options/
2. **Linux UFW**: Uncomplicated Firewall configured out of the box during server provisioning. Source: https://gridpane.com/kb/default-gridpane-security-and-additional-options/
3. **Fail2Ban (server-level)**: Enabled on all GridPane servers by default, protecting SSH port. Source: https://gridpane.com/kb/default-gridpane-security-and-additional-options/
4. **System User Isolation**: New system users created via the platform are completely isolated and secure from one another. Source: https://gridpane.com/kb/default-gridpane-security-and-additional-options/
5. **Auth and Fail2Ban Logs**: Logs configured for authentication events and Fail2Ban activity. Source: https://gridpane.com/kb/default-gridpane-security-and-additional-options/
6. **Security Updates**: GridPane handles all server security updates and patches. Source: https://gridpane.com/kb/server-updates-what-does-gridpane-take-care-of/
7. **/tmp Lockdown**: Ubuntu 22.04+ mounts /tmp as noexec to prevent execution of uploaded binaries. Source: https://gridpane.com/kb/default-gridpane-security-and-additional-options/

### WordPress-Level Security Defaults

8. **Secure PHP Version**: New sites provisioned on up-to-date PHP by default. Source: https://gridpane.com/kb/default-gridpane-security-and-additional-options/
9. **Secure Usernames/Passwords**: Default credentials use secure defaults. Source: https://gridpane.com/kb/default-gridpane-security-and-additional-options/
10. **Latest WordPress**: New sites get latest WordPress version installed. Source: https://gridpane.com/kb/default-gridpane-security-and-additional-options/
11. **Directory Browsing Disabled**: Prevents viewing of WordPress files and blocks access to readme.html, readme.txt, install.php, wp-includes. Source: https://gridpane.com/kb/default-gridpane-security-and-additional-options/
12. **PHP Execution Blocked**: Disables PHP execution in uploads and themes directories. Source: https://gridpane.com/kb/default-gridpane-security-and-additional-options/
13. **wp-config.php Protection**: Stored one level up from htdocs (outside web root). Source: https://gridpane.com/kb/default-gridpane-security-and-additional-options/
14. **Security Headers**: Implemented by default to prevent XSS, clickjacking. Source: https://gridpane.com/kb/default-gridpane-security-and-additional-options/
15. **SFTP/SSH Only**: No FTP access; secure connections enforced. Source: https://gridpane.com/kb/default-gridpane-security-and-additional-options/
16. **Rate Limiting**: Server-level rate limiting on wp-login.php (1 hit/second) and admin-ajax endpoint. Source: https://gridpane.com/kb/default-gridpane-security-and-additional-options/

### Web Application Firewalls (WAF)

17. **6G WAF**: Lightweight, popular option. Protects against malicious URI requests, bad bots, spam referrers. Originally developed by Jeff Starr (Perishable Press) for Apache, adapted for Nginx. Source: https://gridpane.com/kb/secure-your-wordpress-websites-an-overview-of-the-security-tab/
18. **7G WAF**: Successor to 6G, lighter and more secure. Supports granular per-site and per-rule control, whitelisting, logging. Builds on predecessors. Source: https://gridpane.com/kb/using-the-7g-web-application-firewall/
19. **ModSecurity WAF**: Available on Developer+ plans. Uses OWASP Core Ruleset (CRS). Protects against SQLi, XSS, LFI, RFI, code injection, HTTPoxy, Shellshock, session fixation, bot detection. More resource-intensive but more effective for enterprise. Source: https://gridpane.com/kb/secure-your-wordpress-websites-an-overview-of-the-security-tab/

### Fail2Ban Integration

20. **Server-Level Fail2Ban**: Configurable via GP-CLI for wp-login.php and xmlrpc.php brute force protection. Customizable retry limits and ban durations. Source: https://gridpane.com/kb/configuring-fail2ban-to-prevent-brute-force-attacks/
21. **WP Fail2Ban Plugin Integration**: Auto-configuring integration with WP Fail2Ban plugin. Installed as mu-plugin. Features: user enumeration blocking, stupid username blocking, comment/pingback/spam logging, password reset protection. Source: https://gridpane.com/kb/configuring-fail2ban-to-prevent-brute-force-attacks/
22. **Cloudflare Integration**: Real IP configuration for Cloudflare, Stackpath, and Sucuri so Fail2Ban works correctly with CDNs. Source: https://gridpane.com/kb/configuring-fail2ban-to-prevent-brute-force-attacks/

### Additional Hardening Options

23. **XML-RPC Disable**: Can be disabled via GP-CLI if not needed. Source: https://gridpane.com/kb/configuring-fail2ban-to-prevent-brute-force-attacks/
24. **Nginx Hardening**: GP-CLI commands for blocking PHP in wp-content, blocking comments, trackbacks, wp-admin upgrade/install files. Source: https://gridpane.com/kb/nginx-site-hardening-with-gp-cli/
25. **Content Security Policy (CSP)**: GP-CLI command to create CSP configuration file. Source: https://gridpane.com/kb/how-to-create-a-content-security-policy-csp-header/
26. **HTTP Authentication**: Available for wp-login.php protection. Source: https://gridpane.com/kb/add-http-authentication-to-wp-login-php/
27. **Site Suspension**: Can suspend/disable websites via dashboard. Source: https://gridpane.com/kb/secure-your-wordpress-websites-an-overview-of-the-security-tab/

### Fortress Plugin (Application-Layer)

28. **Fortress Positioning**: GridPane's only officially recommended security plugin. Covers controls that can only be handled at the plugin level with server-level integration. Source: https://gridpane.com/fortress/
29. **Fortress Features**: Two-factor authentication, Argon2-based password hashing, login protection, session protection, Vaults and Pillars (secret storage), Code Freeze. Source: https://gridpane.com/fortress/
30. **Performance Claims**: Lazy-loaded codebase, no frontend assets on non-Fortress pages, WP-CLI-first, 1200+ automated tests. Source: https://gridpane.com/fortress/
31. **Pricing/Commercial**: GridPane-specific pricing, client distribution terms, white-label options. Source: https://gridpane.com/fortress/

### Malware and Scanning

32. **Maldet and ClamAV**: Server-level malware scanning available. Source: https://gridpane.com/kb/an-introduction-to-maldet-and-clamav-malware-scanning/
33. **BitNinja**: Available for installation. Comprehensive server security suite. Source: https://gridpane.com/kb/bitninja-part-1/

### DoS/DDoS Mitigation

34. **DoS/DDoS Protection**: Guidance on mitigating denial of service attacks at server/WordPress level. Source: https://gridpane.com/kb/mitigating-dos-and-ddos-attacks-on-your-wordpress-websites/

### Bad Bot Blocking

35. **Bad Bot Blocking**: Tools and techniques for blocking resource-consuming bots. Source: https://gridpane.com/kb/how-to-block-bad-bots-from-your-sites-servers/

### Security Learning Path

36. **OWASP Top 10 Mapping**: GridPane maps its security options to OWASP Top 10 categories. Source: https://gridpane.com/kb/the-owasp-top-10-and-gridpane-wordpress-security-options/

## Editorial Reading

1. **Layered Security Model**: GridPane clearly distinguishes edge/CDN, server, and application layers. This is a transferable editorial pattern for the canonical docs.
2. **Proprietary Terms**: `Vaults`, `Pillars`, `Code Freeze`, Fortress-specific configurations remain vendor-specific.
3. **Server-Level First**: GridPane argues for server-level security (WAF, Fail2Ban) before plugin-level solutions. This aligns with defense-in-depth but could be framed as "server-first" philosophy.
4. **GP-CLI as Differentiator**: GridPane's CLI tool (`gp`) is central to their security management. This is platform-specific, not transferable.
5. **WAF Philosophy**: GridPane recommends 6G/7G for most sites, ModSecurity for enterprise. This tiered approach could inform Benchmark recommendations.
6. **Rate Limiting**: Server-level rate limiting on wp-login.php is a notable default. The canonical docs could reference this as a baseline.

## Current Fit Against The Canonical Docs

| Canonical Doc | GridPane Overlap | Gap/Opportunity |
|---|---|---|
| **Benchmark** | WAF controls, Fail2Ban, rate limiting, PHP execution restrictions | Could add server-level rate limiting as L1 control |
| **Hardening Guide** | Layered security (edge/server/app), Argon2id, WAF placement | Could reference server-first security philosophy |
| **Runbook** | Fail2Ban configuration, WAF management, GP-CLI commands | GP-CLI is GridPane-specific; focus on standard WP-CLI |
| **Style Guide** | Terminology for WAF, Fail2Ban, security headers | Already aligned |

## Recommended Editorial Actions

1. **Add server-level rate limiting reference** to Benchmark (L1) — GridPane defaults to 1 hit/second on wp-login.php
2. **Consider "server-first" framing** in Hardening Guide — GridPane's philosophy of server-level before plugin-level
3. **Verify Fail2Ban coverage** in Runbook — ensure WP-CLI alternatives exist for Fail2Ban configuration (not GP-CLI)
4. **Keep Fortress-specific terms vendor-specific** — no changes needed

## Open Questions

- Which Argon2 variant does Fortress use? ("Argon2-based" without specification)
- Does Code Freeze use DISALLOW_FILE_MODS, DISALLOW_FILE_EDIT, or custom?
- What PHP version floor does Fortress require?
- 1,200+ automated tests and 57 WordPress core vulnerabilities: independently verified?
- How does Fortress session protection interact with WordPress cookies?
- Is 7G available on all plans or Developer+ only? (7G mentioned as Developer+ in one article)

## References

### Primary Sources (KB Articles Reviewed)

- https://gridpane.com/kb/default-gridpane-security-and-additional-options/
- https://gridpane.com/kb/secure-your-wordpress-websites-an-overview-of-the-security-tab/
- https://gridpane.com/kb/using-the-7g-web-application-firewall/
- https://gridpane.com/kb/configuring-fail2ban-to-prevent-brute-force-attacks/
- https://gridpane.com/kb/nginx-site-hardening-with-gp-cli/
- https://gridpane.com/kb/how-to-create-a-content-security-policy-csp-header/
- https://gridpane.com/kb/add-http-authentication-to-wp-login-php/
- https://gridpane.com/kb/the-owasp-top-10-and-gridpane-wordpress-security-options/
- https://gridpane.com/kb/mitigating-dos-and-ddos-attacks-on-your-wordpress-websites/
- https://gridpane.com/kb/how-to-block-bad-bots-from-your-sites-servers/
- https://gridpane.com/kb/an-introduction-to-maldet-and-clamav-malware-scanning/
- https://gridpane.com/kb/bitninja-part-1/
- https://gridpane.com/kb/server-updates-what-does-gridpane-take-care-of/
- https://gridpane.com/fortress/

### Secondary Sources (Linked)

- https://perishablepress.com/6g/
- https://perishablepress.com/7g-firewall
- https://coreruleset.org/faq/
