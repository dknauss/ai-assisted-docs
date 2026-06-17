#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[toolchain] %s %s\n' "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" "$*"
}

retry() {
  local attempts="$1" delay="$2"
  shift 2
  local n=1
  until "$@"; do
    if [ "$n" -ge "$attempts" ]; then
      log "command failed after ${attempts} attempts: $*"
      return 1
    fi
    log "command failed (attempt ${n}/${attempts}); retrying in ${delay}s: $*"
    sleep "$delay"
    n=$((n + 1))
  done
}

download() {
  local url="$1" output="$2"
  retry 3 5 curl -fL --retry 3 --retry-delay 2 --retry-connrefused -o "$output" "$url"
}

export DEBIAN_FRONTEND=noninteractive
mkdir -p "$HOME/.local/bin" "$HOME/.cache/Tectonic" "$HOME/.pandoc/templates"
echo "$HOME/.local/bin" >> "$GITHUB_PATH"
{
  echo "TECTONIC_CACHE_DIR=$HOME/.cache/Tectonic"
  echo "XDG_CACHE_HOME=$HOME/.cache"
} >> "$GITHUB_ENV"

log "installing lightweight system packages"
retry 3 10 timeout 300 sudo apt-get update -o Acquire::Retries=3 -o Dpkg::Use-Pty=0 -qq
retry 3 15 timeout 900 sudo apt-get install -y --no-install-recommends \
  fontconfig \
  fonts-noto-core \
  fonts-noto-extra \
  default-jre-headless \
  epubcheck \
  poppler-utils \
  unzip
fc-cache -f >/dev/null 2>&1 || true

want_pandoc="${PANDOC_VERSION:-3.6.3}"
if ! command -v pandoc >/dev/null 2>&1 || ! pandoc --version | head -n1 | grep -q " $want_pandoc"; then
  log "installing pandoc ${want_pandoc}"
  deb="/tmp/pandoc-${want_pandoc}-1-amd64.deb"
  download "https://github.com/jgm/pandoc/releases/download/${want_pandoc}/pandoc-${want_pandoc}-1-amd64.deb" "$deb"
  sudo dpkg -i "$deb"
  rm -f "$deb"
else
  log "pandoc ${want_pandoc} already present"
fi

want_tectonic="${TECTONIC_VERSION:-latest}"
need_tectonic=1
if command -v tectonic >/dev/null 2>&1; then
  if [ "$want_tectonic" = "latest" ]; then
    need_tectonic=0
  elif tectonic --version 2>/dev/null | grep -q "$want_tectonic"; then
    need_tectonic=0
  fi
fi

if [ "$need_tectonic" -eq 1 ]; then
  log "installing tectonic (${want_tectonic})"
  release_json="$(mktemp)"
  if [ "$want_tectonic" = "latest" ]; then
    retry 3 5 curl -fsSL -H 'Accept: application/vnd.github+json' \
      https://api.github.com/repos/tectonic-typesetting/tectonic/releases/latest -o "$release_json"
  else
    retry 3 5 curl -fsSL -H 'Accept: application/vnd.github+json' \
      "https://api.github.com/repos/tectonic-typesetting/tectonic/releases/tags/tectonic%40${want_tectonic}" -o "$release_json"
  fi
  asset_url="$(python3 - <<'PY' "$release_json"
import json, sys
assets = json.load(open(sys.argv[1]))['assets']
for asset in assets:
    name = asset.get('name', '')
    if name.endswith('x86_64-unknown-linux-gnu.tar.gz'):
        print(asset['browser_download_url'])
        break
else:
    raise SystemExit('No linux x86_64 tectonic tarball found in release assets')
PY
)"
  rm -f "$release_json"
  tarball="$(mktemp --suffix=.tar.gz)"
  download "$asset_url" "$tarball"
  tmpdir="$(mktemp -d)"
  tar -xzf "$tarball" -C "$tmpdir"
  install -m 0755 "$(find "$tmpdir" -type f -name tectonic | head -n1)" "$HOME/.local/bin/tectonic"
  rm -rf "$tmpdir" "$tarball"
else
  log "tectonic already present"
fi

log "installing eisvogel template"
tmpdir_eis="$(mktemp -d)"
retry 3 5 bash -lc "curl -fsSL https://github.com/Wandmalfarbe/pandoc-latex-template/releases/latest/download/Eisvogel.tar.gz | tar -xz -C '$tmpdir_eis'"
find "$tmpdir_eis" -name '*.latex' -exec cp {} "$HOME/.pandoc/templates/" \;
rm -rf "$tmpdir_eis"

log "toolchain versions"
pandoc --version | head -n 2
tectonic --version
java -version 2>&1 | head -n 1 || true
epubcheck --version || true
log "tectonic cache dir: ${TECTONIC_CACHE_DIR:-$HOME/.cache/Tectonic}"
