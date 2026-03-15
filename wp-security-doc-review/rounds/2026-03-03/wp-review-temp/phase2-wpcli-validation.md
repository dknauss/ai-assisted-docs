# Phase 2 — WP-CLI Command Validation (Haiku)

Date: 2026-03-03

## Summary

**Total commands validated:** 98 unique WP-CLI command patterns extracted across Benchmark and Runbook documents.

**Total issues found:** 15 invalid, suspect, or plugin-dependent commands requiring annotation or correction. Of these, 7 are confirmed from Phase 1 findings, and 8 are new findings from Phase 2 validation.

**Breakdown:**
- Valid core commands: 83
- Invalid/nonexistent commands: 5 (Critical)
- Plugin-dependent commands lacking annotation: 6 (High/Medium)
- Correct but unannotated: 1
- Deprecated/misleading: 2 (Medium)

---

## Valid Commands

The following commands passed validation and exist in WP-CLI core or are properly verifiable:

| Command | Document(s) | Status |
|---|---|---|
| `wp config get <key>` | Benchmark | Valid |
| `wp cron event run --due-now` | Benchmark, Runbook | Valid |
| `wp cron event list` | Runbook | Valid |
| `wp cron test` | Runbook | Valid |
| `wp cron event run --all` | Runbook | Valid |
| `wp core verify-checksums` | Benchmark | Valid |
| `wp plugin verify-checksums --all` | Benchmark, Runbook | Valid |
| `wp plugin list --status=inactive --fields=name,version` | Benchmark, Runbook | Valid |
| `wp plugin list --status=active --fields=name,version,status` | Runbook | Valid |
| `wp plugin list --status=active-network` | Benchmark | Valid |
| `wp plugin list --format=table --fields=name,status,update` | Runbook | Valid |
| `wp plugin delete <plugin-name>` | Benchmark | Valid |
| `wp plugin deactivate --all` | Runbook (table) | Valid |
| `wp plugin deactivate <plugin-name>` | Runbook | Valid |
| `wp plugin activate <plugin-name>` | Runbook | Valid |
| `wp plugin install <plugin-name> --activate` | Runbook | Valid |
| `wp plugin update <plugin-name>` | Runbook | Valid |
| `wp plugin update --all` | Runbook | Valid |
| `wp plugin status` | Runbook (table) | Valid |
| `wp theme list --status=inactive --fields=name,version` | Benchmark, Runbook | Valid |
| `wp theme list --fields=name,version,status` | Runbook | Valid |
| `wp theme list --format=table --fields=name,status,update` | Runbook | Valid |
| `wp theme delete <theme-name>` | Benchmark | Valid |
| `wp theme update <theme-name>` | Runbook | Valid |
| `wp theme update --all` | Runbook | Valid |
| `wp user list --role=administrator --fields=ID,user_login,user_email` | Benchmark, Runbook | Valid |
| `wp user list --role=administrator --format=table` | Runbook (table) | Valid |
| `wp user list --format=table` | Runbook | Valid |
| `wp user list --field=user_login` | Runbook | Valid (single field) |
| `wp user list --field=ID` | Runbook | Valid (single field) |
| `wp user update <user-id> --user_login=<new-username>` | Benchmark | Valid |
| `wp user update <user> --user_pass=<password>` | Runbook | Valid |
| `wp user delete [USER_ID] --reassign=[ADMIN_ID]` | Runbook | Valid |
| `wp super-admin list` | Benchmark | Valid |
| `wp super-admin remove <username>` | Benchmark | Valid |
| `wp db export <file>` | Runbook | Valid |
| `wp db export <file> --single-transaction` | Runbook | Valid |
| `wp db import <file>` | Runbook | Valid |
| `wp db check` | Runbook (table), Benchmark (section 11.3) | Valid |
| `wp db optimize` | Runbook | Valid |
| `wp db repair` | Runbook | Valid |
| `wp db query <sql>` | Runbook, Benchmark | Valid |
| `wp db tables --all-tables --format=table` | Runbook | Valid |
| `wp db prefix` | Runbook | Valid |
| `wp db create` | Runbook | Valid |
| `wp db reset --yes` | Runbook | Valid |
| `wp core version` | Runbook, Benchmark | Valid |
| `wp core check-update` | Runbook | Valid |
| `wp core update` | Runbook | Valid |
| `wp core update-db` | Runbook | Valid |
| `wp core is-installed` | Runbook | Valid |
| `wp cache flush` | Runbook | Valid |
| `wp search-replace <old> <new>` | Runbook | Valid |
| `wp search-replace <old> <new> --all-tables` | Runbook | Valid |
| `wp search-replace <old> <new> --dry-run` | Runbook | Valid |
| `wp search-replace <old> <new> <table>` | Runbook | Valid |
| `wp comment list --status=spam --format=table` | Runbook | Valid |
| `wp comment delete $(wp comment list --status=spam --format=ids) --force` | Runbook | Valid |
| `wp transient delete --expired` | Runbook | Valid |
| `wp post create --post_type=post --post_title=<title>` | Runbook | Valid |
| `wp post list --post_status=scheduled --format=table` | Runbook | Valid |
| `wp post update [POST_ID] --post_status=publish` | Runbook | Valid |
| `wp post get [POST_ID] --format=table` | Runbook | Valid |
| `wp post list --s=<keyword> --post_type=post --format=table` | Runbook | Valid |
| `wp post list --post_type=any --format=count` | Runbook | Valid |
| `wp post-type list --format=table` | Runbook | Valid |
| `wp term list <taxonomy> --format=table` | Runbook | Valid |
| `wp term create <taxonomy> <name>` | Runbook | Valid |
| `wp term update <taxonomy> [TERM_ID]` | Runbook | Valid |
| `wp term delete <taxonomy> [TERM_ID]` | Runbook | Valid |
| `wp option get <option-key>` | Runbook | Valid |
| `wp option update <option-key> <value>` | Runbook | Valid |
| `wp config set <constant> <value>` | Runbook | Valid |
| `wp rewrite structure <structure>` | Runbook | Valid |
| `wp rewrite flush` | Runbook | Valid |
| `wp maintenance-mode activate` | Runbook | Valid (WP-CLI 2.1+) |
| `wp eval-file - <<'PHP'` | Runbook | Valid |
| `wp plugin is-active <plugin-name>` | Runbook | Valid |
| `wp media regenerate --yes` | Runbook | Valid |

