{ lib, config, pkgs, ... }:
lib.mkIf config.myconfig.features.desktop {
  home.file.".config/alacritty/alacritty.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/alacritty/.config/alacritty/alacritty.toml";
  };

  home.file.".config/fuzzel/fuzzel.ini" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/fuzzel/.config/fuzzel/fuzzel.ini";
  };

  home.packages = with pkgs; [
    # Terminal
    alacritty

    # Launcher
    fuzzel

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
    webtorrent_desktop
  ];
}
