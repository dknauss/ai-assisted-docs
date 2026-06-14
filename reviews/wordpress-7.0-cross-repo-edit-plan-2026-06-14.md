# WordPress 7.0 Cross-Repo Edit Plan — 2026-06-14

This plan converts the post-release research brief into a concrete editorial implementation sequence for the four canonical WordPress security document repositories.

Scope:

- `wp-security-benchmark`
- `wp-security-hardening-guide`
- `wordpress-runbook-template`
- `wp-security-style-guide`

This is an **edit plan only**. It does not apply source changes.

## Objective

Bring the canonical document set into post-release alignment after the public launch of WordPress `7.0`, while preserving the current series-wide PHP recommendation posture:

- **Minimum supported by WordPress core:** PHP `7.4`
- **Recommended production baseline for this doc set:** PHP `8.3+`
- **Next validation target:** PHP `8.4` in staging

Also: explicitly backlog real-time collaboration guidance as **future research / future documentation**, not current release-state content.

Also: fold in the most important official `7.0` release-note security implications:

- WordPress now ships first-party AI infrastructure in core-adjacent surfaces.
- The Connectors API formalizes a credential source hierarchy.
- Database-backed connector secrets are not encrypted.
- Arbitrary client-side prompt execution carries a high-privilege access-control risk.
- The Abilities API is now a real WordPress-native authorization-relevant surface.

## Confirmed Editorial Baseline

Use these facts consistently across all edits:

1. WordPress `7.0` released on **May 20, 2026**.
2. WordPress `7.0` dropped official support for PHP `7.2` and `7.3`.
3. WordPress `7.0` raised the **minimum supported** PHP version to **`7.4.0`**.
4. WordPress project guidance still recommends **PHP `8.3` or greater**.
5. Real-time collaboration did **not** ship in WordPress `7.0`; it remains under **7.1 outreach/testing**.
6. WordPress `7.0` ships first-party AI infrastructure including the `WP AI Client`, `Client-Side Abilities API`, `AI Connectors Screen`, and `Connectors API`.
7. The Connectors API supports credential sourcing from environment variables, PHP constants, or the database; database-backed API keys are **not encrypted**.
8. The AI Client dev note warns that arbitrary client-side prompt execution requires a high-privilege capability and is **not recommended** as a general distributed-plugin pattern.
9. The recommended pattern for AI features is narrow server-side REST endpoints with granular permission checks and server-side prompt handling.
10. The client-side Abilities API uses `/wp-abilities/v1/` and is explicitly intended for agent/workflow/browser-integrated use cases.

## Editing Strategy

### Global rules

Apply these rules consistently across the four repos:

1. **Remove stale pre-release wording.**
   - Replace `scheduled for April 9, 2026` and similar pre-release language.
   - If dates are still needed, use the actual release date: **May 20, 2026**.

2. **Prefer evergreen version framing where possible.**
   - Avoid unnecessary pinning to `6.9.1` or another transitional minor unless the specific version materially matters.
   - Prefer wording like `current stable WordPress release` or `WordPress 7.0` where precision is useful.

3. **Keep PHP floor vs. recommendation distinct.**
   - Do **not** collapse support floor and operational recommendation into one statement.
   - Use the official floor (`7.4`) only when discussing WordPress core support boundaries.
   - Keep `8.3+` as the series’ deployment recommendation.

4. **Do not describe collaboration as shipped core 7.0 behavior.**
   - Any collaboration mention must be clearly marked as research, future work, or 7.1-tracked.

5. **Update AI guidance from generic to WordPress-7.0-specific where relevant.**
   - Do not describe AI only as a generic third-party plugin or vendor concern when the discussion is really about shipped `7.0` WordPress surfaces.

6. **Prefer secrets outside the database for WordPress 7.0 AI integrations.**
   - Where AI credential storage is discussed, explicitly reflect the Connectors API source hierarchy and the fact that database-backed connector secrets are not encrypted.

7. **Treat client-side AI execution as an authorization boundary.**
   - Guidance should favor server-side orchestration and feature-specific REST endpoints with granular permission checks over arbitrary browser-side prompt execution.

8. **Update changelogs in each modified repo.**
   - Add `Unreleased` entries summarizing the 7.0 post-release editorial alignment.

## Repo-by-Repo Edit Plan

## 1. `wp-security-benchmark`

### Primary file
- `WordPress-Security-Benchmark.md`

### Required edits

1. **Update target-version framing in `Target Technology`.**
   - Replace:
     - `WordPress 6.9.1 as of March 21, 2026; WordPress 7.0 scheduled for April 9, 2026`
   - With post-release wording anchored to WordPress `7.0`.

