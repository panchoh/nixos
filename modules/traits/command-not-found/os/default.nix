{
  config,
  lib,
  ...
}: let
  cfg = config.traits.command-not-found;
in {
  options.traits.command-not-found = {
    enable = lib.mkEnableOption "command-not-found" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.command-not-found.enable = false;
  };
}
