# WordPress 7.0 Post-Release Editorial Research Brief — 2026-06-14

This brief initiates the post-release editorial research pass for the canonical WordPress security document set:

- `wp-security-benchmark`
- `wp-security-hardening-guide`
- `wordpress-runbook-template`
- `wp-security-style-guide`

It focuses on release-state drift after the public launch of WordPress `7.0`, confirmed PHP support changes, and preliminary backlog implications for the paused real-time collaboration feature.

## Confirmed Upstream Facts

### 1. WordPress 7.0 is now the current stable release.

- **Release:** WordPress `7.0 "Armstrong"`
- **Release date:** **May 20, 2026**
- **Source:** [WordPress 7.0 “Armstrong”](https://wordpress.org/news/2026/05/armstrong/)

### 2. WordPress 7.0 officially dropped support for PHP `7.2` and `7.3`.

- The Core dev note published on **January 9, 2026** states that WordPress `7.0` drops support for PHP `7.2` and `7.3` and raises the **minimum supported** version to **PHP `7.4.0`**.
- **Source:** [Dropping support for PHP 7.2 and 7.3](https://make.wordpress.org/core/2026/01/09/dropping-support-for-php-7-2-and-7-3/)

### 3. The project’s current recommended PHP target remains `8.3+`.

- The same Core dev note says the **minimum recommended** PHP version remains **`8.3`**.
- The current public requirements page shows **PHP: “Version 8.3 or greater”** and separately notes that WordPress still runs on **PHP `7.4+`**, but those legacy versions are EOL and may expose sites to security risk.
- **Sources:**
  - [Dropping support for PHP 7.2 and 7.3](https://make.wordpress.org/core/2026/01/09/dropping-support-for-php-7-2-and-7-3/)
  - [Requirements](https://wordpress.org/support/article/requirements/)

### 4. The Core handbook now reflects WordPress `7.0` support status directly.

- The current PHP compatibility table shows WordPress `7.0` as compatible with PHP `7.4` through `8.5`, with `7.3` and `7.2` no longer supported.
- **Source:** [PHP Compatibility and WordPress Versions](https://make.wordpress.org/core/handbook/references/php-compatibility-and-wordpress-versions/)

### 5. Real-time collaboration did **not** ship in WordPress `7.0`.

- Core’s June 2026 developer update says real-time collaboration **did not ship in WordPress 7.0**.
- A dedicated outreach effort is now underway for **WordPress `7.1`** testing in the Gutenberg plugin.
- **Sources:**
  - [What’s new for developers? (June 2026)](https://developer.wordpress.org/news/2026/06/whats-new-for-developers-june-2026/)
  - [Announcing a collaborative editing outreach effort for 7.1](https://make.wordpress.org/core/2026/06/03/announcing-a-collaborative-editing-outreach-effort-for-7-1/)

### 6. Core’s earlier 7.0 collaboration architecture work remains relevant as preliminary research, but not as release-state guidance.

- Core explicitly says real-time collaboration was **removed from the scope of WordPress 7.0 before RC3**.
- The design work still documents likely future operator concerns: HTTP polling load, optional custom sync providers, hosting impact, and plugin/metabox compatibility constraints.
- **Sources:**
  - [Building a custom sync provider for real-time collaboration](https://make.wordpress.org/core/2026/04/01/building-a-custom-sync-provider-for-real-time-collaboration/)
  - [Extending the 7.0 Cycle](https://make.wordpress.org/core/2026/03/31/extending-the-7-0-cycle/)

## Repo-by-Repo Findings

## `wp-security-benchmark`

### Canonical document update needed

**File:** `WordPress-Security-Benchmark.md`

Current wording still treats WordPress `7.0` as upcoming:

- `Current supported WordPress release (WordPress 6.9.1 as of March 21, 2026; WordPress 7.0 scheduled for April 9, 2026)`

**Recommended update:**

- Replace pre-release wording with post-release wording that treats `7.0` as the current stable branch.
- Avoid a fresh hard-coded minor point release unless it is actually needed for the sentence.
- Prefer evergreen framing such as “Current stable WordPress release (`7.0` as of May 20, 2026)” or similar.

### PHP guidance review

Current benchmark baseline is:

- `PHP 8.3+ (validate PHP 8.4 in staging before production rollout)`

**Assessment:** no immediate correction required.

This is a **prescriptive deployment baseline**, not a claim about the minimum version that can boot WordPress. It is consistent with the official recommendation to run PHP `8.3+` while WordPress `7.0` still supports PHP `7.4`.

### Collaboration backlog impact

No immediate benchmark control change is required because real-time collaboration did not ship in core `7.0`.

**Backlog candidate:**
- add a future environment-specific control or note covering editor-sync endpoint monitoring, caching bypass rules, and collaboration transport review **if/when** collaborative editing becomes a supported core feature.

## `wp-security-hardening-guide`

### Canonical document update needed: release-state framing

**File:** `WordPress-Security-Hardening-Guide.md`

Current release framing is stale in at least three places:

1. Overview says the document reflects `WordPress 6.9.1` and references `7.0` as scheduled for **April 9, 2026**.
2. The release-cycle section still uses `7.0 scheduled for April 9, 2026` as a current example.
3. Minor-release examples still point at `6.9.1`.

**Recommended update:**

- Convert all pre-release references to post-release wording.
- Use exact dates where needed to explain the transition clearly: WordPress `7.0` shipped on **May 20, 2026**, not April 9.
- Remove any unnecessary “scheduled for” language now that the release has landed.

### Canonical document update needed: PHP floor wording in cryptography section

**File:** `WordPress-Security-Hardening-Guide.md`

Current wording:

- `Sites with the necessary server support (PHP 7.3+ with the sodium or argon2 extension) can enable Argon2id ...`

**Why this now needs review:**

- WordPress `7.0` no longer supports PHP `7.3`.
- The sentence is technically historical, but it is awkward in a document framed around **current supported WordPress deployments**.

**Recommended update:**

- Reframe around supported WordPress `7.0` environments, e.g. `PHP 7.4+` as the support floor, while keeping the stronger editorial recommendation at `8.3+` for production.
- Preserve the important technical point that Argon2id availability depends on the PHP/runtime environment, not on WordPress alone.

### Canonical document update recommended: AI section should acknowledge shipped WordPress 7.0 surfaces

**File:** `WordPress-Security-Hardening-Guide.md`, Section 14

The guide already has a solid AI security section, but it is still generic. Since WordPress `7.0` shipped the new AI-facing surfaces called out in the release materials, Section 14 should likely be expanded to mention them explicitly:

- AI Client in core
- Abilities API / client-side abilities package
- connector-based external model integrations

**Why this matters:**

The release changes the editorial posture from “AI is emerging around WordPress” to “WordPress 7.0 now ships new AI-adjacent capability surfaces that operators must govern.”

**Recommended update:**

Add a brief subsection or paragraph clarifying that:

- WordPress `7.0` expands first-party AI integration surfaces.
- Authentication, authorization, provider governance, output sanitization, prompt handling, and secret storage now deserve more explicit WordPress-specific treatment, not just generic AI security guidance.

### Collaboration backlog impact

No immediate canonical content change is required to describe collaborative editing as a shipped WordPress `7.0` feature, because that would now be incorrect.

**Backlog candidate for Section 14 or a future architectural note:**
- add a forward-looking, clearly labeled note that real-time collaboration was removed from `7.0`, remains under active `7.1` outreach, and may later require security and hosting guidance around:
  - editor sync endpoint exposure
  - transport authentication and short-lived tokens
  - write-amplification / request-volume effects from polling
  - cache interaction and proxy behavior
  - metabox/plugin compatibility constraints
  - auditability of collaborative edit events and presence metadata

## `wordpress-runbook-template`

### Canonical template update needed: example WordPress version placeholder

**File:** `WP-Operations-Runbook.md`

Current placeholder:

- `[CUSTOMIZE: current stable release, e.g. WordPress 6.9.1]`

**Recommended update:**

- Update the example placeholder to WordPress `7.0`.
- Keep it as an example, not a normative lock.

### PHP guidance review

Current placeholder:

- `[CUSTOMIZE: 8.3+ recommended; test 8.4 in staging first]`

**Assessment:** no immediate correction required.

This remains aligned with official WordPress posture for production recommendations.

### Collaboration backlog impact

No immediate runbook procedure changes are required because collaborative editing is not part of the released core feature set.

**Backlog candidate:**
- future operator runbook appendix or optional procedure for evaluating collaborative editing in the Gutenberg plugin / future core releases, covering:
  - traffic profiling for sync requests
  - host and proxy exclusions for polling endpoints
  - incident response implications if collaborative state leaks or stalls
  - rollback criteria for disabling the feature on production sites

## `wp-security-style-guide`

### No immediate release-state correction required

I did not find stale pre-release WordPress `7.0` language in the canonical style guide itself.

### Backlog candidate: glossary and terminology support for future 7.x AI/collaboration docs

The style guide currently does **not** appear to define several terms that may become important if the other canonical repos add explicit WordPress `7.0` / `7.1` coverage:

- `Abilities API`
- `AI Client`
- `connector`
- `real-time collaboration`
- `sync provider`
- possibly `Yjs` if that term becomes necessary in operator-facing material

**Recommendation:**

Do not add these terms preemptively unless the canonical documents adopt them, but keep them queued as glossary candidates for the next cross-document terminology sweep.

## Preliminary Research Backlog: Real-Time Collaboration

This feature should be treated as **research/backlog**, not as current canonical operational guidance.

## Confirmed status

- Real-time collaboration was **removed from WordPress 7.0 before RC3**.
- It is now being tested through the **Gutenberg plugin** with a **7.1 outreach effort**.
- Core’s June 2026 guidance says this is something to **test and follow**, not to build production workflows around yet.

## Preliminary operator/security themes worth tracking

### 1. Server and hosting load profile

Core explicitly identified hosting impact as a reason for caution:

- collaborative editing changes WordPress from a mostly read-heavy pattern toward continuous write/sync activity
- the default design used HTTP polling
- polling is broadly compatible but less efficient than push-based transports such as WebSockets

### 2. Transport and authentication design

Core’s custom sync-provider guidance suggests future deployments may need to review:

- how collaboration transport tokens are issued
- whether tokens are short-lived and scoped to object/user context
- whether custom providers introduce new infrastructure and secret-management obligations
- whether provider errors degrade safely

### 3. Cache and proxy interaction

Hosts were explicitly encouraged to monitor requests to sync endpoints and validate request-management and caching behavior. Future docs may need environment-specific guidance for reverse proxies, CDN behavior, and cache bypass rules.

### 4. Plugin compatibility constraints

Core noted that classic metabox-heavy plugins are not naturally compatible with collaboration and that collaborative editing is disabled when metaboxes are present. This is both an operational and security-relevant issue because mixed editor state can lead to fragile save semantics and unclear trust boundaries.

### 5. Auditability and incident response

If the feature ships later in core, the document set should likely add guidance for:

- audit logging of collaborative edit sessions
- note/presence metadata handling
- access reviews for concurrent editors
- emergency disablement and rollback criteria

## Prioritized Editorial Recommendations

### Immediate

1. **Benchmark:** update the canonical release-state line to reflect that WordPress `7.0` shipped on **May 20, 2026**.
2. **Hardening Guide:** remove stale “scheduled for April 9, 2026” framing and convert overview/release-cycle references to current-release wording.
3. **Runbook:** update the example WordPress version placeholder from `6.9.1` to `7.0`.

### Next pass

4. **Hardening Guide:** revise the Argon2id paragraph so it no longer frames PHP `7.3` as a normal current-deployment baseline.
5. **Hardening Guide:** add WordPress `7.0`-specific AI-surface language in Section 14.

### Backlog / research only

6. **Hardening Guide + Runbook + Style Guide:** prepare a future collaboration package only after the `7.1` outreach clarifies what actually ships, how it is enabled, and what hosting/security guidance stabilizes.
7. **Style Guide:** queue glossary candidates for WordPress `7.x` AI/collaboration terminology if those terms land in canonical docs.

## Open Questions For The Next Research Pass

1. Should the canonical docs adopt **WordPress `7.0`** as the explicit “current stable” example everywhere, or minimize version pinning and move back toward evergreen wording where possible?
2. Should the Hardening Guide explicitly distinguish:
   - **minimum supported** = PHP `7.4`
   - **recommended production baseline** = PHP `8.3+`
   - **next validation target** = PHP `8.4`
3. Once the AI Client / Abilities API security posture is documented more explicitly, should the Benchmark gain one or more WordPress-7.0-specific AI controls beyond the existing generic AI section?
