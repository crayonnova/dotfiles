{ lib
, config
, pkgs
, ...
}:

with lib;

let
  cfg = config.myconfig;
in
{
  imports = [
    ./modules/base/packages.nix
    ./modules/base/shell.nix
    ./modules/base/cli-tools.nix
    ./modules/features/dev-tools.nix
    ./modules/features/desktop.nix
    ./modules/features/fonts.nix
    ./modules/system/codespace.nix
    ./modules/wayland
    ./modules/features/noctalia.nix
  ];

  options.myconfig = {
    username = mkOption {
      type = types.str;
      description = "Username for the home directory";
    };

    homeDirectory = mkOption {
      type = types.str;
      default = "/home/${cfg.username}";
      description = "Home directory path";
    };

    stateVersion = mkOption {
      type = types.str;
      default = "25.05";
      description = "Home Manager state version";
    };

    features = {
      devtools = mkEnableOption "development tools and configurations";
      desktop = mkEnableOption "desktop applications and GUI tools";
      software = mkEnableOption "optional end-user applications";
      fonts = mkEnableOption "font packages";
    };

    system = {
      isCodespace = mkEnableOption "codespace-specific configurations";
    };
  };

  config = {
    home.username = cfg.username;
    home.homeDirectory = cfg.homeDirectory;
    home.stateVersion = cfg.stateVersion;

    programs.home-manager.enable = true;
  };
}
