{ config
, pkgs
, username
, ...
}:
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    # Utilities
    curl
    wget
    fastfetch
    fzf
    fd
    nh
    ripgrep
    gcc
    gnumake
    unzip
    rustc
    cargo
    uv
    nodejs_24
    tree-sitter
    lsof
    spotify
    cascadia-code
    nerd-fonts.jetbrains-mono
    inter
    noto-fonts
    noto-fonts-color-emoji
    google-chrome
    gnomeExtensions.cloudflare-warp-toggle
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
      sansSerif = [
        "Inter"
        "Noto Sans"
      ];
      serif = [ "Noto Serif" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  programs.wezterm = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.brave = {
    enable = true;
  };

  programs.discord = {
    enable = true;
  };

  programs.opencode = {
    enable = true;
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        pageSize = 20;
        scrollHeight = 2;
        theme = {
          activeBorderColor = [
            "blue"
            "bold"
          ];
          inactiveBorderColor = [ "white" ];
        };
      };
      git = {
        autoFetch = true;
        branch = {
          logOrder = "date-order";
        };
      };
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "crayonnova";
        email = "kaungminkhant.dev@gmail.com";
      };
      alias = {
        # co = "checkout";
        # ci = "commit";
        # st = "status";
        # br = "branch";
        # lg = "log --oneline --graph";
      };
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        push = {
          autoSetupRemote = true;
        };
        pull = {
          rebase = true;
        };
      };
    };
  };

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
  programs.bash = {
    enable = true;
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
    initExtra = "";
  };

  programs.tmux = {
    enable = true;
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

  programs.gh = {
    enable = true;
    settings = {
      editor = "nvim";
      git_protocol = "ssh";
    };
    gitCredentialHelper.enable = true;
  };

  programs.gh-dash.enable = true;

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

    #edit
    edotfiles = "cd ~/dotfiles && nvim .";

    kilo = "npx -y --package @kilocode/cli@7.1.2 kilo";
    nvim-fresh = "rm -rf ~/.local/share/nvim/lazy ~/.local/share/nvim/site ~/.cache/nvim && nvim";
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    withRuby = false;
    withPython3 = false;
    defaultEditor = true;
    # Might need to disable if LazyVim is not in use
    sideloadInitLua = true;
    extraPackages = with pkgs; [
      imagemagick
    ];
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [
    # Only needed in WSL
    "$HOME/.npm/bin"
  ];

  programs.home-manager.enable = true;
}
