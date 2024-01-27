{
  config,
  lib,
  ...
}: let
  cfg = config.traits.physlock;
in {
  options.traits.physlock = {
    enable = lib.mkEnableOption "physlock";
  };

  config = lib.mkIf cfg.enable {
    services.physlock.enable = true;
  };
}
