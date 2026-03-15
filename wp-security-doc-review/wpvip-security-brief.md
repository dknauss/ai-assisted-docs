# WordPress VIP Security Research Brief

Date: 2026-03-14
Audience: Internal WordPress security editors and reviewers
Status: Internal research artifact; not canonical product guidance
Research scope: WordPress VIP documentation (docs.wpvip.com)

## Scope

This brief summarizes what WordPress VIP publicly says about its security model and maps those claims to editorial implications for the canonical WordPress security docs.

Canonical source docs for any approved follow-up work:

- `../wp-security-benchmark/WordPress-Security-Benchmark.md`
- `../wp-security-hardening-guide/WordPress-Security-Hardening-Guide.md`
- `../wordpress-runbook-template/WP-Operations-Runbook.md`
- `../wp-security-style-guide/WP-Security-Style-Guide.md`

## Verified Vendor Claims

### Infrastructure Security

1. **Security Monitoring**: Traffic pattern anomaly detection, spike monitoring, brute-force protection built in at network level with dynamic restriction application. Source: https://docs.wpvip.com/security/infrastructure-that-mitigates-security-threats/

2. **Data Center Security**: End-to-end encryption from edge to origin, resource/data isolation, encrypted off-site backups. ISO 27001, SSAE 18 SOC2 Type 2 certified. Source: https://docs.wpvip.com/security/infrastructure-that-mitigates-security-threats/

3. **Database Protection**: Containerized databases with unique authentication per application. Production backups hourly for 30 days, encrypted. Source: https://docs.wpvip.com/security/infrastructure-that-mitigates-security-threats/

4. **Firewalls**: Network and host-based firewalls with real-time notification processes. Source: https://docs.wpvip.com/security/infrastructure-that-mitigates-security-threats/

5. **Security Patch Management**: VIP team deploys security patches for WordPress, PHP, Node.js. Source: https://docs.wpvip.com/security/infrastructure-that-mitigates-security-threats/

6. **Whole-Site HTTPS**: Enforced for all sites. Let's Encrypt certificates default; custom TLS available. Source: https://docs.wpvip.com/security/infrastructure-that-mitigates-security-threats/

### Reduced Attack Surface

7. **Read-Only Web Containers**: All web containers run in read-only mode. Disallows plugins/themes from writing. Protects against backdoor shells and malicious file installation. Source: https://docs.wpvip.com/security/infrastructure-that-mitigates-security-threats/

8. **Git-Based Deployment**: Code can only be modified by GitHub users with write access. Customer governs user access. Source: https://docs.wpvip.com/security/infrastructure-that-mitigates-security-threats/

9. **Media File Isolation**: Media stored in separate object store (VIP File System). Files in /wp-content/uploads cannot be executed. Source: https://docs.wpvip.com/security/infrastructure-that-mitigates-security-threats/

### WordPress-Specific Security

10. **Dynamic Login Protection**: Network-level protections for /wp-login.php and /xmlrpc.php. Automated attacks trigger complete blocking. Source: https://docs.wpvip.com/security/infrastructure-that-mitigates-security-threats/

11. **WP Cron Disabled**: Functionality disabled for all sites. Cron control via Automattic's Cron Control plugin. Source: https://docs.wpvip.com/security/infrastructure-that-mitigates-security-threats/

12. **Automatic Security Deployments**: Security releases for WordPress Core and VIP MU plugins auto-deployed. Source: https://docs.wpvip.com/security/infrastructure-that-mitigates-security-threats/

### WordPress Security Controls (Dashboard)

13. **Security Status Panel**: VIP Dashboard shows security status (Excellent/Good/Baseline/Vulnerable) with recommendations. Source: https://docs.wpvip.com/security-controls/wordpress/

14. **Enforce 2FA**: Configure specific user roles to require two-factor authentication. Default: Enforced for Editor, Administrator, Super Admin. Source: https://docs.wpvip.com/security-controls/wordpress/enforce-2fa/

15. **Inactive Users**: Flag or block users inactive beyond configurable days. Applied to all or specific roles. Source: https://docs.wpvip.com/security-controls/wordpress/inactive-users/

16. **Session Time**: Set days before re-authentication required. Source: https://docs.wpvip.com/security-controls/wordpress/session-time/

17. **XML-RPC Control**: Limit access to application passwords only, or disable entirely. Jetpack functionality preserved. Source: https://docs.wpvip.com/security-controls/wordpress/xml-rpc/

18. **Plugin Vulnerability Scanning**: Codebase Manager scans plugins, reports vulnerabilities in VIP Dashboard. Auto-generated PRs for updates. Source: https://docs.wpvip.com/security-controls/wordpress/

19. **VIP Code Analysis Bot**: Analyzes GitHub PRs for vulnerabilities, PHPCS, PHP linting, SVG analysis. Source: https://docs.wpvip.com/vip-code-analysis-bot/

### Shared Responsibility Model

20. **Customer Responsibilities**: User management, code quality, third-party dependency management, access governance. Source: https://docs.wpvip.com/security/customer-responsibility/

21. **Data Handling**: VIP discourages sensitive data (SSN, medical, credit card). Payment via PCI-compliant processor. VIP is data processor, customer is controller. Source: https://docs.wpvip.com/security/customer-responsibility/

