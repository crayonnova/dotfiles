{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.myconfig.features.desktop {
  home.file.".config/alacritty/alacritty.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/alacritty/.config/alacritty/alacritty.toml";
  };

  home.file.".config/ghostty/config.ghostty" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/ghostty/.config/ghostty/config.ghostty";
  };

  home.file.".config/kitty/kitty.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/kitty/.config/kitty/kitty.conf";
  };

  home.file.".config/fuzzel/fuzzel.ini" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/fuzzel/.config/fuzzel/fuzzel.ini";
  };

  home.packages = with pkgs; [
    # Terminal
    alacritty
    kitty
    ghostty

    # Launcher
    fuzzel
    xdg-utils

    # Lock/idle/wallpaper
    swaylock
    swayidle
    swaybg

    # Notifications
    mako

    # Screenshot/region
    grim
    slurp

    # Clipboard
    wl-clipboard
  ];
}
