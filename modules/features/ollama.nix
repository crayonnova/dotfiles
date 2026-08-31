{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.ollama;

  # Kept in one place so the loader below and the server agree on the address.
  models = [
    "gemma4" # you not gonna need it
    "llava"
    "qwen3.5"
  ];

  loadModels = pkgs.writeShellScript "ollama-load-models" ''
    set -eu
    export OLLAMA_HOST="${cfg.host}:${toString cfg.port}"

    # The server is started by ollama.service, but "started" is not the same as
    # "listening". Fail out and let systemd's backoff retry rather than racing.
    for _ in $(seq 30); do
      if ${lib.getExe cfg.package} list >/dev/null 2>&1; then
        break
      fi
      sleep 1
    done

    for model in ${lib.escapeShellArgs models}; do
      ${lib.getExe cfg.package} pull "$model"
    done
  '';
in
{
  config = lib.mkIf config.myconfig.features.devtools {
    services.ollama = {
      enable = true;
      environmentVariables.OLLAMA_CONTEXT_LENGTH = "32768";
    };

    # home-manager's services.ollama has no `loadModels`, so the nixos module's
    # ollama-model-loader.service is reimplemented here as a user unit.
    systemd.user.services.ollama-model-loader = {
      Unit = {
        Description = "Download ollama models in the background";
        After = [ "ollama.service" ];
        BindsTo = [ "ollama.service" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${loadModels}";
        Restart = "on-failure";
        RestartSec = "10s";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
