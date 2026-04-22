{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.myconfig.system.isCodespace {
    programs.git = {
      enable = true;
      settings = {
        extraConfig = {
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
          pull.rebase = true;
        };
      };
    };

    home.sessionVariables = {
      EDITOR = "nvim";
    };
    # home.packages = with pkgs; [
    #   nil
    #   nixfmt-rfc-style
    # ];
  };
}
