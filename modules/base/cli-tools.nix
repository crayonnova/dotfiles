{ lib, config, ... }:
{
  # Pure CLI tools and utilities - suitable for remote development
  # ~/.npmrc is a read-only Nix store symlink — redirect writes to a writable path.
  # mkForce overrides the conflicting definition from programs/npm.nix.
  home.sessionVariables = {
    NPM_CONFIG_USERCONFIG = lib.mkForce "$HOME/.config/npm/npmrc";
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
