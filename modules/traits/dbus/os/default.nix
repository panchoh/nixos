{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.dbus;
in {
  options.traits.dbus = {
    enable = lib.mkEnableOption "dbus" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    services = {
      dbus.implementation = "broker";
      dbus.packages = [
        pkgs.gcr # for pinentry-gnome3
      ];
    };
  };
}
