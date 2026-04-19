#!/usr/bin/env bash

set -euo pipefail

cfg=/etc/nixos/configuration.nix

{
  printf 'user\tconfig\texists\tuid\tgid\tgid_label\thome\tshell\tdesc\n'
  awk -F '\t' '
    FNR == NR {
      cfg_state[$1] = $2
      cfg_desc[$1] = $3
      users[$1] = 1
      next
    }
    FILENAME == ARGV[2] {
      split($0, a, ":")
      if (a[3] >= 1000 && a[7] !~ /(nologin|false)$/) {
        exists[a[1]] = "yes"
        uid[a[1]] = a[3]
        gid[a[1]] = a[4]
        home[a[1]] = a[6]
        shell[a[1]] = a[7]
        users[a[1]] = 1
      }
      next
    }
    {
      split($0, g, ":")
      gname[g[3]] = g[1]
    }
    END {
      for (u in users) {
        printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
          u,
          (u in cfg_state ? cfg_state[u] : "absent"),
          (u in exists ? exists[u] : "no"),
          uid[u],
          gid[u],
          gname[gid[u]],
          home[u],
          shell[u],
          cfg_desc[u]
      }
    }
  ' <(
    awk '
      /^[[:space:]]*#/ && $0 !~ /^[[:space:]]*#?[[:space:]]*users\.users\./ { next }
      match($0, /^[[:space:]]*(#)?[[:space:]]*users\.users\.([[:alnum:]_.-]+)[[:space:]]*=[[:space:]]*\{/, m) {
        state = (m[1] == "#") ? "commented" : "active"
        user = m[2]
        desc = ""
        in_user = 1
        next
      }
      in_user && match($0, /^[[:space:]]*(#)?[[:space:]]*description[[:space:]]*=[[:space:]]*"([^"]*)"/, m) {
        desc = m[2]
        next
      }
      in_user && /^[[:space:]]*(#)?[[:space:]]*};[[:space:]]*$/ {
        print user "\t" state "\t" desc
        in_user = 0
      }
    ' "$cfg"
  ) <(getent passwd) <(getent group) | sort
} | column -t -s $'\t'
