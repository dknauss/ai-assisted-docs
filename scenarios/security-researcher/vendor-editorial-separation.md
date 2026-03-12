# Vendor vs. Editorial Separation

Skill: security-researcher
Agent(s): @SecurityResearcher

Research briefs must maintain a clear boundary between what a vendor says and what the canonical WordPress docs should do about it. Mixing the two produces vendor-influenced documentation.

## Vendor claims and editorial implications are in separate sections

**Given** a completed research brief
**When** the brief discusses both vendor product behavior and potential documentation changes
**Then** "Verified vendor claims" and "Transferable editorial implications" must be in separate, clearly labeled sections — never interleaved

### Examples

Pass:
```
## Verified Vendor Claims
- Cloudflare APO caches WordPress HTML at the edge using a WordPress plugin
  that purges on content changes. (Source: https://...)

## Transferable Editorial Implications
- The Hardening Guide's caching section could note that edge-caching services
  may require a companion plugin for cache invalidation. This is not
  Cloudflare-specific — it applies to any edge cache with WordPress integration.
```

Fail:
```
## Analysis
- Cloudflare APO caches WordPress HTML at the edge. Our Hardening Guide should
  recommend Cloudflare APO for sites needing edge caching.
```
Mixes vendor feature description with editorial recommendation. The brief should not recommend a specific vendor product.

## Proprietary terminology is marked

**Given** a research brief uses a term that is specific to one vendor's product
**When** the term could be confused with a generic WordPress or industry concept
**Then** the term must be marked as vendor-specific on first use

### Examples

Pass:
```
GridPane's "SafeUpdates" (vendor-specific feature) performs automated plugin
updates with rollback capability.
```

Fail:
```
GridPane's SafeUpdates performs automated plugin updates with rollback capability.
```
A reader might assume "SafeUpdates" is a WordPress core feature or a widely used term.

## No marketing language

**Given** a research brief about a vendor product
**When** the vendor's own materials use promotional language
**Then** the brief must restate the claim in neutral, technical language

### Examples

Pass:
```
GridPane provides server-level security measures including a WAF, login
rate limiting, and file integrity monitoring.
```

Fail:
```
GridPane offers enterprise-grade, military-strength security that protects
your WordPress sites from all known threats.
```
Marketing language. Restate in terms of what the product concretely does.
