{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.traits.hm.systemd;
in
{
  options.traits.hm.systemd = {
    enable = lib.mkEnableOption "systemd" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.isd
      pkgs.systemctl-tui
    ];
  };
}
