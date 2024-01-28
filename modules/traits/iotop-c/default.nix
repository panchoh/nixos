{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.iotop-c;
in {
  # TODO: drop this module and just install iotop-c via HM, and use it with doas
  # That's because delayed accounting can only be enabled/disabled with root permissions
  options.traits.iotop-c = {
    enable = lib.mkEnableOption "iotop-c + setcap wrapper" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    security.wrappers.iotop-c = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_admin+p";
      source = lib.getExe' pkgs.iotop-c "iotop-c";
    };
  };
}
