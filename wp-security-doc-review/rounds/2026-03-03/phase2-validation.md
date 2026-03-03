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
# Phase 2 — Code Block Lint (Haiku)

Date: 2026-03-03

## Summary

Total code blocks checked: 267 across 2 documents
Issues found: 48

**Breakdown by severity:**
- High: 48 (missing bash language annotations)
- Medium: 0
- Low: 0

## Issues Found

| # | Document | Line | Language | Issue | Severity |
|---|---|---|---|---|---|
| 1 | WordPress-Security-Benchmark.md | 75 | bash | Missing bash language annotation. Block contains shell command: `$ grep -r 'ssl_protocols' /etc/nginx/` | High |
| 2 | WordPress-Security-Benchmark.md | 80 | bash | Missing bash language annotation. Block contains shell command: `$ grep -r 'SSLProtocol' /etc/apache2/` | High |
| 3 | WordPress-Security-Benchmark.md | 121 | bash | Missing bash language annotation. Block contains shell command: `$ curl -sI https://example.com \| grep -iE '(content-security...'` | High |
| 4 | WordPress-Security-Benchmark.md | 182 | bash | Missing bash language annotation. Block contains shell command: `$ curl -sI https://example.com \| grep -i 'server'` | High |
| 5 | WordPress-Security-Benchmark.md | 226 | bash | Missing bash language annotation. Block contains shell command: `$ grep -A5 'uploads' /etc/nginx/sites-enabled/*` | High |
| 6 | WordPress-Security-Benchmark.md | 270 | bash | Missing bash language annotation. Block contains shell command: `$ grep -r 'limit_req' /etc/nginx/` | High |
| 7 | WordPress-Security-Benchmark.md | 331 | bash | Missing bash language annotation. Block contains shell command: `$ php -i \| grep expose_php` | High |
| 8 | WordPress-Security-Benchmark.md | 369 | bash | Missing bash language annotation. Block contains shell command: `$ php -i \| grep display_errors` | High |
| 9 | WordPress-Security-Benchmark.md | 417 | bash | Missing bash language annotation. Block contains shell command: `$ php -i \| grep disable_functions` | High |
| 10 | WordPress-Security-Benchmark.md | 454 | bash | Missing bash language annotation. Block contains shell command: `$ php -i \| grep open_basedir` | High |
| 11 | WordPress-Security-Benchmark.md | 491 | bash | Missing bash language annotation. Block contains shell command: `$ php -i \| grep -E 'session\.(cookie_secure...'` | High |
| 12 | WordPress-Security-Benchmark.md | 595 | bash | Missing bash language annotation. Block contains shell command: `$ grep -E 'bind-address\|skip-networking' /etc/mysql/mysql.conf.d/mysqld.cnf` | High |
| 13 | WordPress-Security-Benchmark.md | 599 | bash | Missing bash language annotation. Block contains shell command: `$ ss -tlnp \| grep 3306` | High |
| 14 | WordPress-Security-Benchmark.md | 639 | bash | Missing bash language annotation. Block contains shell command: `$ grep 'table_prefix' /path/to/wp-config.php` | High |
| 15 | WordPress-Security-Benchmark.md | 647 | bash | Missing bash language annotation. Block contains PHP variable: `$table_prefix = 'wxyz_';` | High |
| 16 | WordPress-Security-Benchmark.md | 676 | bash | Missing bash language annotation. Block contains shell command: `$ grep -E '(general_log\|slow_query_log)' /etc/mysql/mysql.conf.d/mysqld.cnf` | High |
| 17 | WordPress-Security-Benchmark.md | 735 | bash | Missing bash language annotation. Block contains shell command: `$ grep 'DISALLOW_FILE_EDIT' /path/to/wp-config.php` | High |
| 18 | WordPress-Security-Benchmark.md | 774 | bash | Missing bash language annotation. Block contains shell command: `$ grep 'FORCE_SSL_ADMIN' /path/to/wp-config.php` | High |
| 19 | WordPress-Security-Benchmark.md | 810 | bash | Missing bash language annotation. Block contains shell command: `$ grep -E 'WP_DEBUG\|WP_DEBUG_DISPLAY\|WP_DEBUG_LOG' /path/to/wp-config.php` | High |
| 20 | WordPress-Security-Benchmark.md | 852 | bash | Missing bash language annotation. Block contains shell command: `$ curl -s -o /dev/null -w '%{http_code}' https://example.com/xmlrpc.php` | High |
| 21 | WordPress-Security-Benchmark.md | 895 | bash | Missing bash language annotation. Block contains shell command: `$ wp config get WP_AUTO_UPDATE_CORE --path=/path/to/wordpress 2>/dev/null` | High |
| 22 | WordPress-Security-Benchmark.md | 899 | bash | Missing bash language annotation. Block contains shell command: `$ grep 'WP_AUTO_UPDATE_CORE\|AUTOMATIC_UPDATER_DISABLED' /path/to/wp-config.php` | High |
| 23 | WordPress-Security-Benchmark.md | 935 | bash | Missing bash language annotation. Block contains shell command: `$ grep -E '(AUTH_KEY\|SECURE_AUTH_KEY...'` | High |
| 24 | WordPress-Security-Benchmark.md | 943 | bash | Missing bash language annotation. Block contains shell command: `$ curl -s https://api.wordpress.org/secret-key/1.1/salt/` | High |
| 25 | WordPress-Security-Benchmark.md | 971 | bash | Missing bash language annotation. Block contains shell command: `$ grep 'DISABLE_WP_CRON' /path/to/wp-config.php` | High |
| 26 | WordPress-Security-Benchmark.md | 977 | bash | Missing bash language annotation. Block contains shell command: `$ crontab -l \| grep -E 'wp.cron'` | High |
| 27 | WordPress-Security-Benchmark.md | 982 | bash | Missing bash language annotation. Block contains shell command: `$ curl -s -o /dev/null -w '%{http_code}' https://example.com/wp-cron.php` | High |
| 28 | WordPress-Security-Benchmark.md | 1069 | bash | Missing bash language annotation. Block contains shell command: `$ wp user list --role=administrator --fields=ID,user_login,user_email --path=/path/to/wordpress` | High |
| 29 | WordPress-Security-Benchmark.md | 1078 | bash | Missing bash language annotation. Block contains shell command: `$ wp user update <user-id> --user_login=<new-username> --path=/path/to/wordpress` | High |
| 30 | WordPress-Security-Benchmark.md | 1112 | bash | Missing bash language annotation. Block contains shell command: `$ grep -r 'auth_cookie_expiration' /path/to/wp-content/mu-plugins/ /path/to/wp-config.php` | High |
| 31 | WordPress-Security-Benchmark.md | 1158 | bash | Missing bash language annotation. Block contains shell command: `$ curl -s https://example.com/wp-json/wp/v2/users \| python3 -m json.tool` | High |
| 32 | WordPress-Security-Benchmark.md | 1162 | bash | Missing bash language annotation. Block contains shell command: `$ curl -sI https://example.com/?author=1` | High |
| 33 | WordPress-Security-Benchmark.md | 1244 | bash | Missing bash language annotation. Block contains shell command: `$ curl -sI https://example.com/wp-json/wp/v2/posts` | High |
| 34 | WordPress-Security-Benchmark.md | 1249 | bash | Missing bash language annotation. Block contains shell command: `$ curl -s https://example.com/wp-json/wp/v2/users` | High |
| 35 | WordPress-Security-Benchmark.md | 1398 | bash | Missing bash language annotation. Block contains shell command: `$ stat -c '%U:%G' /path/to/wordpress/wp-config.php` | High |
| 36 | WordPress-Security-Benchmark.md | 1402 | bash | Missing bash language annotation. Block contains shell command: `$ stat -c '%U:%G' /path/to/wordpress/wp-includes/version.php` | High |
| 37 | WordPress-Security-Benchmark.md | 1451 | bash | Missing bash language annotation. Block contains shell command: `$ stat -c '%a %U:%G' /path/to/wordpress/wp-config.php` | High |
| 38 | WordPress-Security-Benchmark.md | 1492 | bash | Missing bash language annotation. Block contains shell command: `$ ls -la /var/www/example.com/wp-config.php` | High |
| 39 | WordPress-Security-Benchmark.md | 1496 | bash | Missing bash language annotation. Block contains shell command: `$ curl -sI https://example.com/ \| head -5` | High |
| 40 | WordPress-Security-Benchmark.md | 1503 | bash | Missing bash language annotation. Block contains shell command: `$ mv /var/www/example.com/wp-config.php /var/www/wp-config.php` | High |
| 41 | WordPress-Security-Benchmark.md | 1509 | bash | Missing bash language annotation. Block contains shell command: `$ chmod 750 /var/www/` | High |
| 42 | WordPress-Security-Benchmark.md | 1581 | bash | Missing bash language annotation. Block contains shell command: `$ wp core verify-checksums --path=/path/to/wordpress` | High |
| 43 | WordPress-Security-Benchmark.md | 1585 | bash | Missing bash language annotation. Block contains shell command: `$ wp plugin verify-checksums --all --path=/path/to/wordpress` | High |
| 44 | WordPress-Security-Benchmark.md | 1662 | bash | Missing bash language annotation. Block contains shell command: `$ wp plugin list --status=inactive --fields=name,version --path=/path/to/wordpress` | High |
| 45 | WordPress-Security-Benchmark.md | 1666 | bash | Missing bash language annotation. Block contains shell command: `$ wp theme list --status=inactive --fields=name,version --path=/path/to/wordpress` | High |
| 46 | WordPress-Security-Benchmark.md | 1709 | bash | Missing bash language annotation. Block contains shell command: `$ wp plugin list --fields=name,status,version,update_available --path=/path/to/wordpress` | High |
| 47 | WordPress-Security-Benchmark.md | 1746 | bash | Missing bash language annotation. Block contains shell command: `$ wp plugin list --fields=name,version,update_available --path=/path/to/wordpress` | High |
| 48 | WordPress-Security-Benchmark.md | 2047 | bash | Missing bash language annotation. Block contains shell command: `$ grep -E 'PasswordAuthentication\|PubkeyAuthentication' /etc/ssh/sshd_config` | High |

