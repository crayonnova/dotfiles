{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.myconfig.features.desktop {
    gtk.iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    # Desktop shell/configuration shared by all local GUI setups.
    programs.wezterm = {
      enable = true;
      enableBashIntegration = false;
    };

    home.file.".wezterm.lua" = lib.mkIf config.programs.wezterm.enable {
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
        wootility
        logseq
        mupdf
        firefox
        ungoogled-chromium
        smassh
        jellyfin-desktop
        # grayjay - TODO: build erro
        # stremio-linux-shell
        keet
        # termshark
        # wireshark
        bandwhich
        vencord
        discord
        authenticator
        # handbrake - TODO: ffmpeg error
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

    programs.qutebrowser = {
      enable = config.myconfig.features.software;
    };

    programs.vesktop = {
      enable = config.myconfig.features.software;
    };

    programs.opencode = {
      enable = config.myconfig.features.software;
    };

    home.file.".config/opencode/opencode.json" = lib.mkIf config.programs.opencode.enable {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/opencode/.config/opencode/opencode.json";
    };

    home.file.".config/opencode/oh-my-openagent.jsonc" = lib.mkIf config.programs.opencode.enable {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/stow/opencode/.config/opencode/oh-my-openagent.jsonc";
    };

    programs.claude-code = {
      enable = config.myconfig.features.software;
    };

    # Claude Code rewrites settings.json atomically: it resolves the symlink and
    # writes settings.json.tmp.* into the *resolved* directory. mkOutOfStoreSymlink
    # points through /nix/store/...-home-manager-files/.claude/, which is read-only,
    # so every settings read/write fails with EROFS (surfaced as a bogus "syntax
    # error"). Link straight to the dotfiles copy so the temp file lands somewhere
    # writable.
    home.activation.claudeSettingsLink = lib.mkIf config.programs.claude-code.enable (
      lib.hm.dag.entryAfter [ "writeBoundary" "linkGeneration" ] ''
        run mkdir -p "${config.home.homeDirectory}/.claude"
        run ln -sfn \
          "${config.home.homeDirectory}/dotfiles/stow/claude-code/.claude/settings.json" \
          "${config.home.homeDirectory}/.claude/settings.json"
      ''
    );
  };
}
