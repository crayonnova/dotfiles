{ lib, config, inputs, ... }:
{
  imports = [ inputs.noctalia.homeModules.default ];

  config = lib.mkIf config.myconfig.features.desktop {
    # v5 renamed the option from `programs.noctalia-shell`.
    programs.noctalia = {
      enable = true;

      # Left empty on purpose. Setting `settings` makes the module write
      # ~/.config/noctalia/config.toml from the store, which is read-only and
      # would both clobber the stow symlink below and break the in-app settings
      # menu. Keeping it empty preserves the v4 workflow: edit stow/, changes
      # apply immediately (noctalia hot-reloads config.toml via inotify).
      settings = { };
    };

    home.file.".config/noctalia" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/noctalia/.config/noctalia";
      recursive = true;
    };
  };
}
