#!/usr/bin/env bash
# List home-manager packages (name, version, store location) and flag which are
# behind nixpkgs-unstable HEAD. Works by re-evaluating your OWN home.packages
# list against a swapped nixpkgs input — no attr-name guessing, uses your overlays.
#
# Usage: hm-outdated.sh [--md] [user@host] [flake-dir]
#   --md            emit a GitHub-flavored markdown table (for saving to a file)
#                   instead of the aligned plain-text table shown by default.
#   defaults: user@host = "$USER@$(hostname)", flake-dir = dir of this script's repo
set -euo pipefail

MD=0
if [ "${1:-}" = "--md" ]; then MD=1; shift; fi

TARGET="${1:-$USER@$(hostname)}"
FLAKE="${2:-$(cd "$(dirname "$0")/.." && pwd)}"
ATTR=".#homeConfigurations.\"$TARGET\".config.home.packages"

apply='ps: map (p: { name = p.pname or p.name or "?"; version = p.version or ""; path = p.outPath; }) ps'

echo "Evaluating current versions ($TARGET)..." >&2
nix eval "$ATTR" --apply "$apply" --json > /tmp/hm-current.json

echo "Evaluating latest versions against nixpkgs-unstable (slower)..." >&2
nix eval "$ATTR" --override-input nixpkgs github:NixOS/nixpkgs/nixpkgs-unstable \
  --apply "$apply" --json > /tmp/hm-latest.json

# Shared join+compare, sorted with outdated first. Produces one row per package.
JOIN='
  (input | INDEX(.name)) as $cur
  | (input | INDEX(.name)) as $lat
  | [ $cur[] | . as $c | {name, version, path,
        latest: ($lat[$c.name].version // "?"),
        outdated: (($lat[$c.name].version // $c.version) != $c.version) } ]
  | sort_by([ (.outdated|not), .name ]) '

SUMMARY=$(jq -rn "$JOIN | \"Outdated: \([ .[] | select(.outdated) ] | length) / \(length) packages\"" \
  /tmp/hm-current.json /tmp/hm-latest.json)

if [ "$MD" = 1 ]; then
  # GitHub-flavored markdown (alignment handled by the renderer).
  jq -rn "$JOIN
    | \"| St | Package | Installed | Latest (unstable) | Store location |\",
      \"|----|---------|-----------|-------------------|----------------|\",
      (.[] | \"| \(if .outdated then \"⬆\" else \"\" end) | \(.name) | \(.version) | \(.latest) | \`\(.path)\` |\")" \
    /tmp/hm-current.json /tmp/hm-latest.json
  echo
  echo "$SUMMARY"
else
  # Plain text, tab-separated; awk computes per-column widths so it aligns in any
  # terminal regardless of width or markdown rendering. ASCII '*' marks updates
  # (avoids multibyte-glyph width miscounting). Store location stays in the last
  # column, left-aligned, so it can run/wrap without disturbing the other columns.
  jq -rn "$JOIN
    | ([\"\", \"PACKAGE\", \"INSTALLED\", \"LATEST\", \"STORE LOCATION\"] | @tsv),
      (.[] | [ (if .outdated then \"*\" else \"\" end), .name, .version, .latest, .path ] | @tsv)" \
    /tmp/hm-current.json /tmp/hm-latest.json \
  | awk -F'\t' '
      { for (i=1;i<=NF;i++) if (length($i)>w[i]) w[i]=length($i); rows[NR]=$0; nr=NR }
      END {
        for (r=1;r<=nr;r++) {
          n=split(rows[r],a,"\t"); line=""
          for (i=1;i<=n;i++) line = line (i<n ? sprintf("%-*s  ", w[i], a[i]) : a[i])
          print line
          if (r==1) { rule=""; for (i=1;i<=n;i++) { d=""; for(j=0;j<w[i];j++) d=d"-"; rule=rule (i<n ? d"  " : d) } print rule }
        }
      }'
  echo
  echo "$SUMMARY"
  echo "(* = update available in nixpkgs-unstable)"
fi
