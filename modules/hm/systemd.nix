{
  config,
  lib,
  ...
}: let
  cfg = config.hm.systemd;
in {
  options.hm.systemd.enable = lib.mkEnableOption "systemd";

  config = lib.mkIf cfg.enable {
    systemd.user.startServices = "sd-switch";
  };
}
