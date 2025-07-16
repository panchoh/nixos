{
  config,
  lib,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.time-zone;
in
{
  options.traits.os.time-zone = {
    enable = lib.mkEnableOption "time zone" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = box.timeZone;
  };
}
