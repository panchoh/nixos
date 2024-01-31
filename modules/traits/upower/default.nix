{
  config,
  lib,
  ...
}: let
  cfg = config.traits.upower;
in {
  options.traits.upower = {
    enable = lib.mkEnableOption "upower" // {default = true;};
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
