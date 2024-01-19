{
  config,
  lib,
  ...
}: let
  cfg = config.hm.xdg;
in {
  options.hm.xdg.enable = lib.mkEnableOption "xdg";

  config.xdg = lib.mkIf cfg.enable {
    enable = true;
    userDirs.download = "${config.home.homeDirectory}/incoming";
  };
}
