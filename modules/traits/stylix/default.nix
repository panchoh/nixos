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
          name = "Iosevka Europa Etoile";
          package = pkgs.iosevka.override {
            set = "EuropaEtoile";
            privateBuildPlan = {
              family = "Iosevka Europa Etoile";
              serif = "slab";
              spacing = "quasi-proportional";
              weights = {
                Regular = {
                  shape = 300;
                  menu = 300;
                  css = 300;
                };
              };
            };
          };
        };

        sansSerif = {
          name = "Iosevka Europa Aile";
          package = pkgs.iosevka.override {
            set = "EuropaAile";
            privateBuildPlan = {
              family = "Iosevka Europa Aile";
              spacing = "quasi-proportional";
              weights = {
                Regular = {
                  shape = 300;
                  menu = 300;
                  css = 300;
                };
              };
            };
          };
        };

        monospace = {
          name = "Iosevka Europa Mono";
          package = pkgs.iosevka.override {
            set = "EuropaMono";
            privateBuildPlan = {
              family = "Iosevka Europa Mono";
              spacing = "fontconfig-mono";
              weights = {
                Regular = {
                  shape = 300;
                  menu = 300;
                  css = 300;
                };
              };
            };
          };
        };

        emoji = {
          name = "OpenMoji Color";
          package = pkgs.openmoji-color;
        };

        sizes =
          lib.mapAttrs (
            name: value:
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
