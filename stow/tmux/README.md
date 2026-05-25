# tmux keybindings

Prefix: `C-a` (rebound from `C-b`). Send literal prefix with `C-a C-a`.

## Windows

| Key | Action |
|---|---|
| `prefix` `n` | New window |
| `prefix` `r` | Reload `~/.tmux.conf` |

## Panes — splitting

| Key | Action |
|---|---|
| `prefix` `\|` | Split horizontally (keeps current path) |
| `prefix` `-` | Split vertically (keeps current path) |

## Panes — navigation (no prefix, Vim-aware)

| Key | Action |
|---|---|
| `C-h` | Select pane left (or pass to Vim) |
| `C-j` | Select pane down (or pass to Vim) |
| `C-k` | Select pane up (or pass to Vim) |
| `C-l` | Select pane right (or pass to Vim) |

## Panes — resizing (repeatable, 300 ms)

| Key | Action |
|---|---|
| `prefix` `H` | Resize pane left by 5 |
| `prefix` `J` | Resize pane down by 5 |
| `prefix` `K` | Resize pane up by 5 |
| `prefix` `L` | Resize pane right by 5 |

## Copy mode (vi)

| Key | Action |
|---|---|
| `v` | Begin selection |
| `y` | Copy selection and cancel |

## Mouse

Mouse mode is on: scroll, select, and resize panes with the mouse.

## Unbound defaults

`C-b`, `c`, `n`, `p` are unbound from their tmux defaults.

## CLI — session management

| Command | Action |
|---|---|
| `tmux` | Start a new unnamed session |
| `tmux new -s <name>` | Start a new named session |
| `tmux ls` | List sessions |
| `tmux a` / `tmux attach` | Attach to last session |
| `tmux a -t <name>` | Attach to a named session |
| `tmux new -As <name>` | Attach if exists, else create |
| `tmux rename-session -t <old> <new>` | Rename a session |
| `tmux kill-session -t <name>` | Kill a session |
| `tmux kill-server` | Kill all sessions |

## CLI — windows & panes

| Command | Action |
|---|---|
| `tmux lsw` | List windows in current session |
| `tmux lsp` | List panes in current window |
| `tmux send-keys -t <target> '<cmd>' Enter` | Send a command to a pane |

## Prefix — session management

| Key | Action |
|---|---|
| `prefix` `d` | Detach from session |
| `prefix` `s` | Interactive session switcher |
| `prefix` `$` | Rename current session |
| `prefix` `(` / `)` | Previous / next session |