2. **Check any other current-version statements for release drift.**
   - Especially frontmatter-adjacent context, overview, and any notes that imply 7.0 is still pending.

3. **Leave PHP `8.3+` deployment guidance intact unless a specific sentence incorrectly implies it is WordPress core’s minimum.**

4. **Strengthen AI control `11.1` with shipped WordPress `7.0` context.**
   - Keep the existing control intent.
   - Add concise WordPress-specific wording that the Connectors API can source credentials from environment variables, PHP constants, or the database, and that database-backed connector secrets are not encrypted.
   - Preserve the recommendation to prefer environment variables or `wp-config.php` constants.

### Optional / follow-up edits

5. Consider whether the benchmark should add a short note or rationale sentence in the AI section about:
   - avoiding arbitrary low-privilege client-side prompt execution
   - preferring narrow server-side REST endpoints with granular permission checks
   - but only if that can be done without over-expanding the benchmark beyond CIS-style control language

6. Consider whether the benchmark should add a short note somewhere in AI or future-environment sections that collaboration is a future operator concern, but **do not** add it unless there is a natural canonical location.

### Changelog work
- Add an `Unreleased` note describing post-release WordPress `7.0` version-framing alignment.

## 2. `wp-security-hardening-guide`

### Primary file
- `WordPress-Security-Hardening-Guide.md`

### Required edits

1. **Fix overview release framing.**
   - Remove wording that still treats 7.0 as scheduled for April 9, 2026.
   - Convert to post-release wording.

2. **Fix release-cycle example language.**
   - Replace examples using `6.9` / `6.9.1` as the current release context where they are now stale.
   - Ensure examples still teach the process clearly.

3. **Revise the cryptography / Argon2id paragraph.**
   - Current wording references `PHP 7.3+` in a way that is no longer ideal for a document about currently supported WordPress deployments.
   - Reframe to acknowledge WordPress `7.0` support floor (`7.4+`) while keeping the real deployment recommendation at `8.3+`.

4. **Expand Section 14 to acknowledge shipped WordPress 7.0 AI-adjacent surfaces.**
   - Add a brief WordPress-specific note covering:
     - AI Client in core
     - Abilities API / client-side abilities
     - connector/provider governance implications
   - Keep the section security-focused, not feature-promotional.

5. **Tighten Section 14.3 around secret management and authorization boundaries.**
   - Explicitly tie secret-storage guidance to the shipped Connectors API behavior:
     - environment variable
     - PHP constant
     - database
   - Note that database-backed connector secrets are not encrypted.
   - Add a WordPress-specific warning against arbitrary client-side prompt execution for general distributed-plugin use.
   - Recommend feature-specific server-side REST endpoints with granular permission checks and server-side prompt handling.

6. **Add an Abilities API authorization note in the AI section.**
   - Mention that WordPress now exposes a first-party abilities surface relevant to AI agents and workflow tooling.
   - Keep the discussion focused on permission boundaries and capability design, not feature marketing.

### Optional / follow-up edits

7. Add a short, clearly labeled future-facing note that real-time collaboration did not ship in `7.0` and remains a future operator/security topic.
   - Only if the placement is clean and not distracting.

### Changelog work
- Add an `Unreleased` note for post-release 7.0 alignment and AI-section refresh.

## 3. `wordpress-runbook-template`

### Primary file
- `WP-Operations-Runbook.md`

### Required edits

1. **Update the example WordPress version placeholder.**
   - Replace:
     - `e.g. WordPress 6.9.1`
   - With:
     - `e.g. WordPress 7.0`

2. **Review any release-cycle wording in README or supporting docs.**
   - The runbook is mostly evergreen, so this may be limited.

3. **Leave PHP placeholder guidance at `8.3+ recommended; test 8.4 in staging first` unless another file contradicts the official WordPress floor.**

### Optional / follow-up edits

4. Add a backlog note in planning or supplemental docs for future collaboration operations guidance, but **do not** treat it as current runbook procedure.

5. Review whether any future AI operations appendix or supplemental note should eventually reference:
   - connector credential sourcing
   - secret rotation expectations
   - server-side endpoint design for AI actions
   - but do **not** expand the main runbook in this round unless there is an existing natural location

### Changelog work
- Add an `Unreleased` note for WordPress `7.0` placeholder refresh.

## 4. `wp-security-style-guide`

### Primary file
- `WP-Security-Style-Guide.md`

### Required edits

None strictly required for WordPress `7.0` release-state correction, based on current findings.

### Follow-up editorial tasks

