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
      trash-cli
      ghostscript
      # mermaid-cli
      jq
    ])
    ++ lib.optionals config.myconfig.features.fonts (
      with pkgs;
      [
        cascadia-code
        nerd-fonts.jetbrains-mono
        inter
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
      ]
    )
    ++ lib.optionals config.myconfig.features.desktop (
      with pkgs;
      [
        xwayland-satellite
        cosmic-wallpapers
        gnome-control-center
        nautilus
        papirus-icon-theme
        pavucontrol
        qpwgraph # PipeWire patchbay — wire a virtual mic / soundboard into Discord
        helvum # alternative PipeWire patchbay (GTK)
        playerctl
        brightnessctl
        # gnomeExtensions.cloudflare-warp-toggle
      ]
    );
}
