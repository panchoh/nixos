{
  config,
  lib,
  ...
}:
let
  cfg = config.traits.os.physlock;
in
{
  options.traits.os.physlock = {
    enable = lib.mkEnableOption "physlock" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services.physlock.enable = true;
  };
}
