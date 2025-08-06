{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.transmission;
in
{
  options.traits.hm.transmission = {
    enable = lib.mkEnableOption "Transmission" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {

    xdg.mimeApps.defaultApplications."x-scheme-handler/magnet" = "transmission-gtk.desktop";

    home.packages = [ pkgs.transmission_4-gtk ];
  };
}
