{
  config,
  lib,
  ...
}: let
  cfg = config.traits.time-zone;
in {
  options.traits.time-zone = {
    enable = lib.mkEnableOption "time zone";
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = "Europe/Madrid";
  };
}
