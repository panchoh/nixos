{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.iotop-c;
in {
  options.traits.iotop-c.enable = lib.mkEnableOption "iotop-c + setcap wrapper";

  config = lib.mkIf cfg.enable {
    security.wrappers.iotop-c = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_admin+p";
      source = lib.getExe' pkgs.iotop-c "iotop-c";
    };
  };
}
