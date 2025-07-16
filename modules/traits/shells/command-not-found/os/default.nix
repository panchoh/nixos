{
  config,
  lib,
  ...
}:
let
  cfg = config.traits.os.command-not-found;
in
{
  options.traits.os.command-not-found = {
    enable = lib.mkEnableOption "command-not-found" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.command-not-found.enable = false;
  };
}
