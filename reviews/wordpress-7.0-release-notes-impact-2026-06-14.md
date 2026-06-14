# WordPress 7.0 Release Notes / Field Guide Impact Review — 2026-06-14

This note isolates **release-notes-era changes** in WordPress `7.0` that are relevant to the four-document WordPress security series.

It supplements, but does not replace:

- [`wordpress-7.0-postrelease-research-2026-06-14.md`](wordpress-7.0-postrelease-research-2026-06-14.md)
- [`wordpress-7.0-cross-repo-edit-plan-2026-06-14.md`](wordpress-7.0-cross-repo-edit-plan-2026-06-14.md)

This is a **research artifact only**. No canonical source documents are changed here.

## Scope

Question under review:

> Beyond the already-confirmed WordPress `7.0` release date, PHP floor change, and held real-time collaboration feature, what other official `7.0` release-note / field-guide changes should affect the WordPress security documentation set?

## Primary Sources

Official WordPress sources reviewed:

- [WordPress 7.0 “Armstrong” release post](https://wordpress.org/news/2026/05/armstrong/)
- [WordPress 7.0 Field Guide](https://make.wordpress.org/core/2026/05/14/wordpress-7-0-field-guide/)
- [Introducing the AI Client in WordPress 7.0](https://make.wordpress.org/core/2026/03/24/introducing-the-ai-client-in-wordpress-7-0/)
- [Introducing the Connectors API in WordPress 7.0](https://make.wordpress.org/core/2026/03/18/introducing-the-connectors-api-in-wordpress-7-0/)
- [Client-Side Abilities API in WordPress 7.0](https://make.wordpress.org/core/2026/03/24/client-side-abilities-api-in-wordpress-7-0/)
- [PHP Compatibility and WordPress Versions](https://make.wordpress.org/core/handbook/references/php-compatibility-and-wordpress-versions/)
- [What’s new for developers? (June 2026)](https://developer.wordpress.org/news/2026/06/whats-new-for-developers-june-2026/)
- [Announcing a collaborative editing outreach effort for 7.1](https://make.wordpress.org/core/2026/06/03/announcing-a-collaborative-editing-outreach-effort-for-7-1/)
- [Extending the 7.0 Cycle](https://make.wordpress.org/core/2026/03/31/extending-the-7-0-cycle/)
- [Building a custom sync provider for real-time collaboration](https://make.wordpress.org/core/2026/04/01/building-a-custom-sync-provider-for-real-time-collaboration/)

## Findings

## 1. WordPress 7.0 ships first-party AI infrastructure, not just generic “AI plugin” context

**Verified**

The `7.0` field guide elevates AI infrastructure to a top-level release theme:

- `WP AI Client`
- `Client-Side Abilities API`
- `AI Connectors Screen`
- `Connectors API`

This matters because the current security series still treats AI mostly as a **generic third-party integration risk**. That framing is no longer wrong, but it is now incomplete.

### Editorial implication

The Hardening Guide and Benchmark should distinguish between:

1. **generic external AI services**, and
2. **new WordPress-core-adjacent AI surfaces introduced in 7.0**.

That distinction is now important for accuracy.

## 2. Connectors API materially strengthens the case for “secrets outside the database”

**Verified**

The official Connectors API dev note says WordPress `7.0` introduces `Settings > Connectors`, and that connectors can source credentials from:

- environment variables
- PHP constants
- the database

The same note states that database-backed API keys are **not encrypted**; they are only masked in the UI. The priority order is environment variable -> PHP constant -> database.

### Editorial implication

This is the strongest `7.0`-specific support for the existing Benchmark / Hardening recommendation to prefer:

- environment variables, or
- `wp-config.php` constants

over database storage for AI credentials.

### Cross-repo impact

- **Benchmark:** strengthen control `11.1` with a WordPress-`7.0` note about Connectors API storage sources and unencrypted database storage.
- **Hardening Guide:** update Section `14.3` so the database-storage warning is explicitly tied to the shipped Connectors API behavior, not just general best practice.
- **Style Guide:** likely add glossary coverage for `connector`.

## 3. The AI Client dev note adds an important access-control warning for client-side prompt execution

**Verified**

The AI Client dev note says the separate JavaScript prompt API uses REST endpoints under the hood, allows arbitrary prompt execution from the client side, and therefore requires a **high-privilege capability** by default. It also says using that approach in a distributed plugin is **not recommended**. The recommended pattern is feature-specific REST endpoints with granular permission checks and server-side prompt handling.

### Editorial implication

This directly sharpens current AI guidance in both the Benchmark and Hardening Guide:

- do not expose arbitrary client-side AI execution to lower-privilege users
- use narrow, purpose-built REST endpoints
- enforce granular permission checks
- keep actual prompt orchestration and provider configuration server-side

### Cross-repo impact

- **Hardening Guide:** add a WordPress-`7.0` paragraph in Section `14.3` about avoiding arbitrary client-side prompt execution.
- **Benchmark:** consider whether a future L2 control is warranted for AI endpoint authorization design, but this is not necessarily required in the current round.

## 4. Client-Side Abilities API means WordPress now has a first-party browser-agent integration surface

**Verified**

The client-side Abilities API dev note says the API is intended for AI agents, workflow automation tools, and plugins, and that `@wordpress/core-abilities` fetches server-side abilities via the REST API endpoint `/wp-abilities/v1/`. It also explicitly mentions browser agents/extensions and WebMCP integration.

### Editorial implication

The security series should now treat Abilities API surfaces as a real WordPress-native extension point, not a speculative future concept.

### Cross-repo impact

- **Hardening Guide:** mention Abilities API in the AI security section when discussing authorization boundaries.
- **Style Guide:** likely add glossary entries for `Abilities API` and possibly `ability`.

## 5. “More secure user registration” is relevant to role/default-role guidance

**Verified**

The `7.0` field guide states that Administrator and Editor roles were removed from the default-role selector under `Settings > General`. It also says Site Health will warn about pre-existing risky selections, and introduces the `default_role_dropdown_excluded_roles` filter.

### Editorial implication

This does **not** eliminate the need for least-privilege guidance, but it does mean WordPress `7.0` now has a built-in guardrail against one common misconfiguration.

### Cross-repo impact

- **Hardening Guide:** optional note in identity / authorization guidance that core now reduces accidental high-privilege registration defaults.
- **Benchmark:** optional future control note or rationale language, if there is a natural placement.

### Recommendation

Treat this as a **useful contextual update**, not a top-priority rewrite driver.

## 6. PHP changes are broader than the floor bump alone

**Verified**

Already-confirmed items remain correct:

- WordPress `7.0` dropped support for PHP `7.2` and `7.3`.
- WordPress `7.0` minimum supported PHP is `7.4`.
- The project’s minimum recommended PHP version remains `8.3`.

Also relevant:

- the old “beta support” label for newer PHP versions was retired in May 2026
- WordPress `6.9` and `7.0` are documented as fully supporting PHP `8.5`

### Editorial implication

This supports the current doc-set posture:

- keep `7.4` as the core support floor
- keep `8.3+` as the production recommendation
- avoid language that treats newer PHP 8.x support as tentative or experimental

### Cross-repo impact

- **Hardening Guide:** revise stale `PHP 7.3+` wording around Argon2id.
- **Runbook:** current `8.3+ recommended; validate 8.4 in staging` stance still looks sound.

## 7. Real-time collaboration remains backlog / research, not current canonical guidance

**Verified**

Post-release official sources are clear:

- real-time collaboration did **not** ship in WordPress `7.0`
- collaborative editing is now under dedicated `7.1` outreach/testing

The earlier sync-provider dev note is still useful for preliminary research because it documents real security issues:

- WordPress cannot authorize external sync infrastructure on your behalf
- authorization for custom sync providers is the operator’s responsibility
- token-based auth, per-document authorization, and short-lived tokens are recommended

### Editorial implication

Do **not** write `7.0` canonical guidance as if collaborative editing is a production core feature.

But do preserve a backlog note that, if or when this feature ships, the docs will need coverage for:

- sync-server authorization
- token issuance and validation
- per-document authorization checks
- hosting/resource impact

## 8. Lower-priority release-note items worth noting, but not necessarily for immediate edits

### Likely minor / contextual only

- `PHPMailer` updated to `7.0.2`
- `Requests` updated to `2.0.17`
- Site Health now shows `OPcache` details
- `wp_trigger_error()` gained new hook behavior when `WP_DEBUG` is not truthy

These are real `7.0` changes, but none currently look like first-round revision drivers for the four canonical security docs unless a more specific section already discusses them.

### Probably out of scope for this round

- author-link `title` attribute changes
- dashboard visual changes
- most editor/design-tool enhancements

## Prioritization

## High-priority edits to incorporate into the cross-repo plan

1. Update AI sections to reflect shipped `7.0` first-party AI infrastructure.
2. Tie AI secret-management guidance to the Connectors API storage model.
3. Add the client-side prompt execution / high-privilege warning from the AI Client dev note.
4. Mention Abilities API as a real authorization-relevant WordPress surface.

## Medium-priority edits

5. Use the new user-registration safeguard as contextual support for least-privilege guidance.
6. Clean up any wording that implies newer PHP 8.x support is still provisional.

## Backlog / future research

7. Keep collaborative editing / sync-provider security in backlog status until the feature actually ships in core.

## Bottom Line

The most important `7.0` release-note impact is **not** another generic version bump. It is that WordPress now ships **core-adjacent AI infrastructure** with concrete security implications:

- credential source hierarchy
- unencrypted database-backed connector secrets
- high-privilege client-side prompt execution risk
- first-party abilities / browser-agent integration surfaces

Those changes should materially sharpen the AI sections in the Benchmark, Hardening Guide, and Style Guide glossary work.
