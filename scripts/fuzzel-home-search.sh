#!/usr/bin/env bash

set -euo pipefail

fuzzel_bin=${FUZZEL_BIN:-fuzzel}
open_bin=${OPEN_BIN:-xdg-open}

trim() {
	local value=$1
	value=${value#"${value%%[![:space:]]*}"}
	value=${value%"${value##*[![:space:]]}"}
	printf '%s' "$value"
}

urlencode() {
	local input=$1
	local output=
	local i ch hex

	LC_ALL=C
	for ((i = 0; i < ${#input}; i++)); do
		ch=${input:i:1}
		case "$ch" in
		[a-zA-Z0-9.~_-])
			output+=$ch
			;;
		' ')
			output+='%20'
			;;
		*)
			printf -v hex '%%%02X' "'$ch"
			output+=$hex
			;;
		esac
	done

	printf '%s' "$output"
}

query=$("$fuzzel_bin" --dmenu --prompt='home> ' --placeholder='!home ripgrep' --lines=0 --width=60)
query=$(trim "$query")

if [[ -z $query ]]; then
	exit 0
fi

if [[ $query == '!home' ]]; then
	exit 0
fi

if [[ $query == '!home '* ]]; then
	query=${query#!home }
fi

query=$(trim "$query")

if [[ -z $query ]]; then
	exit 0
fi

if [[ $query == '!gh '* ]]; then
	query=${query#!gh }
	query=$(trim "$query")
	if [[ $query == */* ]]; then
		"$open_bin" "https://github.com/${query}"
	else
		encoded_query=$(urlencode "$query")
		"$open_bin" "https://github.com/search?q=${encoded_query}"
	fi
else
	encoded_query=$(urlencode "$query")
	"$open_bin" "https://search.nixos.org/packages?channel=unstable&type=packages&query=${encoded_query}"
	"$open_bin" "https://home-manager-options.extranix.com/?release=master&query=${encoded_query}"
fi
