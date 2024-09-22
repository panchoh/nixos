{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.os.dbus;
in {
  options.traits.os.dbus = {
    enable = lib.mkEnableOption "dbus" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    services = {
      dbus.implementation = "broker";
    };
  };
}
