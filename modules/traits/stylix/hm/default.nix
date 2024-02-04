{
  config,
  lib,
  pkgs,
  stylix,
  osConfig,
  ...
}: let
  cfg = config.hm.stylix;
in {
  imports = [
    stylix.homeManagerModules.stylix
  ];

  options.hm.stylix = {
    enable = lib.mkEnableOption "stylix" // {default = true;};
  };

  config.stylix = lib.mkIf cfg.enable {
    targets.kde.enable = false;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";

    image = pkgs.fetchurl {
      url = "https://github.com/NixOS/nixos-artwork/raw/master/wallpapers/nix-wallpaper-dracula.png";
      hash = "sha256-SykeFJXCzkeaxw06np0QkJCK28e0k30PdY8ZDVcQnh4=";
    };

    fonts = {
      serif = {
        package = pkgs.iosevka-bin.override {variant = "etoile";};
        name = "Iosevka Etoile";
      };

      sansSerif = {
        package = pkgs.iosevka-bin.override {variant = "aile";};
        name = "Iosevka Aile";
      };

      monospace = {
        package = pkgs.iosevka-bin.override {variant = "sgr-iosevka-term";};
        name = "Iosevka Term";
      };

      emoji = {
        name = "OpenMoji Color";
        package = pkgs.openmoji-color;
      };

      sizes = {
        desktop = 10;
        applications = osConfig.traits.font.applications;
        terminal = osConfig.traits.font.terminal;
      };
    };
  };
}
