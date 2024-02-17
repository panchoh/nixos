{
  config,
  lib,
  ...
}: let
  cfg = config.traits.hm.xdg;
in {
  options.traits.hm.xdg = {
    enable = lib.mkEnableOption "xdg" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    xdg = {
      enable = true;
      userDirs = {
        createDirectories = true;
        download = "${config.home.homeDirectory}/incoming";
      };
    };
  };
}
