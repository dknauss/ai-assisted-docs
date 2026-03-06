GridPane Security Briefing Card

- Internal use only: this repo stores research and review artifacts, not the canonical WordPress security docs.
- GridPane says most plugin-based security tooling is unnecessary if its WAF and Fail2Ban stack is already in place, with Fortress as the named exception. Source: https://gridpane.com/kb/do-i-need-a-security-plugin-when-using-gridpanes-security-features/
- GridPane positions Fortress as its only officially recommended security plugin and frames it as application-layer protection with server-level integration. Source: https://gridpane.com/fortress/
- Fortress-specific terms such as `Vaults`, `Pillars`, and `Code Freeze` are proprietary product language. Keep them vendor-specific unless the editor explicitly wants a case study. Source: https://gridpane.com/fortress/
- The canonical docs already cover overlapping non-vendor concepts such as `Argon2id`, `WAF`, `Fail2Ban`, and `mu-plugin`; follow-up work should target the source repos, not archived `phase1-*` review files.
- Use the crosswalk and gap analysis before proposing revisions: `gridpane-crosswalk.md`, `gridpane-gap-analysis.md`, and `gridpane-crosswalk-template.md`.
