#!/usr/bin/env bash

# Open a terminal in the working directory of the focused window.
#
# Hyprland port of the inline spawn-sh behind niri's Mod+D bind: take the
# focused window's pid, look at its first child that has a readable cwd (the
# shell running inside the terminal), and start there. Falls back to $HOME.

set -euo pipefail

term_bin=${TERM_BIN:-alacritty}

cwd="$HOME"
pid=$(hyprctl activewindow -j 2>/dev/null | jq -r '.pid // empty')

if [ -n "$pid" ] && [ "$pid" != "-1" ]; then
    for child in $(pgrep -P "$pid" 2>/dev/null || true); do
        if c=$(readlink "/proc/$child/cwd" 2>/dev/null) && [ -n "$c" ]; then
            cwd=$c
            break
        fi
    done
fi

exec "$term_bin" --working-directory "$cwd"
