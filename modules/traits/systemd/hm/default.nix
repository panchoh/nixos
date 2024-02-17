{
  config,
  lib,
  ...
}: let
  cfg = config.traits.hm.systemd;
in {
  options.traits.hm.systemd = {
    enable = lib.mkEnableOption "systemd" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    systemd.user.startServices = "sd-switch";
  };
}
