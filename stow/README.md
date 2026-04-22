# Stow Directory Structure

This directory contains dotfiles organized for GNU Stow. Each subdirectory represents a "package" that can be symlinked to the home directory using stow.

## Usage with Stow

To install all dotfiles:
```bash
cd stow
stow */
```

To install specific packages:
```bash
cd stow
stow nvim tmux wezterm alacritty fuzzel niri noctalia starship opencode
```

To uninstall:
```bash
cd stow
stow -D nvim tmux wezterm alacritty fuzzel niri noctalia starship opencode
```

## Package Structure

- `nvim/` - Neovim configuration
- `tmux/` - Tmux configuration  
- `wezterm/` - WezTerm terminal configuration
- `alacritty/` - Alacritty terminal configuration
- `fuzzel/` - Fuzzel launcher configuration
- `niri/` - Niri compositor configuration
- `noctalia/` - Noctalia shell configuration
- `starship/` - Starship prompt configuration
- `opencode/` - OpenCode configuration

Each package follows the standard stow convention where the directory structure mirrors the target location in the home directory.

## Integration with Home Manager

The Nix modules are configured to link these dotfiles automatically, so you don't need to use stow manually when using Home Manager. The stow structure is maintained for compatibility and manual deployment scenarios.