22. **Access Control Principle**: Follow least privilege, periodic access reviews, remove inactive users. Source: https://docs.wpvip.com/security/customer-responsibility/

23. **Code Review**: Internal reviews required before merge. Extra scrutiny for permission-altering code. Source: https://docs.wpvip.com/security/customer-responsibility/

24. **Software Currency**: Only security-update-eligible PHP/Node.js versions available. Source: https://docs.wpvip.com/security/customer-responsibility/

25. **Audit Logging**: Customer-accessible audit log in VIP Dashboard for all team member actions. WP-CLI command logging available. Source: https://docs.wpvip.com/security/customer-responsibility/

### Compliance

26. **FedRAMP ATO**: FedRAMP Authority to Operate. Source: https://docs.wpvip.com/security/infrastructure-that-mitigates-security-threats/

27. **Data Privacy Framework**: EU-US Data Privacy Framework participant. Source: https://docs.wpvip.com/security/infrastructure-that-mitigates-security-threats/

### Additional Security Features

28. **Rate Limiting**: Configurable per-application rate limits. Source: https://docs.wpvip.com/security/rate-limiting/

29. **IP Restrictions**: Allow/block IP addresses. Source: https://docs.wpvip.com/security-controls/ip-restrictions/

30. **User Agent Restrictions**: Block by user agent. Source: https://docs.wpvip.com/security-controls/user-agent-restrictions/

31. **Basic Authentication**: HTTP Basic Auth available. Source: https://docs.wpvip.com/security-controls/basic-authentication/

32. **Defensive Mode**: Enable heightened security restrictions. Source: https://docs.wpvip.com/security-controls/defensive-mode/

33. **Access-Controlled Files**: Restrict file access. Source: https://docs.wpvip.com/security-controls/access-controlled-files/

34. **SSO**: Single Sign-On available. Source: https://docs.wpvip.com/security-controls/wordpress/sso/

## Editorial Reading

1. **Read-Only Containers**: The most distinctive security feature. Similar to concept of non-writable filesystem. This is a transferable pattern — "read-only web root" could be mentioned in Benchmark as defense-in-depth.

2. **Shared Responsibility**: VIP explicitly defines customer vs. platform responsibilities. This aligns with the Style Guide's principle of "shared responsibility" but is more explicit. Could inform how the Hardening Guide frames responsibility.

3. **2FA Enforcement**: Default enforced for elevated roles is notable. Could inform Benchmark authentication recommendations.

4. **Automatic Security Patches**: VIP auto-deploys security patches for Core and MU plugins. Not transferable to self-hosted, but valuable context for upgrade timing recommendations.

5. **Git-Based Deployment Required**: No FTP/SFTP uploads. Code enters via Git only. This eliminates a common attack vector (malware upload via plugin install). Could inform Benchmark's "disable file mods" discussion.

6. **VIP Code Analysis Bot**: Pre-deployment scanning. Similar to pre-commit hooks. Self-hosted could use PHPCS + VIP GitHub Actions as proxy.

7. **Compliance Certifications**: FedRAMP, SOC2, ISO 27001. These are enterprise requirements — valuable context for Benchmark compliance section.

## Current Fit Against The Canonical Docs

| Canonical Doc | VIP Overlap | Gap/Opportunity |
|---|---|---|
| **Benchmark** | Read-only containers, 2FA enforcement, Git-based deployment, compliance | Could add read-only filesystem as L2 control; add SOC2/FedRAMP to compliance refs |
| **Hardening Guide** | Shared responsibility model, automatic security patches, least privilege | Could adopt VIP's "shared responsibility" framing more explicitly |
| **Runbook** | Audit logging, automatic security patches | Could reference VIP audit log patterns |
| **Style Guide** | Shared responsibility terminology | Already aligned |

## Recommended Editorial Actions

1. **Add read-only web container** to Benchmark as defense-in-depth option (L2)
2. **Reference SOC2/FedRAMP** in Benchmark compliance section
3. **Adopt "shared responsibility" framing** in Hardening Guide (explicitly define platform vs. customer responsibilities)
4. **Consider Git-based deployment** in Benchmark deployment section (no direct file write access)
5. **Update authentication** section with 2FA enforcement patterns

## Open Questions

- What is the exact implementation of "read-only containers"? Is it filesystem-level or container orchestration?
- Does VIP support custom plugins not in the WordPress.org repository?
- What is the SLA for security patch deployment?
- Is there a cost tier for 2FA enforcement or is it platform-wide?

## References

### Primary Sources

- https://docs.wpvip.com/security/infrastructure-that-mitigates-security-threats/
- https://docs.wpvip.com/security-controls/wordpress/
- https://docs.wpvip.com/security/customer-responsibility/
- https://docs.wpvip.com/security/rate-limiting/
- https://docs.wpvip.com/security-controls/ip-restrictions/
- https://docs.wpvip.com/security-controls/defensive-mode/
- https://docs.wpvip.com/vip-code-analysis-bot/

### Secondary Sources

- https://wpvip.com/blog/wordpress-website-security-multilayer-approach
- https://lobby.vip.wordpress.com/2025/08/20/wordpress-security-controls-now-available/
