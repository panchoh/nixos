{
  config,
  lib,
  pkgs,
  stylix,
  box ? null,
  ...
}: let
  cfg = config.traits.stylix;
in {
  imports = [
    stylix.nixosModules.stylix
  ];

  options.traits.stylix = {
    enable = lib.mkEnableOption "Stylix" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      targets.plymouth.enable = false;

      # Either image or base16Scheme is required
      base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";

      image = pkgs.fetchurl {
        url = "https://github.com/NixOS/nixos-artwork/raw/master/wallpapers/nix-wallpaper-dracula.png";
        hash = "sha256-SykeFJXCzkeaxw06np0QkJCK28e0k30PdY8ZDVcQnh4=";
      };

      homeManagerIntegration = {
        followSystem = true;
        autoImport = true;
      };

      fonts = {
        serif = {
          package = pkgs.iosevka-bin.override {variant = "Etoile";};
          name = "Iosevka Etoile";
        };

        sansSerif = {
          package = pkgs.iosevka-bin.override {variant = "Aile";};
          name = "Iosevka Aile";
        };

        monospace = {
          package = pkgs.iosevka-bin;
          name = "Iosevka";
        };

        emoji = {
          name = "OpenMoji Color";
          package = pkgs.openmoji-color;
        };

        sizes =
          lib.mapAttrs (
            _name: value:
              if box.isLaptop or false
              then value - 2
              else value
          ) {
            desktop = 12;
            applications = 12;
            terminal = 14;
          };
      };
    };
  };
}
