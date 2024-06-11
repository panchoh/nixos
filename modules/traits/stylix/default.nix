{
  config,
  lib,
  pkgs,
  stylix,
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
      fonts.sizes.terminal = config.traits.font.terminal;
      homeManagerIntegration = {
        followSystem = false;
        autoImport = false;
      };
    };
  };
}
