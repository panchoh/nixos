{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.chromium;
in
{
  options.traits.hm.chromium = {
    enable = lib.mkEnableOption "Chromium" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {

    xdg.mimeApps.associations.removed."application/pdf" = "chromium-browser.desktop";

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