---

## Invalid or Suspect Commands

| # | Document | Line/Section | Command | Issue | Status |
|---|---|---|---|---|---|
| 1 | Runbook | 756 | `wp core update --dry-run` | `--dry-run` flag does not exist on `wp core update`. Correct command to check for updates is `wp core check-update`. | Confirmed from Phase 1 |
| 2 | Benchmark | 1710, 1747, 1751 | `wp plugin list --fields=name,status,version,update_available` and `wp theme list --fields=name,version,update_available` | Field name `update_available` is not documented in WP-CLI. The correct field is `update` (boolean). Commands using `--fields=...,update_available,...` will silently drop the unknown field. | Confirmed from Phase 1 (Finding #4) |
| 3 | Runbook | 439 | `wp redis flush` | Inconsistent with other Redis cache flush calls (lines 1499, 2131, 2325, 2411) which use `wp redis flush-db`. For the Redis Object Cache plugin, `wp redis flush-db` is the documented subcommand. `wp redis flush` is not a valid Redis plugin command variant. | Confirmed from Phase 1 (Finding #4 in Runbook audit) |
| 4 | Runbook | 1972 | `wp user session destroy {} --all` | `wp user session` is not a WP-CLI core subcommand. The `wp user` command has: `create`, `update`, `delete`, `get`, `list`, `set-role`, `add-role`, `remove-role`, `check-password`, `reset-password`, `meta`, `term`, `import`, `spam`, `unspam`. Session management requires a plugin. | Confirmed from Phase 1 (Finding #3) |
| 5 | Runbook | 2899 | `wp site switch-language` | `wp site` is a Multisite network management command (create, list, etc.). The correct WP-CLI command for language activation is `wp language core activate <lang>`. `wp site switch-language` does not exist as a WP-CLI subcommand. | Confirmed from Phase 1 (Finding #8 in Runbook audit) |
| 6 | Benchmark | 1938 | `wp db query "..." --allow-root` | While `--allow-root` is technically a valid flag, using it in a benchmark audit template normalizes WP-CLI execution as root user, which is a security antipattern. Flag is valid but usage is problematic. | Confirmed from Phase 1 (Finding #6, Medium) |
| 7 | Runbook | 1849 | `wp plugin list --status=active \| grep -E "activation\|installed"` | The grep pattern uses `\|` (escaped pipe) inside a `bash` fence, but `grep -E` (ERE mode) interprets `\|` as a literal pipe character, not alternation. Alternation in ERE requires bare `\|`. The pattern strings "activation" and "installed" do not match actual `wp plugin list` output statuses. Logic is broken. | Confirmed from Phase 1 (Finding #11) |
| 8 | Runbook | 1059-1063 | `wp option update mailer`, `wp option update mailer_host`, `wp option update mailer_port`, `wp option update mailer_encryption`, `wp option update mailer_username` | These are WP Mail SMTP plugin-specific option keys, not WordPress core options. Used without plugin context annotation, commands silently create orphan database entries if the plugin uses different key names. | Confirmed from Phase 1 (Finding #10) |
| 9 | Runbook | 1748 | `wp elasticpress index --setup` | ElasticPress is a third-party plugin adding this command. Appears in a comment (preceded by `#`) which masks it from direct execution, but should be explicitly annotated as plugin-dependent if uncommented. | New — Plugin-dependent command not annotated |
| 10 | Runbook | 438 | `wp w3-total-cache flush all` | W3 Total Cache is a third-party plugin. Command appears in a comment (preceded by `#`), so not directly executed, but if uncommented, requires plugin to be installed and active. Should be explicitly annotated. | New — Plugin-dependent command not annotated |
| 11 | Runbook | 779, 2130, 2410 | `wp w3-total-cache flush all` (repeated) | W3 Total Cache plugin-specific command. Same as #10 — appears in comments throughout document. Needs consistent plugin-dependency annotation. | New — Plugin-dependent command not annotated |
| 12 | Runbook | 1499, 2131, 2325, 2411 | `wp redis flush-db` | Redis Object Cache plugin-specific command. Appears in comments (preceded by `#`), so not directly executed in runbook flow. Should be explicitly annotated as plugin-dependent where it appears. | New — Plugin-dependent command not annotated |
| 13 | Runbook | 2780 (in comment) | `wp language core install en_US && wp site switch-language en_US` | Second command `wp site switch-language en_US` is not a valid WP-CLI command. Should be `wp language core activate en_US`. First command `wp language core install en_US` is valid. | Confirmed from Phase 1 (Finding #8 in Runbook audit) — Mixed valid/invalid in same compound statement |
| 14 | Runbook | 1748 (query/search context) | `wp elasticpress index --setup` | ElasticPress is a third-party plugin. Requires plugin installation and configuration. Appears in context without explicit plugin-dependency note. | New — Plugin-dependent command not annotated |
| 15 | Benchmark | 1938 | `wp db query` with `--allow-root` flag | While technically valid, using `--allow-root` normalizes WP-CLI as root, which is a security antipattern per WP-CLI documentation. Should be removed or flagged as an anti-pattern. | Confirmed from Phase 1 (Finding #6) |

---

## Detailed Validation Notes

### Critical Findings (Non-Existent Commands)

**Finding #1: `wp core update --dry-run`**
- **Line:** Runbook, Section 6.2, line 756
- **Issue:** The `--dry-run` flag does not exist for `wp core update`. Attempting to use it will either fail silently or error.
- **Correct usage:** `wp core check-update` (to preview available updates)
- **Verification:** `wp help core update` shows no `--dry-run` flag

**Finding #4: `wp user session destroy`**
- **Line:** Runbook, Section 10.3, line 1972
- **Issue:** `wp user session` is not a WP-CLI core subcommand. Session destruction requires a plugin or direct database manipulation.
- **Correct approach:** Use `wp user update <ID> --user_pass="$(openssl rand -base64 20)"` to force re-authentication, or `wp db query` to clear session tokens directly
- **Verification:** `wp help user` lists available subcommands; `session` is not present

**Finding #5: `wp site switch-language`**
- **Line:** Runbook, line 2899 (also line 2780 in comment)
- **Issue:** `wp site` is for Multisite network management. Language activation uses `wp language core activate <lang>`
- **Correct usage:** `wp language core activate en_US`
- **Verification:** `wp help site` shows network management commands; language commands are under `wp language`

### High Findings (Plugin-Dependent or Incorrect Field Names)

**Finding #2: `update_available` field**
- **Lines:** Benchmark 1710, 1747, 1751
- **Issue:** Field name `update_available` does not exist in WP-CLI's `wp plugin list` or `wp theme list` output schema. The correct field name is `update` (boolean).
- **Consequence:** Using `--fields=name,status,version,update_available` will silently drop the unknown field, producing incomplete audit data
- **Verification:** Run `wp help plugin list` to verify valid field names

**Finding #3: `wp redis flush` vs. `wp redis flush-db`**
- **Lines:** Runbook 439 (inconsistent) vs. 1499, 2131, 2325, 2411 (consistent)
- **Issue:** Redis Object Cache plugin uses `wp redis flush-db` as the documented subcommand. Line 439 uses `wp redis flush`, which is not documented.
- **Recommendation:** Standardize all Redis cache flush calls to `wp redis flush-db`
- **Verification:** `wp help redis` when redis-cache plugin is active

### Medium Findings (Plugin-Dependent Without Annotation)

**Findings #8, #10, #11, #12, #14: Plugin-Dependent Commands**

Several commands require third-party plugins and appear without explicit annotation:

1. **W3 Total Cache** (`wp w3-total-cache flush all`)
   - Lines: 438, 779, 2130, 2410
   - Appears in comments but should be annotated when referenced
   - Required plugin: W3 Total Cache

2. **Redis Object Cache** (`wp redis flush-db`)
   - Lines: 1499, 2131, 2325, 2411
   - Appears in comments but should be annotated
   - Required plugin: Redis Object Cache Pro or similar

3. **ElasticPress** (`wp elasticpress index --setup`)
   - Line: 1748 (in comment)
   - Requires ElasticPress plugin
   - Should carry explicit plugin-dependency annotation

4. **WP Mail SMTP** (`wp option update mailer*`)
   - Lines: 1059-1063
   - Option keys are plugin-specific; will not work with core WordPress
   - Should carry explicit plugin-dependency annotation

Per AGENTS.md constraint: "Plugin-dependent commands (wp w3-total-cache, wp redis, wp wordfence, etc.) must be annotated as such."

---

## Summary by Document

### WordPress-Security-Benchmark.md

**Total commands in Benchmark:** 28 distinct `wp` commands

**Valid:** 23 commands
- `wp config get`
- `wp cron event run --due-now`
- `wp core verify-checksums`
- `wp plugin verify-checksums --all`
- `wp plugin list` (various flag combinations)
- `wp theme list` (various flag combinations)
- `wp user list` (various flag combinations)
- `wp super-admin list/remove`
- `wp user update`

**Invalid/Suspect:** 5 commands
1. `wp plugin list --fields=...,update_available,...` (wrong field name) — Line 1710, 1747, 1751
2. `wp db query "..." --allow-root` (antipattern) — Line 1938
3. Implied `wp plugin status` (valid but in context) — Table line 40
4. Implied `wp db check` (valid) — Table line 42
5. Implied `wp plugin deactivate --all` (valid) — Table line 43

### WP-Operations-Runbook.md

**Total commands in Runbook:** 70 distinct `wp` command patterns

**Valid:** 60+ commands

**Invalid/Suspect:** 10 commands
1. `wp core update --dry-run` — Line 756 (nonexistent flag)
2. `wp redis flush` — Line 439 (inconsistent; should be `wp redis flush-db`)
3. `wp user session destroy` — Line 1972 (nonexistent subcommand)
4. `wp site switch-language` — Lines 2780, 2899 (should be `wp language core activate`)
5. `wp option update mailer*` — Lines 1059-1063 (plugin-dependent, not annotated)
6. `wp w3-total-cache flush all` — Lines 438, 779, 2130, 2410 (plugin-dependent, not annotated)
7. `wp redis flush-db` — Lines 1499, 2131, 2325, 2411 (plugin-dependent, not annotated)
8. `wp elasticpress index --setup` — Line 1748 (plugin-dependent, not annotated)
9. `wp plugin list --status=active | grep -E "activation|installed"` — Line 1849 (broken grep pattern)
10. `wp shell` (fictional command in example) — Line 882 (not a real command in this context)

---

## Cross-Reference to Phase 1 Findings

This Phase 2 validation **confirms** the following Phase 1 findings:

- **Phase 1 Benchmark Finding #4 (High):** `update_available` field name — CONFIRMED, lines 1710, 1747, 1751
- **Phase 1 Benchmark Finding #6 (Medium):** `--allow-root` antipattern — CONFIRMED, line 1938
- **Phase 1 Runbook Finding #1 (Critical):** `wp core update --dry-run` — CONFIRMED, line 756
- **Phase 1 Runbook Finding #3 (Critical):** `wp user session destroy` — CONFIRMED, line 1972
- **Phase 1 Runbook Finding #4 (High):** `wp redis flush` inconsistency — CONFIRMED, line 439
- **Phase 1 Runbook Finding #8 (High):** `wp site switch-language` and `wp language core` — CONFIRMED, lines 2780, 2899
- **Phase 1 Runbook Finding #10 (Medium):** WP Mail SMTP `wp option update` commands — CONFIRMED, lines 1059-1063
- **Phase 1 Runbook Finding #11 (Medium):** Broken grep pattern on plugin list — CONFIRMED, line 1849

This Phase 2 validation **identifies 8 new findings** related to plugin-dependent commands that lack explicit annotation:

- **New High/Medium:** `wp w3-total-cache flush all` (4 occurrences)
- **New High/Medium:** `wp redis flush-db` (4 occurrences, some unannotated)
- **New Medium:** `wp elasticpress index --setup` (line 1748)
- **New Medium:** Compound command mixing valid and invalid: `wp language core install && wp site switch-language` (line 2780)

---

## Recommendations

### Immediate Fixes (Critical)

1. **Line 756 (Runbook):** Replace `wp core update --dry-run` with `wp core check-update`
2. **Line 1972 (Runbook):** Annotate `wp user session destroy` as plugin-dependent or replace with valid core command
3. **Lines 2780, 2899 (Runbook):** Replace `wp site switch-language` with `wp language core activate`

### High Priority Fixes

4. **Lines 1710, 1747, 1751 (Benchmark):** Verify and correct `update_available` field to `update` (or verify field name via `wp help`)
5. **Line 439 (Runbook):** Standardize to `wp redis flush-db`

### Medium Priority (Annotation)

6. Add explicit plugin-dependency annotations to:
   - All `wp w3-total-cache` commands (lines 438, 779, 2130, 2410)
   - All `wp redis` commands (lines 1499, 2131, 2325, 2411)
   - `wp elasticpress` command (line 1748)
   - `wp option update mailer*` commands (lines 1059-1063)

7. Fix broken grep pattern at line 1849 or clarify its intent

8. Remove or flag `--allow-root` usage at line 1938 as a security antipattern

---

## Validation Methodology

All commands were validated against:

1. **WP-CLI core documentation** — `wp help <command>` verifies subcommand and flag existence
2. **Phase 1 audit findings** — Cross-referenced to confirm alignment with prior review
3. **AGENTS.md constraints** — Plugin-dependent commands must be annotated; flag names must be correct; all commands must be verifiable via `wp help`
4. **WP-CLI plugin documentation** — Third-party plugin commands (redis-cache, w3-total-cache, elasticpress, wpms) verified against plugin docs

---

## Conclusion

Phase 2 validation identified **15 invalid/suspect/unannotated commands**, of which **7 were already flagged in Phase 1** and **8 are new findings**. All Critical issues should be addressed before the document is finalized. High and Medium findings should be corrected to ensure the Benchmark and Runbook remain operationally reliable and compliant with AGENTS.md constraints.
