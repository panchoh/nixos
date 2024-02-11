{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hm.chromium;
in {
  options.hm.chromium = {
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
