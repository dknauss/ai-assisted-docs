# Verification with Veloria

Skill: security-researcher
Agent(s): @SecurityResearcher

When a vendor claims their product uses specific WordPress hooks, functions, or APIs, the claim must be cross-referenced against actual source code using Veloria (or equivalent code search) rather than relying on vendor documentation alone.

## Vendor hook/function claims are verified against source

**Given** a vendor claims their plugin hooks into a specific WordPress action or filter
**When** the claim is about a concrete code-level interaction (hook name, function call, class name)
**Then** the researcher must verify the claim against the plugin's actual source on WordPress.org using Veloria or direct SVN/GitHub inspection

### Examples

Pass:
```
## Verified Vendor Claims
- Wordfence hooks into `authenticate` filter for login protection.
  Verified: `wordfence/vendor/wordfence/wf-waf/src/lib/waf.php` contains
  `add_filter('authenticate', ...)` (Veloria search, 2026-03-11).
```

Fail:
```
## Verified Vendor Claims
- Wordfence hooks into the `authenticate` filter for login protection.
  (Source: https://www.wordfence.com/help/firewall/)
```
Vendor documentation is not source verification. The vendor might describe behavior that no longer matches their code, or might describe it inaccurately.

## Discrepancies between vendor docs and source are flagged

**Given** a vendor's documentation claims one behavior
**When** the actual plugin source code shows different behavior
**Then** the discrepancy must be flagged in "Open questions" with both the vendor claim and the source finding

### Examples

Pass:
```
## Open Questions
- Vendor docs claim the plugin uses `wp_authenticate_user` filter, but Veloria
  search shows it hooks `authenticate` (priority 99). The vendor documentation
  may be outdated or referring to a different product version. Needs
  clarification before referencing in canonical docs.
```
