#!/usr/bin/env bash
#
# nix-edit.sh — open a package's Nix definition in $EDITOR.
# Works around `nix edit` failing with "no physical path" on lazy-trees +
# tarball flakes (e.g. flakehub nixpkgs): it resolves meta.position via
# `nix eval` to a real /nix/store path and opens it at the right line.
# The file lives in the read-only Nix store, so this is for inspection.

set -uo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: nedit <installable>   e.g. nedit nixpkgs#hello" >&2
  exit 2
fi

# Default a bare attr (no flake ref) to the nixpkgs registry entry.
installable="$1"
[[ "$installable" == *"#"* ]] || installable="nixpkgs#${installable}"

pos=$(nix eval --raw --option lazy-trees false "${installable}.meta.position") || {
  echo "nedit: could not resolve meta.position for '${installable}'" >&2
  exit 1
}

file="${pos%:*}"
line="${pos##*:}"

exec "${EDITOR:-vi}" "+${line}" "${file}"
