{
  config,
  lib,
  box ? null,
  ...
}: let
  cfg = config.traits.time-zone;
in {
  options.traits.time-zone = {
    enable = lib.mkEnableOption "time zone" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = box.timeZone;
  };
}
