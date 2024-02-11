{
  config,
  lib,
  ...
}: let
  cfg = config.hm.xdg;
in {
  options.hm.xdg = {
    enable = lib.mkEnableOption "xdg" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    xdg = {
      enable = true;
      userDirs.download = "${config.home.homeDirectory}/incoming";
    };
  };
}
