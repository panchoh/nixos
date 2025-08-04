{
  config,
  lib,
  pkgs,
  stylix,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.stylix;
in
{
  imports = [
    stylix.nixosModules.stylix
  ];

  options.traits.os.stylix = {
    enable = lib.mkEnableOption "Stylix" // {
      default = true;
    };
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

      homeManagerIntegration = {
        followSystem = true;
        autoImport = true;
      };

      opacity.popups = 0.80;

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

        sizes = lib.mapAttrs (_name: value: if box.isLaptop or false then value - 2 else value) {
          desktop = 14;
          applications = 14;
          terminal = 14;
          popups = 12;
        };
      };
    };
  };
}
