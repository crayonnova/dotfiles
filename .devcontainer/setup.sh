#!/usr/bin/env bash
set -euo pipefail

export NIX_CONFIG="experimental-features = nix-command flakes"
nix run github:nix-community/home-manager -- switch --flake ".#vscode@codespaces" -b hmbackup
