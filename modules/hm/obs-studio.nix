{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hm.obs-studio;
in {
  options.hm.obs-studio.enable = lib.mkEnableOption "obs-studio" // {default = true;};

  config.programs.obs-studio = lib.mkIf cfg.enable {
    enable = true;
    plugins = [pkgs.obs-studio-plugins.wlrobs];
  };
}
