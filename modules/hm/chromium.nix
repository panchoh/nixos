{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hm.chromium;
in {
  options.hm.chromium = {
    enable = lib.mkEnableOption "Chromium";
  };

  config.programs.chromium = lib.mkIf cfg.enable {
    enable = true;
    package = pkgs.ungoogled-chromium;
    commandLineArgs = [
      "--incognito"
      "--ozone-platform=wayland"
    ];
  };
}
