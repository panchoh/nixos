{
  config,
  lib,
  box ? null,
  ...
}: let
  cfg = config.traits.os.ollama;
in {
  options.traits.os.ollama = {
    enable = lib.mkEnableOption "Ollama" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
    };
  };
}
