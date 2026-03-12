# Source Grounding

Skill: security-researcher
Agent(s): @SecurityResearcher

Every substantive vendor-specific claim in a research brief must cite an exact public URL. Claims without sources are not acceptable, even when the claim is likely correct.

## Every vendor claim has an exact URL

**Given** a research brief about a vendor's WordPress security product
**When** the brief contains a factual statement about the vendor's product (feature, behavior, configuration, limitation)
**Then** the statement must include an exact public URL pointing to the vendor's own documentation, knowledge base, or product page where the claim can be verified

### Examples

Pass:
```
GridPane uses server-level WAF rules managed through its control panel.
(Source: https://gridpane.com/kb/web-application-firewall/)
```

Fail:
```
GridPane uses server-level WAF rules managed through its control panel.
```
Missing citation. Even obvious vendor features need a URL so the editor can verify.

## No unsourced statistics

**Given** a research brief
**When** the brief cites a number (install count, market share, version number, performance metric)
**Then** the number must cite the authoritative source and note the query date

### Examples

Pass:
```
Wordfence reports 5+ million active installations (WordPress.org plugin API, queried 2026-03-11).
```

Fail:
```
Wordfence is the most popular WordPress security plugin with millions of installs.
```
Vague. "Millions" is not a verifiable number. Cite the API response with a date.

## Unverifiable claims are marked explicitly

**Given** a vendor makes a claim that cannot be verified from public sources
**When** the researcher encounters it
**Then** the claim must appear in the "Open questions or items needing independent verification" section, not in the "Verified vendor claims" section

### Examples

Pass:
```
## Open Questions
- GridPane claims their stack "blocks 99.9% of brute force attacks." No public methodology or data supports this figure. Needs independent verification.
```

Fail:
```
## Verified Vendor Claims
- GridPane blocks 99.9% of brute force attacks.
```
A marketing claim without published methodology is not a verified claim.