1. **Run a glossary gap assessment after the other three repos are updated.**
2. If new canonical wording lands, add or evaluate glossary coverage for:
   - `Abilities API`
   - `AI Client`
   - `connector`
   - `client-side prompt execution`
   - `server-side prompt handling`
   - `real-time collaboration`
   - `sync provider`
   - `Yjs` (only if it becomes necessary in reader-facing docs)

### Changelog work
- Only if glossary or wording updates are actually made.

## Execution Order

Recommended order:

### Phase 1 — release-state cleanup
1. `wp-security-benchmark`
2. `wp-security-hardening-guide`
3. `wordpress-runbook-template`

Goal: eliminate stale 6.9.x / pre-release 7.0 wording quickly.

### Phase 2 — PHP and AI precision pass
4. `wp-security-hardening-guide`
   - Argon2id / PHP floor wording
   - Section 14 WordPress-7.0 AI-specific expansion
5. `wp-security-benchmark`
   - AI control `11.1` WordPress-7.0 Connectors API precision
   - optional AI authorization-boundary wording if it fits cleanly

### Phase 3 — terminology and consistency audit
6. `wp-security-style-guide`
   - glossary gap check after canonical wording settles
7. Cross-repo comparison pass
   - verify WordPress version framing
   - verify PHP floor/recommendation framing
   - verify AI-client / connectors / abilities wording is consistent
   - verify secret-storage guidance reflects Connectors API reality
   - verify any client-side AI execution warnings are consistent
   - verify collaboration wording is consistently backlogged, not shipped

## Verification Checklist

After edits land, verify across all modified repos:

### Version framing
- No stale `WordPress 7.0 scheduled for April 9, 2026` language remains.
- No stale `WordPress 6.9.1 as current stable` placeholders remain where they are now misleading.
- Any remaining date-specific examples are intentional and historically correct.

### PHP framing
- Official support floor is described as **PHP `7.4`** where relevant.
- Operational recommendation remains **PHP `8.3+`**.
- `PHP 8.4` is presented as a validation/staging target, not assumed production default.
- No current-deployment guidance still leans on `PHP 7.3` as if it were a normal supported baseline.

### AI / authorization framing
- The docs acknowledge that WordPress `7.0` ships first-party AI infrastructure where relevant.
- Secret-management guidance reflects the Connectors API source hierarchy.
- No doc implies that database-backed connector secrets are encrypted.
- AI feature guidance prefers server-side prompt handling and granular REST permission checks where relevant.
- Any mention of client-side prompt execution accurately describes it as a high-privilege pattern, not a default general-purpose recommendation.
- Abilities API references, if added, are framed as authorization / capability surfaces rather than hype.

### Collaboration framing
- No canonical doc states or implies that real-time collaboration shipped in WordPress `7.0`.
- Any mention of collaboration is clearly future-facing, experimental, or backlogged.

### Changelogs and metrics
- `CHANGELOG.md` updated in each modified repo.
- Run each repo’s metrics verification workflow if document counts changed materially.
- Regenerate downstream outputs if the repo’s normal process requires it.

## Deliverables

1. Source edits in the three repos that need immediate update:
   - `wp-security-benchmark`
   - `wp-security-hardening-guide`
   - `wordpress-runbook-template`
2. Optional follow-up style-guide terminology sweep
3. Cross-repo post-edit audit summary
4. Regenerated publication artifacts where applicable

## Proposed Commit / PR Structure

### Option A — one PR per repo
Best if you want isolated review and publishing control.

### Option B — coordinated series pass
Use four PRs but one shared revision-round summary in `ai-assisted-docs`.

Recommended titles:
- `wp-security-benchmark`: `Align WordPress 7.0 release framing`
- `wp-security-hardening-guide`: `Refresh WordPress 7.0 and PHP guidance`
- `wordpress-runbook-template`: `Update WordPress 7.0 runbook placeholders`
- `wp-security-style-guide` (if needed): `Add WordPress 7.x AI terminology guidance`

## Decision Points Requiring Editorial Approval

1. **How explicit should the docs be about PHP `7.4`?**
   - Minimal: mention only when discussing core support boundaries
   - Fuller: mention in each repo’s overview or environment guidance

2. **How much WordPress 7.0 AI-surface detail belongs in the Hardening Guide now?**
   - Brief acknowledgment only
   - Small dedicated subsection in Section 14

3. **Whether to add any collaboration note now or leave it entirely to backlog artifacts.**
   - Conservative recommendation: backlog only, no canonical content yet

## Recommended Next Action

Proceed with **Phase 1 + Phase 2** edits first:

- benchmark release-state cleanup
- hardening-guide release/PHP/AI cleanup
- runbook placeholder update

Then run a short cross-repo terminology audit before touching the style guide.
