{
  lib,
  config,
  pkgs,
  ...
}:
{
  home.pointerCursor = {
    enable = config.myconfig.features.desktop;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  home.packages =
    (with pkgs; [
      # Development Tools
      curl
      wget
      gcc
      gnumake
      unzip
      rustc
      cargo
      uv
      nodejs_24
      tree-sitter

      nixd
      biome
      # aider-chat-full

      # System Utilities
      fastfetch
      fzf
      fd
      nh
      ripgrep
      btop
      lsof
    ])
    ++ lib.optionals config.myconfig.features.fonts (
      with pkgs;
      [
        cascadia-code
        nerd-fonts.jetbrains-mono
        inter
        noto-fonts
        noto-fonts-color-emoji
      ]
    )
    ++ lib.optionals config.myconfig.features.software (
      with pkgs;
      [
        wootility
        obsidian
      ]
    )
    ++ lib.optionals config.myconfig.features.desktop (
      with pkgs;
      [
        xwayland-satellite
        cosmic-wallpapers
        gnome-control-center
        pavucontrol
        playerctl
        brightnessctl
        # gnomeExtensions.cloudflare-warp-toggle
      ]
    );
}
