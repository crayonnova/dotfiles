#!/usr/bin/env bash

# Show the active Hyprland keybinds — a stand-in for niri's hotkey overlay
# (Mod+Shift+/), which Hyprland has no equivalent of.
#
# Binds declared with `bindd` carry a description, Hyprland's counterpart to
# niri's `hotkey-overlay-title`; the rest fall back to their dispatcher + args.

set -euo pipefail

fuzzel_bin=${FUZZEL_BIN:-fuzzel}

hyprctl binds -j | jq -r '
    def mods($m):
        [ if ($m / 1)   % 2 == 1 then "SHIFT" else empty end
        , if ($m / 4)   % 2 == 1 then "CTRL"  else empty end
        , if ($m / 8)   % 2 == 1 then "ALT"   else empty end
        , if ($m / 64)  % 2 == 1 then "SUPER" else empty end
        ] | join("+");

    map(select(.submap == ""))
    | map(
        (mods(.modmask) | if . == "" then "" else . + "+" end) as $m
        | ($m + (if .key == "" then "code:\(.keycode)" else .key end)) as $chord
        | (if (.description // "") != "" then .description
           else (.dispatcher + (if (.arg // "") != "" then " " + .arg else "" end))
           end) as $what
        | "\($chord)\t\($what)"
      )
    | .[]
' | column -t -s $'\t' | "$fuzzel_bin" --dmenu --prompt "binds " >/dev/null
