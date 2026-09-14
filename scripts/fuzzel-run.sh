#!/usr/bin/env bash

# Prompt for a command with fuzzel, then run it in a disposable floating
# terminal (app-id "scratchterm", floated by a niri window-rule).
#
# The terminal closes as soon as the command exits successfully; on failure it
# waits for a keypress so the error stays readable.

set -euo pipefail

fuzzel_bin=${FUZZEL_BIN:-fuzzel}
term_bin=${TERM_BIN:-alacritty}
history_file=${FUZZEL_RUN_HISTORY:-${XDG_CACHE_HOME:-$HOME/.cache}/fuzzel-run.history}
history_limit=40

# Always-offered entries, shown after the most recent history.
favourites=(
	btop
	edot
	lazygit
	"nh home switch ~/dotfiles"
	"journalctl -xe --user"
)

trim() {
	local value=$1
	value=${value#"${value%%[![:space:]]*}"}
	value=${value%"${value##*[![:space:]]}"}
	printf '%s' "$value"
}

mkdir -p "$(dirname "$history_file")"
touch "$history_file"

# Newest history first, then favourites, dropping blanks and duplicates.
menu=$( { tac "$history_file"; printf '%s\n' "${favourites[@]}"; } | awk 'NF && !seen[$0]++')

cmd=$(printf '%s\n' "$menu" |
	"$fuzzel_bin" --dmenu --prompt='run> ' --placeholder='btop' --lines=8 --width=50)
cmd=$(trim "$cmd")

if [[ -z $cmd ]]; then
	exit 0
fi

# Record the command, keeping the last occurrence of each and capping the file.
{
	printf '%s\n' "$cmd" >>"$history_file"
	tac "$history_file" | awk 'NF && !seen[$0]++' | head -n "$history_limit" | tac >"$history_file.tmp"
	mv "$history_file.tmp" "$history_file"
}

# bash -i so shell functions and aliases from ~/.bashrc (edot, ...) resolve;
# a non-interactive shell hits the guard at the top of ~/.bashrc and finds them
# undefined.
exec "$term_bin" --class scratchterm -e bash -ic "$(
	cat <<EOF
$cmd
rc=\$?
if [ "\$rc" -ne 0 ]; then
	printf '\n[exit %s] press any key to close…' "\$rc"
	read -rsn1
fi
EOF
)"
