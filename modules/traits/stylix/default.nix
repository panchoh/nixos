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
    enable = lib.mkEnableOption "Stylix" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = true;
      packages = [
        pkgs.corefonts
        pkgs.iosevka-comfy.comfy
        pkgs.iosevka-comfy.comfy-fixed
        pkgs.iosevka-comfy.comfy-duo
        pkgs.iosevka-comfy.comfy-motion
      ];
    };

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
          name = "Iosevka Comfy Motion";
          package = pkgs.iosevka-comfy.comfy-motion;
        };

        sansSerif = {
          name = "Iosevka Comfy";
          package = pkgs.iosevka-comfy.comfy;
        };

        monospace = {
          name = "Iosevka Comfy Fixed";
          package = pkgs.iosevka-comfy.comfy-fixed;
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
            desktop = 14;
            applications = 14;
            terminal = 14;
            popups = 12;
          };
      };
    };
  };
}
