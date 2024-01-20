{
  config,
  lib,
  pkgs,
  stylix,
  ...
}: let
  cfg = config.traits.stylix;
in {
  imports = [stylix.nixosModules.stylix];

  options.traits.stylix = {
    enable = lib.mkEnableOption "Stylix";
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      homeManagerIntegration.followSystem = false;
      homeManagerIntegration.autoImport = false;
      # Either image or base16Scheme is required
      base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
      fonts.sizes.terminal = config.traits.font.terminal;
    };
  };
}
