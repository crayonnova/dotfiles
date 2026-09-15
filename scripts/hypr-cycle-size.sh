#!/usr/bin/env bash

# Cycle the focused window through niri's preset column widths / window heights.
#
# Hyprland has no notion of preset sizes, so this reimplements niri's
# `switch-preset-column-width` / `switch-preset-window-height`: pick the first
# preset strictly larger than the current size, wrapping around to the smallest.
# Presets match `layout { preset-column-widths { } }` in the niri config.
#
# NOTE: `width` is no longer bound to anything. Since the config moved to
# Hyprland's native scrolling layout, column widths are owned by the layout
# itself and Mod+R uses `layoutmsg colresize +conf`, which cycles
# `scrolling:explicit_column_widths`. Only `height` and `reset` are still in
# use — the scrolling layout has no preset mechanism for window heights within
# a column. `width` is kept so the script still works if layout = dwindle.
#
# Usage: hypr-cycle-size.sh width|height|reset

set -euo pipefail

presets=(0.33333 0.5 0.66667)
default=0.5
tolerance=0.03

axis=${1:-width}

win=$(hyprctl activewindow -j)
[ "$(jq -r '.address // "null"' <<<"$win")" != "null" ] || exit 0

mon=$(hyprctl monitors -j | jq -c '.[] | select(.focused == true)')

# Logical (scaled) working area of the focused monitor, minus reserved bar space.
read -r usable_w usable_h <<<"$(jq -r '
    (.width / .scale) - (.reserved[0] + .reserved[2]) as $w |
    (.height / .scale) - (.reserved[1] + .reserved[3]) as $h |
    "\($w) \($h)"' <<<"$mon")"

read -r cur_w cur_h <<<"$(jq -r '"\(.size[0]) \(.size[1])"' <<<"$win")"

case "$axis" in
    width)  usable=$usable_w; cur=$cur_w ;;
    height) usable=$usable_h; cur=$cur_h ;;
    reset)
        target=$(awk -v u="$usable_h" -v f="$default" 'BEGIN { printf "%d", u * f }')
        hyprctl dispatch resizeactive exact "$cur_w" "$target" >/dev/null
        exit 0
        ;;
    *)
        echo "usage: ${0##*/} width|height|reset" >&2
        exit 64
        ;;
esac

# First preset strictly larger than the current fraction, else wrap to the first.
next=$(awk -v cur="$cur" -v usable="$usable" -v tol="$tolerance" \
    -v list="${presets[*]}" 'BEGIN {
        frac = cur / usable
        n = split(list, p, " ")
        for (i = 1; i <= n; i++)
            if (p[i] > frac + tol) { print p[i]; exit }
        print p[1]
    }')

target=$(awk -v u="$usable" -v f="$next" 'BEGIN { printf "%d", u * f }')

case "$axis" in
    width)  hyprctl dispatch resizeactive exact "$target" "$cur_h" >/dev/null ;;
    height) hyprctl dispatch resizeactive exact "$cur_w" "$target" >/dev/null ;;
esac
