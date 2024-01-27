{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.printing;
in {
  options.traits.printing = {
    enable = lib.mkEnableOption "printing" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = [pkgs.hplip];
    };
  };
}
