{
  config,
  lib,
  ...
}:
let
  cfg = config.traits.os.upower;
in
{
  options.traits.os.upower = {
    enable = lib.mkEnableOption "UPower" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      upower = {
        enable = true;
        criticalPowerAction = "PowerOff";
      };
    };
  };
}
