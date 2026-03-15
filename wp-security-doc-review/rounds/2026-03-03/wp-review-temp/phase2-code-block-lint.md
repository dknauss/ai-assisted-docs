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
