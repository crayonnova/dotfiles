#!/usr/bin/env bash

# Per-monitor workspace stacks, the way niri does it.
#
# niri gives every monitor its own INDEPENDENT workspace strip: "workspace 1"
# exists once per output, and switching only ever moves the focused monitor.
# Hyprland's model is the opposite — one GLOBAL list of workspaces, each of
# which is assigned to a monitor. That is why a plain `workspace 1` bind yanks
# workspace 1 over to whatever monitor you happen to be on, and why the laptop
# ended up as "1" and the Xiaomi as "2".
#
# The fix is to carve the global list into one fixed band per monitor and make
# the binds monitor-relative: this script reads the focused monitor, adds that
# monitor's base offset, and dispatches the absolute workspace number. So
# Alt+1 means "slot 1 of the monitor I am looking at", which is exactly the
# niri semantics.
#
#   DP-1  (Xiaomi, left)  -> band  1.. 9   (base  0)
#   eDP-1 (laptop, right) -> band 11..19   (base 10)
#
# The `workspace = N, monitor:X` rules in hyprland.conf pin each band to its
# monitor, so the bands stay put across hotplug and never bleed into each
# other. Keep MONITOR_BASES below in sync with those rules.
#
# The upstream hyprsplit plugin does this natively and would be the better
# answer, but as of Hyprland 0.56 it does not build: it needs
# managers/animation/DesktopAnimationManager.hpp, which 0.56 removed.
#
# Usage: hypr-ws.sh switch|move|movesilent N   (N = 1..9, monitor-relative)
#        hypr-ws.sh next|prev|movenext|moveprev
#        hypr-ws.sh reconcile

set -euo pipefail

# monitor name -> first workspace of its band, minus one.
declare -A MONITOR_BASES=(
    ["DP-1"]=0
    ["eDP-1"]=10
)
default_base=0

# Slots per monitor. Must match the number of `workspace =` rules per band.
slots=9

action=${1:?usage: hypr-ws.sh switch|move|movesilent|next|prev|movenext|moveprev [N]}

# `workspace = N, monitor:X` rules are only consulted when a workspace is first
# CREATED. A workspace that already exists keeps whatever monitor it is on, so
# after `hyprctl reload` — or after unplugging a monitor, which evacuates its
# workspaces onto the survivor and does not send them back on replug — a band
# can end up straddling the wrong output. Dispatching into such a workspace
# drags focus to the wrong monitor, which then poisons the base offset for the
# next keypress. `reconcile` puts every band member back where its rule says.
if [ "$action" = reconcile ]; then
    present=$(hyprctl monitors -j | jq -r '.[].name')
    ids=$(hyprctl workspaces -j | jq -r '.[].id')
    for name in "${!MONITOR_BASES[@]}"; do
        # Skip a monitor that is not plugged in; its band stays parked on
        # whatever output is currently hosting it until it comes back.
        grep -qxF "$name" <<<"$present" || continue
        b=${MONITOR_BASES[$name]}
        for id in $ids; do
            if [ "$id" -gt "$b" ] && [ "$id" -le $((b + slots)) ]; then
                hyprctl dispatch moveworkspacetomonitor "$id" "$name" >/dev/null
            fi
        done
    done
    exit 0
fi

mon=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
base=${MONITOR_BASES[$mon]:-$default_base}

# Where the focused monitor currently sits inside its own band. A workspace
# from outside the band (a leftover special/named one) reads as slot 1 so the
# relative moves still have somewhere sane to start from.
current=$(hyprctl activeworkspace -j | jq -r '.id')
slot=$((current - base))
if [ "$slot" -lt 1 ] || [ "$slot" -gt "$slots" ]; then
    slot=1
fi

case "$action" in
    switch | move | movesilent)
        n=${2:?"$action needs a workspace number"}
        if [ "$n" -lt 1 ] || [ "$n" -gt "$slots" ]; then
            echo "hypr-ws: workspace $n out of range 1..$slots" >&2
            exit 1
        fi
        ;;
    next | movenext)
        # Clamp at the end of the band rather than wrapping or spilling onto
        # the neighbouring monitor — niri stops at the last workspace too.
        n=$((slot + 1))
        [ "$n" -gt "$slots" ] && n=$slots
        ;;
    prev | moveprev)
        n=$((slot - 1))
        [ "$n" -lt 1 ] && n=1
        ;;
    *)
        echo "hypr-ws: unknown action '$action'" >&2
        exit 1
        ;;
esac

target=$((base + n))

case "$action" in
    switch | next | prev)
        hyprctl dispatch workspace "$target"
        ;;
    move | movenext | moveprev)
        # Follow the window, matching niri's move-column-to-workspace.
        hyprctl dispatch movetoworkspace "$target"
        ;;
    movesilent)
        hyprctl dispatch movetoworkspacesilent "$target"
        ;;
esac
