{ config, ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [
      "ignoredups"
      "ignorespace"
    ];
    historyFileSize = 10000;
    historySize = 10000;
    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
    ];

    profileExtra = ''
      if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
      fi
    '';
    initExtra = ''
      [ -f "$HOME/.secrets" ] && source "$HOME/.secrets"

      ai() {
        if [[ $# -eq 0 ]]; then
          echo "Usage: ai <description>" >&2
          return 1
        fi
        local result
        result=$(${config.home.homeDirectory}/dotfiles/scripts/ai-cmd "$@") || return 1
        local edited
        read -e -i "$result" -p "$ " edited < /dev/tty
        if [[ -n "$edited" ]]; then
          history -s "$edited"
          eval "$edited"
        fi
      }
    '';
  };

  programs.npm = {
    enable = true;
    settings = {
      prefix = "\${HOME}/.npm";
    };
  };

  programs.carapace = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    options = [
      "--cmd cd"
    ];
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };

  home.file.".config/starship.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/starship/.config/starship.toml";
  };

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    git = true;
    icons = "auto";
    extraOptions = [
      "--long"
      "--all"
    ];
  };

  home.shellAliases = {
    ll = "eza -l";
    la = "eza -a";
    lt = "eza --tree";
    listallusers = "bash ${config.home.homeDirectory}/dotfiles/scripts/listallusers.sh";

    # Home-manager
    hh = "home-manager switch --flake .";
    hhr = "home-manager switch --flake . && gnome-session-quit --logout";

    #NixOS configuration
    seconfig = "cd /etc/nixos && sudoedit /etc/nixos/configuration.nix";
    seflake = "cd /etc/nixos && sudoedit /etc/nixos/flake.nix";
    osbuild = "cd /etc/nixos && sudo nixos-rebuild switch --flake .";

    #edit
    edot = "cd ~/dotfiles && nvim .";

    kilo = "npx -y --package @kilocode/cli@7.1.2 kilo";
    nvim-fresh = "rm -rf ~/.local/share/nvim/lazy ~/.local/share/nvim/site ~/.cache/nvim && nvim";
  };
}
