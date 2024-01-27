{
  config,
  lib,
  ...
}: let
  cfg = config.traits.upower;
in {
  options.traits.upower = {
    enable = lib.mkEnableOption "upower";
  };

  config = lib.mkIf cfg.enable {
    services.upower.enable = true;
  };
}
