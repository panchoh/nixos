{
  config,
  lib,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.upower;
in
{
  options.traits.os.upower = {
    enable = lib.mkEnableOption "UPower" // {
      default = box.isStation or false;
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