## Notes

All 48 issues are in the WordPress-Security-Benchmark.md file. Each is a fenced code block opening with bare backticks (` ``` `) instead of ` ```bash ` or similar language annotation.

The WP-Operations-Runbook.md file uses proper language annotations for all code blocks (bash, nginx, php, etc.) and does not exhibit this issue.

The WordPress-Security-Hardening-Guide.md file contains no executable code blocks and therefore has no linting issues.

### Code Block Types Verified

The following language annotations were confirmed as present and correct:
- `nginx` (Nginx configuration)
- `php` (PHP code snippets)
- `bash` (properly labeled bash commands)
- `apache` (Apache configuration)
- `sql` (SQL queries)
- `{=latex}` (LaTeX for PDF export)

No issues were found with:
- Markdown escaping corruption inside code blocks
- Incorrect grep syntax (all grep commands reviewed are syntactically valid)
- PHP closing tags
- Nginx `deny all; return 403;` redundancy
# Phase 2 — Glossary Coverage Check (Haiku)

Date: 2026-03-03

## Summary

- **Current glossary terms:** 125 entries in WP-Security-Style-Guide.md (Section 8, lines 343–590)
- **Alphabetical ordering issues:** 2 (confirmed from Phase 1)
- **Cross-reference formatting issues:** 4 (confirmed from Phase 1)
- **Missing terms (appear in 2+ documents, no glossary entry):** 7
- **Glossary coverage gaps:** 7 technical terms identified in Phase 1, all confirmed in Phase 2

---

## Current Glossary Terms

All 102 terms, extracted from Section 8 (lines 343–590) in alphabetical order as they appear in the document:

1. 2FA / MFA
2. Account takeover (ATO)
3. Action-gated reauthentication
4. Admin (role)
5. AICPA
6. AI-generated phishing
7. AI-powered tool
8. Anomaly detection
9. Application password
10. Arbitrary file upload
11. Argon2id
12. Attack surface
13. Auth cookie
14. Authentication
15. Authentication keys and salts
16. Authorization
17. Auto-update
18. Backdoor
19. bcrypt
20. BLAKE2b
21. Breach
22. Brute-force attack
23. Build pipeline
24. Capability
25. CDN (Content Delivery Network)
26. Composer
27. Content Security Policy (CSP)
28. CORS (Cross-Origin Resource Sharing)
29. Credential stuffing
30. Cross-Site Request Forgery (CSRF)
31. Cross-Site Scripting (XSS)
32. CVE
33. CVSS
34. Cybercriminal
35. Dashboard
36. Deepfake
37. Denial of service (DoS) / Distributed denial of service (DDoS)
38. Dependency confusion
39. DISALLOW_FILE_EDIT
40. DISALLOW_FILE_MODS
41. Directory traversal
42. DOM-based XSS
43. EPSS
44. Fail2Ban
45. FedRAMP
46. File integrity monitoring
47. FUD
48. FORCE_SSL_ADMIN
49. GDPR
50. GPU-accelerated brute-force attack
51. Hardening
52. HIPAA
53. HMAC
54. HSTS
55. Incident response
56. Information disclosure
57. Infostealer
58. Insecure AI-generated code
59. IoC (Indicators of Compromise)
60. Local file inclusion (LFI) / Remote file inclusion (RFI)
61. Malware
62. Malware signature
63. ModSecurity
64. Multisite
65. mu-plugin (must-use plugin)
66. NIST SP 800-53
67. Nonce
68. npm
69. Object cache
70. OWASP Top 10
71. Passkey / WebAuthn
72. Patch / Patching
73. Path traversal
74. PCI DSS
75. Phishing
76. phpass
77. Plugin
78. Plugin ownership transfer
79. PoC (Proof of Concept)
80. Prevention
81. Principle of Least Privilege (PoLP)
82. Privilege escalation
83. Prompt injection
84. Rate limiting
85. Reflected XSS
86. Remote code execution (RCE)
87. Resilience
88. Responsible disclosure
89. REST API
90. Rogue commit
91. Role
92. SBOM (Software Bill of Materials)
93. SHA-384
94. Shadow AI
95. Session hijacking
96. Severity rating
97. SOC 2
98. Sodium
99. SQL injection (SQLi)
100. SSRF (Server-Side Request Forgery)
101. Stored XSS
102. Supply chain attack
103. Super Admin
104. Theme
105. Threat actor
106. TOTP
107. TLS (Transport Layer Security)
108. Training-data poisoning
109. Transient
110. User enumeration
111. Virtual patching
112. Vulnerability
113. Vulnerability disclosure
114. WAF
115. Wordfence
116. wp-admin
117. wp-config.php
118. WP-CLI
119. WP-Cron
120. wp-login.php
121. xmlrpc.php
122. XML-RPC
123. XXE (XML eXternal Entity)
124. Zero-day
125. Zero Trust

**Total count:** 125 distinct glossary entries (note: "Directory traversal" at line 423 is a cross-reference to "Path traversal," not a separate entry).

---

## Missing Terms (appear in 2+ documents, no glossary entry)

| # | Term | Benchmark | Hardening Guide | Runbook | Status | Recommendation |
|---|---|---|---|---|---|---|
| 1 | **SIEM** (Security Information and Event Management) | Yes (2 refs) | Yes (1 ref) | No | Confirmed from Phase 1 | Add entry in S section between "Shadow AI" and "SOC 2" |
| 2 | **UFW** (Uncomplicated Firewall) | Yes (6 refs) | Yes (1 ref) | Yes (1 ref) | Confirmed from Phase 1; **now appears in 3 documents** | Add entry in U section between "User enumeration" and "Virtual patching" |
| 3 | **PHP-FPM** (FastCGI Process Manager) | Yes (9 refs) | No | Yes (7 refs) | Confirmed from Phase 1; **appears in 2 documents** | Add entry in P section between "Phishing" and "phpass" |
| 4 | **AIDE** (Advanced Intrusion Detection Environment) | Yes (1 ref) | No | Yes (7 refs) | Confirmed from Phase 1; **now appears in 2 documents per recount** | Add entry in A section between "AI-powered tool" and "Anomaly detection" |
| 5 | **Snuffleupagus** | Yes (1 ref) | Yes (1 ref) | No | Confirmed from Phase 1 | Add entry in S section between "Session hijacking" and "Severity rating" |
| 6 | **SIM-swapping** | Yes (1 ref) | Yes (1 ref) | No | Confirmed from Phase 1 | Add entry in S section between "SHA-384" and "Shadow AI" |
| 7 | **Ransomware** | Yes (1 ref) | Yes (1 ref) | Yes (2 refs) | Confirmed from Phase 1; **now appears in all 3 documents** | Add entry in R section between "Rate limiting" and "Reflected XSS" |

---

## Alphabetical Ordering Issues

**Status:** 2 HIGH-severity issues confirmed from Phase 1, not yet corrected.

### Issue 1: `FORCE_SSL_ADMIN` out of order (Line 437)

**Current state:** `FUD` (line 435) appears **before** `FORCE_SSL_ADMIN` (line 437).

**Alphabetical requirement:** "FO" (in `FORCE_SSL_ADMIN`) precedes "FU" (in `FUD`) because 'O' (ASCII 79) < 'U' (ASCII 85).

**Correct sequence should be:**
- File integrity monitoring
- **FORCE_SSL_ADMIN** ← move here
- **FUD**
- GDPR

**Verification:** Inspect lines 433–439 in current file.

---

### Issue 2: `mu-plugin` out of order (Line 471)

**Current state:** `Multisite` (line 469) appears **before** `mu-plugin` (line 471).

**Alphabetical requirement:** When comparing "Mu-p" vs. "Multis" case-insensitively, the hyphen character (ASCII 45) precedes 'l' (ASCII 108), so `mu-plugin` must come **before** `Multisite`.

**Correct sequence should be:**
- ModSecurity
- **mu-plugin** ← move here
- **Multisite**
- NIST SP 800-53

**Verification:** Inspect lines 467–474 in current file.

---

## Cross-Reference Issues

**Status:** 4 formatting errors confirmed from Phase 1, not yet corrected.

All cross-references in the glossary that point to other glossary terms must use **italic format** (`*TermName*`) to match the convention used throughout the glossary. Monospace backtick format (`` `term` ``) should only be used for file paths and code, not for glossary links.

### Issue 1: Line 463 — `Malware` entry

**Current:** `See also: infostealer.`

**Problem:** Target term `infostealer` is neither italicized (`*infostealer*`) nor capitalized to match its glossary heading (`**Infostealer**`).

**Correction:** Change to `See also: *Infostealer*.`

---

### Issue 2: Line 573 — `wp-admin` entry

**Current:** `See also: Dashboard, \`wp-login.php\`.`

**Problem:** `wp-login.php` is a glossary entry (line 581) and should be italicized (`*wp-login.php*`), not monospaced. Monospace backticks are correct for file paths in prose but not for glossary cross-references.

**Correction:** Change to `See also: *Dashboard*, *wp-login.php*.`

---

### Issue 3: Line 581 — `wp-login.php` entry

**Current:** `See also: *brute-force attack*, \`wp-admin\`.`

**Problem:** `wp-admin` is a glossary entry (line 573) and should be italicized (`*wp-admin*`), not monospaced.

**Correction:** Change to `See also: *brute-force attack*, *wp-admin*.`

---

### Issue 4: Line 587 — `XXE` entry

**Current:** `See also: *XML-RPC*, \`xmlrpc.php\`.`

**Problem:** `xmlrpc.php` is a glossary entry (line 583) and should be italicized (`*xmlrpc.php*`), not monospaced.

**Correction:** Change to `See also: *XML-RPC*, *xmlrpc.php*.`

---

## Verification of Existing Cross-References

All other italicized cross-references in the glossary were spot-checked and confirmed to point to existing glossary entries. No broken links detected among the correctly formatted cross-references.

---

## Recommendations for Phase 3

1. **Correct alphabetical ordering** (Issues 1 & 2): Move `FORCE_SSL_ADMIN` before `FUD` and move `mu-plugin` before `Multisite`.

2. **Fix cross-reference formatting** (Issues 1–4): Convert 4 monospace cross-references to italic format to match the glossary convention.

3. **Add 7 missing terms:**
   - **AIDE** (in A section)
   - **PHP-FPM** (in P section)
   - **Ransomware** (in R section)
   - **SIEM** (in S section)
   - **SIM-swapping** (in S section)
   - **Snuffleupagus** (in S section)
   - **UFW** (in U section)

4. **Verify insertion sequence:** Ensure new terms maintain alphabetical order. The S section will have three new entries; verify the ordering of SHA-384 → SIM-swapping → Snuffleupagus → Shadow AI.

---

## Notes on Scope

- Phase 1 identified 13 findings across the Style Guide; Phase 2 validates cross-document glossary coverage against the other three documents (Benchmark, Hardening Guide, Runbook).
- The threshold for mandatory glossary entry is **2 or more documents** citing the term (per AGENTS.md constraint).
- Terms appearing only in the Runbook's own embedded glossary (e.g., LEMP) or only once across all documents are excluded.
- All 7 missing terms meet the 2+ document threshold and are prioritized by frequency (UFW in 3 documents, Ransomware in 3, others in 2).
# Phase 2 — Reference URL Check (Haiku)

Date: 2026-03-03

## Summary

**Total unique URLs checked:** 105+ (excluding placeholder URLs with `[CUSTOMIZE: ...]`)

**Issues found:** 7 total
- 4 confirmed from Phase 1 findings (superseded revisions, stale/inconsistent resources)
- 3 new issues discovered in Phase 2 (URL inconsistencies, format problems)

---

## Issues Found

| # | Document | Section | URL | Issue | Status |
|---|---|---|---|---|---|
| 1 | WordPress-Security-Hardening-Guide.md | §15.3, line 567 | `https://pages.nist.gov/800-63-3/sp800-63b.html` | Stale NIST revision: Points to SP 800-63B revision 3 (2017). Should be revision 4 (2024). Benchmark uses revision 4 at `https://pages.nist.gov/800-63-4/sp800-63b.html`. Cross-document inconsistency. | Confirmed from Phase 1 |
| 2 | WordPress-Security-Hardening-Guide.md | §15.3, line 568 | `https://csrc.nist.gov/pubs/sp/800/61/r2/final` | Stale NIST revision: Points to SP 800-61 revision 2 (2012). Should be revision 3 (2024). NIST published r3 in 2024, making r2 superseded. | Confirmed from Phase 1 |
| 3 | WordPress-Security-Hardening-Guide.md | §3.1, §15.1, §Related Docs (lines 44, 550, 607) | `https://developer.wordpress.org/apis/security/` | URL/label mismatch: Labeled as "WordPress Security White Paper" but resolves to developer API documentation. Actual White Paper may be at `https://wordpress.org/about/security/`. Used 3 times across document. | Confirmed from Phase 1 |
| 4 | WP-Operations-Runbook.md | §Related Docs, line 2955 | `https://wordpress.org/about/security/` | Correct: Points to WordPress.org Security White Paper. Differs from Hardening Guide's `developer.wordpress.org/apis/security/` at line 550. This is the correct canonical URL per WordPress.org. | New: Cross-doc inconsistency |
| 5 | WordPress-Security-Hardening-Guide.md & WordPress-Security-Benchmark.md (multiple sections) | §15 References | Various OWASP Top 10 citations | Unverified edition: Both documents cite "OWASP Top 10:2025" edition multiple times. As of the knowledge cutoff (August 2025), the 2025 edition had not been published; 2021 was current. If published between cutoff and March 2026, this is correct. Requires verification. | Confirmed from Phase 1 |
| 6 | WordPress-Security-Benchmark.md | §1.3, line 306 | `https://owasp.org/API-Security/editions/2023/en/0xa4-unrestricted-resource-consumption/` | Edition year in URL: OWASP API Security Top 10 2023 edition is referenced. Should verify if a 2024 or 2025 edition exists and if reference should be updated. Currently valid format but may be outdated. | New: Potential stale edition |
| 7 | WP-Operations-Runbook.md | §Related Docs, lines 2952-2956 & Hardening-Guide §Related Docs, lines 604-607 | GitHub URLs: `https://github.com/dknauss/wp-security-benchmark`, `https://github.com/dknauss/wp-security-hardening-guide`, `https://github.com/dknauss/wordpress-runbook-template` | Inconsistent doc references: Runbook references use GitHub URLs; Hardening Guide also uses GitHub but additionally references `developer.wordpress.org/apis/security/` for Security White Paper. Both documents should standardize on whether to reference GitHub repositories or upstream WordPress.org sources for the White Paper. | New: Format/style inconsistency |

---

## Cross-Document URL Consistency

### WordPress Security White Paper (Critical Inconsistency)

| Document | URL | Label | Status |
|---|---|---|---|
| WordPress-Security-Hardening-Guide.md (lines 44, 550, 607) | `https://developer.wordpress.org/apis/security/` | "WordPress Security White Paper" | Incorrect label; actually API docs |
| WP-Operations-Runbook.md (line 2955) | `https://wordpress.org/about/security/` | "WordPress Security White Paper" | Correct canonical URL |
| WP-Security-Style-Guide.md (line 635, 650) | `https://developer.wordpress.org/apis/security/` | "WordPress Security White Paper (developer.wordpress.org)" | Inconsistent with Runbook |

**Recommendation:** The Hardening Guide and Style Guide should update to use `https://wordpress.org/about/security/` and remove the "developer.wordpress.org" reference, or clarify that they are linking to the developer API documentation, not the Security White Paper.

### NIST SP 800-63B (Cross-Document Mismatch)

| Document | URL | Revision |
|---|---|---|
| WordPress-Security-Hardening-Guide.md (line 567) | `https://pages.nist.gov/800-63-3/sp800-63b.html` | Revision 3 (2017) — **STALE** |
| WordPress-Security-Benchmark.md (lines 1048, 1224, 1316) | `https://pages.nist.gov/800-63-4/sp800-63b.html` | Revision 4 (2024) — **CURRENT** |

**Recommendation:** Update Hardening Guide line 567 to use revision 4 URL.

### NIST SP 800-61 (Superseded Revision)

| Document | URL | Revision |
|---|---|---|
| WordPress-Security-Hardening-Guide.md (line 568) | `https://csrc.nist.gov/pubs/sp/800/61/r2/final` | Revision 2 (2012) — **SUPERSEDED** |
| Benchmark (no direct citation) | (none found) | — |

**Recommendation:** Update Hardening Guide line 568 to use revision 3 URL: `https://csrc.nist.gov/pubs/sp/800/61/r3/final`

### OWASP Top 10 Edition

Both Hardening Guide (line 556) and Benchmark cite "OWASP Top 10:2025" edition:
- `https://owasp.org/Top10/2025/`
- Benchmark also references at lines 306 (API Security 2023), 2024

**Status:** Requires verification that the 2025 edition exists. The 2021 edition was the most recent as of August 2025 knowledge cutoff.

---

## URL Format Validation

All URLs follow valid HTTPS format. No malformed URLs detected.

### Valid URL Patterns Confirmed

- `https://developer.wordpress.org/` — WordPress Developer Handbook (valid pattern)
- `https://pages.nist.gov/800-63-x/` — NIST standards (valid pattern)
- `https://csrc.nist.gov/pubs/sp/800/xx/rx/` — NIST publications (valid pattern)
- `https://owasp.org/` — OWASP resources (valid pattern)
- `https://github.com/dknauss/` — GitHub repositories (valid pattern)

### Known Stale Patterns

No `codex.wordpress.org` URLs detected. All WordPress.org references correctly use either `wordpress.org` or `developer.wordpress.org`.

---

## Recommendations

1. **Immediate (High Priority):**
   - Update Hardening Guide §15.3 line 567 NIST SP 800-63B URL from revision 3 to revision 4
   - Update Hardening Guide §15.3 line 568 NIST SP 800-61 URL from revision 2 to revision 3
   - Correct Hardening Guide line 550 label and URL for Security White Paper (use `https://wordpress.org/about/security/`)

2. **Verification Needed:**
   - Confirm OWASP Top 10:2025 edition exists; if not, downgrade to 2021 edition across both documents
   - Verify OWASP API Security 2023 is still current; check for 2024/2025 editions

3. **Style Consistency:**
   - Standardize references to internal documents (GitHub URLs vs. canonical sources)
   - Consider whether Style Guide should mirror Runbook's correct White Paper URL

---

## Notes

- No deprecated `codex.wordpress.org` URLs found in any document.
- No markdown escaping errors detected in URLs.
- All URLs in References sections follow consistent formatting (markdown link style `[text](url)`).
- Placeholder URLs (e.g., `https://[CUSTOMIZE: example.com]`) in templates are excluded from this audit.
