{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.myconfig.features.desktop {
    # Desktop shell/configuration shared by all local GUI setups.
    programs.wezterm = {
      enable = true;
      enableBashIntegration = true;
    };

    home.file.".wezterm.lua" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/wezterm/.wezterm.lua";
    };

    home.packages = lib.optionals config.myconfig.features.software (
      with pkgs;
      [
        spotify
        google-chrome
        obsidian
        vlc
        webtorrent_desktop
        steam
      ]
    );

    nixpkgs.overlays = [
      (final: prev: {
        steam = prev.steam.override {
          extraArgs = "-cef-disable-gpu-compositing";
        };
      })
    ];

    programs.brave = {
      enable = config.myconfig.features.software;
    };

    programs.discord = {
      enable = config.myconfig.features.software;
    };

    programs.opencode = {
      enable = config.myconfig.features.software;
    };

    programs.claude-code = {
      enable = config.myconfig.features.software;
    };

    home.file.".config/opencode/opencode.json" = lib.mkIf config.myconfig.features.software {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/opencode/.config/opencode/opencode.json";
    };
  };
}
