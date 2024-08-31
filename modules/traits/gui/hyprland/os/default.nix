{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.os.hyprland;
in {
  options.traits.os.hyprland = {
    enable = lib.mkEnableOption "hyprland" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    programs = {
      hyprland.enable = true;
      hyprland.xwayland.enable = true;
    };
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
