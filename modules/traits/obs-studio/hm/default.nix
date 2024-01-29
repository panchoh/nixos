{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hm.obs-studio;
in {
  options.hm.obs-studio = {
    enable = lib.mkEnableOption "obs-studio" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = [pkgs.obs-studio-plugins.wlrobs];
    };
  };
}
