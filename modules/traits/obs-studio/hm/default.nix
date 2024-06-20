{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.obs-studio;
in {
  options.traits.hm.obs-studio = {
    enable = lib.mkEnableOption "obs-studio" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = [pkgs.obs-studio-plugins.wlrobs];
    };
  };
}
