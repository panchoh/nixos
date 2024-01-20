{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.hyprland;
in {
  options.traits.hyprland.enable = lib.mkEnableOption "hyprland";

  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;
    programs.hyprland.xwayland.enable = true;
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
