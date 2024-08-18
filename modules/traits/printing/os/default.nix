{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.os.printing;
in {
  options.traits.os.printing = {
    enable = lib.mkEnableOption "printing" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = [pkgs.hplip];
    };
  };
}
