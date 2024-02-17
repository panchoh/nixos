{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.hm.chromium;
in {
  options.traits.hm.chromium = {
    enable = lib.mkEnableOption "Chromium" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      commandLineArgs = [
        "--incognito"
        "--ozone-platform=wayland"
      ];
    };
  };
}
