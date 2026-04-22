{ lib, config, inputs, ... }:
{
  imports = [ inputs.niri.homeModules.niri ./packages.nix ];

  config = lib.mkIf config.myconfig.features.desktop {
    programs.niri.enable = true;

    home.file.".config/niri/config.kdl" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/niri/.config/niri/config.kdl";
    };
  };
}
