{ lib, config, ... }:
{
  # Pure CLI tools and utilities - suitable for remote development
  # Keep the npm user config in a writable location so `npm config set` works
  # and `prefix` is read as user config, not project config (npm rejects
  # `prefix` in project config, which is what ~/.npmrc becomes when cwd=$HOME).
  home.sessionVariables = {
    NPM_CONFIG_USERCONFIG = "$HOME/.config/npm/npmrc";
  };

  home.sessionPath = [ "$HOME/.npm/bin" ];

  home.activation.npmUserConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.config/npm"
    if [ ! -f "$HOME/.config/npm/npmrc" ]; then
      echo "prefix=$HOME/.npm" > "$HOME/.config/npm/npmrc"
    fi
  '';

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
      "--hidden"
      "--glob=!.git/"
      "--glob=!node_modules/"
    ];
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Dracular";
      style = "numbers,changes,header";
      paging = "never";
    };
  };

  programs.tmux = {
    enable = true;
  };

  home.file.".tmux.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/tmux/.tmux.conf";
  };
}
