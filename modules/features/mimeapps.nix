{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.myconfig.features.desktop {
    xdg.mimeApps = {
      enable = true;

      # Package-derived defaults: Home Manager reads each package's .desktop
      # files and claims every MimeType= they declare. Order = priority.
      #   loupe  -> 26 image types (GNOME's image viewer)
      #   neovim -> text/plain + 14 source types; text/plain is the subclass
      #             root for nearly all code files, so shared-mime-info
      #             fallback covers text/x-python, application/json, etc.
      defaultApplicationPackages =
        [ pkgs.loupe ]
        ++ lib.optional config.programs.neovim.enable config.programs.neovim.finalPackage;

      # Explicit entries win over defaultApplicationPackages. These carry over
      # the handlers that were in the hand-maintained ~/.config/mimeapps.list.
      defaultApplications = {
        "inode/directory" = "org.gnome.Nautilus.desktop";
        "application/pdf" = "mupdf.desktop";
        "video/mp4" = "vlc.desktop";

        "text/html" = "chromium-browser.desktop";
        "x-scheme-handler/http" = "chromium-browser.desktop";
        "x-scheme-handler/https" = "chromium-browser.desktop";
        "x-scheme-handler/about" = "chromium-browser.desktop";
        "x-scheme-handler/unknown" = "chromium-browser.desktop";
        "x-scheme-handler/mailto" = "google-chrome.desktop";

        "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
        "x-scheme-handler/discord" = "vesktop.desktop";
        "x-scheme-handler/logseq" = "Logseq.desktop";
        "x-scheme-handler/pear" = "pear.desktop";
        "x-scheme-handler/wootwoot" = "wootility.desktop";
        "x-scheme-handler/web+wootwoot" = "wootility.desktop";
      };

      associations.added = {
        "application/zip" = "org.gnome.Nautilus.desktop";
      };
    };

    # nvim.desktop is Terminal=true. GLib's prepend_terminal_to_vector() walks a
    # compiled-in terminal list that has no kitty/ghostty/alacritty entry, so
    # without this it would launch nvim in xterm. xdg-terminal-exec is the first
    # entry GLib probes; xdg-terminals.list points it at kitty.
    home.packages = [ pkgs.xdg-terminal-exec ];

    xdg.configFile."xdg-terminals.list".text = ''
      kitty.desktop
    '';
  };
}
