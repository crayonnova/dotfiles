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

      edot() {
        local id
        id=$(niri msg windows | awk '
          /^Window ID/ { cur=$3; sub(":","",cur) }
          /App ID: "dotfiles"/ { print cur; exit }
        ')
        if [ -n "$id" ]; then
          niri msg action focus-window --id "$id"
        else
          setsid -f kitty --class dotfiles -- tmux new -As dotfiles -c ~/dotfiles nvim >/dev/null 2>&1
        fi
      }
    '';
  };

  # programs.npm intentionally not enabled: it writes a read-only ~/.npmrc
  # containing `prefix`, which npm rejects as project config whenever cwd is
  # $HOME. nodejs comes from modules/base/packages.nix instead; the npm user
  # config lives at ~/.config/npm/npmrc (see modules/base/cli-tools.nix).

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

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
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
    nedit = "bash ${config.home.homeDirectory}/dotfiles/scripts/nix-edit.sh";
    lpkgs = "bash ${config.home.homeDirectory}/dotfiles/scripts/hm-outdated.sh";

    # Home-manager
    hh = "home-manager switch --flake .";
    hhr = "home-manager switch --flake . && gnome-session-quit --logout";

    #NixOS configuration
    seconfig = "cd /etc/nixos && sudoedit /etc/nixos/configuration.nix";
    seflake = "cd /etc/nixos && sudoedit /etc/nixos/flake.nix";
    osbuild = "cd /etc/nixos && sudo nixos-rebuild switch --flake .";

    kilo = "npx -y --package @kilocode/cli@7.1.2 kilo";
    nvim-fresh = "rm -rf ~/.local/share/nvim/lazy ~/.local/share/nvim/site ~/.cache/nvim && nvim";

    # projects
    p1 = "tmux new -As portfolio -c ~/pjs/portfolio nvim";

    # monkeytype
    monkeytype = "smassh";

    ocd = "claude --dangerously-skip-permissions";
  };
}
