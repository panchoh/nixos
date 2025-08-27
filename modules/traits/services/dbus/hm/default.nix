{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.dbus;
in
{
  options.traits.hm.dbus = {
    enable = lib.mkEnableOption "D-Bus" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.d-spy
    ];
  };
}
