{
  lib,
  config,
  ...
}:
{
  # Config only. Hyprland itself comes from the NixOS system config
  # (programs.hyprland.enable), so Home Manager must not install a second copy —
  # a mismatched build would fight the system portal and session file.
  config = lib.mkIf config.myconfig.features.hyprland {
    home.file.".config/hypr/hyprland.conf" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/hypr/.config/hypr/hyprland.conf";
    };
  };
}
