{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.myconfig.features.devtools {
    # Development-specific tools and configurations
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

    home.file.".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/nvim/.config/nvim";
      recursive = true;
    };

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "crayonnova";
          email = "kaungminkhant.dev@gmail.com";
        };
        alias = {
          glg = "log --oneline --graph";
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

    programs.gh = {
      enable = true;
      settings = {
        editor = "nvim";
        git_protocol = "https";
      };
      gitCredentialHelper.enable = true;
    };

    programs.gh-dash.enable = true;

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

    programs.bun = {
      enable = true;
    };

    home.file.".config/.bunfig.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/bun/.config/.bunfig.toml";
    };

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    # home.sessionPath = [
    #   "$HOME/.npm-gobal"
    # ];
  };
}
