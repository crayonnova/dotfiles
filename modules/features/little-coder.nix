{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.myconfig.features.devtools {
    programs.little-coder = {
      enable = true;
      defaultModel = "ollama/qwen3.5";
      extraEnvironment.OLLAMA_API_KEY = "noop";
      models.providers.ollama = {
        api = "openai-completions";
        baseUrl = "http://127.0.0.1:11434/v1";
        apiKey = "OLLAMA_API_KEY";
        models = [
          {
            id = "gemma4";
            name = "Gemma 4 (ollama)";
            contextWindow = 32768;
            maxTokens = 4096;
          }
          {
            id = "qwen3.5";
            name = "Qwen3.5 (ollama)";
            reasoning = true;
            contextWindow = 32768;
            maxTokens = 4096;
          }
        ];
      };
    };
  };
}
