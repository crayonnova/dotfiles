# dotfiles — CLAUDE.md

Nix flake + Home Manager dotfiles for multiple users and machines. Application configs live under `stow/` and are linked by Home Manager (or GNU Stow as fallback).

## Core composition

```
flake.nix           # Declares homeConfigurations; composes user + profile + home.nix
home.nix            # Defines myconfig options, imports all modules
users/*.nix         # Sets username and stateVersion per user
profiles/*.nix      # Toggles feature flags (devtools, desktop, software, fonts)
modules/            # Feature implementations gated on myconfig.features.*
stow/               # Raw dotfiles, mirroring ~/ paths for Home Manager symlinks or stow
```

## Active targets (flake.nix)

| Target | User file | Profile |
|---|---|---|
| `crayon@nixos`, `crayon@nixie` | `users/crayon.nix` | `desktop` |
| `nova@nixos` | `users/nova.nix` | `desktop` |
| `kaungminkhant@DESKTOP-JA8S7GL` | `users/kaungminkhant.nix` | `desktop` |
| `crayon@nixoswsl` | `users/crayon.nix` | `cli-dev` |
| `vscode@codespaces` | `users/vscode.nix` | `codespace` |

## Feature flags (`myconfig.features`)

| Flag | Enables |
|---|---|
| `desktop` | Wayland/Niri, terminals, Noctalia bar, WezTerm, cursor |
| `devtools` | Dev language toolchains + LSPs |
| `software` | Spotify, Chrome, Obsidian, Brave, Discord, Steam, OpenCode, claude-code |
| `fonts` | JetBrains Mono Nerd, Cascadia Code, Inter, Noto |

`profiles/desktop.nix` sets all four to `true`. `profiles/cli-dev.nix` sets only `devtools` and `fonts`.

## Module map

```
modules/base/
  packages.nix     # Base packages + per-flag optionals; cursor config
  shell.nix        # Shell config
  cli-tools.nix    # CLI tooling
modules/features/
  desktop.nix      # WezTerm; optional software packages (Spotify, browsers, etc.)
  dev-tools.nix    # Dev tools
  fonts.nix        # Font packages
  noctalia.nix     # Noctalia bar (noctalia-flake homeModule + stow/noctalia symlink)
modules/system/
  codespace.nix    # Codespaces-specific overrides
modules/wayland/
  default.nix      # Niri homeModule import + niri config symlink
  packages.nix     # Wayland packages: terminals (alacritty/kitty/ghostty), fuzzel,
                   # swaylock/swayidle/swaybg, mako, grim/slurp, wl-clipboard
```

## Stow packages → home paths

| Package | Linked to |
|---|---|
| `nvim/` | `~/.config/nvim/` |
| `tmux/` | `~/.tmux.conf` |
| `wezterm/` | `~/.wezterm.lua` |
| `alacritty/` | `~/.config/alacritty/` |
| `ghostty/` | `~/.config/ghostty/` |
| `kitty/` | `~/.config/kitty/` |
| `fuzzel/` | `~/.config/fuzzel/` |
| `niri/` | `~/.config/niri/` |
| `noctalia/` | `~/.config/noctalia/` |
| `starship/` | `~/.config/starship/` |
| `opencode/` | `~/.config/opencode/` |
| `bun/` | `~/.config/bun/` |

Home Manager links these via `mkOutOfStoreSymlink` so edits in `stow/` take effect immediately without rebuilding. Manual Stow: `cd stow && stow */`.

## Flake inputs

- `nixpkgs` — nixos-unstable
- `home-manager` — follows nixpkgs
- `niri` — sodiboo/niri-flake
- `noctalia` — noctalia-dev/noctalia-shell

## Apply config

```bash
# From dotfiles root
home-manager switch --flake .#<user>@<host>
# e.g.
home-manager switch --flake .#nova@nixos
# Or with nh
nh home switch .
```
