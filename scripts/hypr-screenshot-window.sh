#!/usr/bin/env bash

# Screenshot the focused window — Hyprland's missing equivalent of niri's
# `screenshot-window`. Noctalia covers region and fullscreen; it has no
# window mode, so this crops grim to the focused window's geometry.
#
# Saves to the same location as niri's `screenshot-path` and copies to the
# clipboard, matching niri's behaviour of doing both.

set -euo pipefail

dir=${SCREENSHOT_DIR:-$HOME/Pictures/Screenshots}
file="$dir/Screenshot from $(date '+%Y-%m-%d %H-%M-%S').png"

mkdir -p "$dir"

geometry=$(hyprctl activewindow -j | jq -r '
    if .address == null then empty
    else "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"
    end')

if [ -z "$geometry" ]; then
    echo "no focused window" >&2
    exit 1
fi

grim -g "$geometry" "$file"
wl-copy --type image/png <"$file"
