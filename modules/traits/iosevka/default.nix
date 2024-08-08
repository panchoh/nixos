{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.iosevka;
in {
  options.traits.iosevka = {
    enable = lib.mkEnableOption "Iosevka" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = [
      pkgs.iosevka-comfy.comfy
      pkgs.iosevka-comfy.comfy-fixed
      pkgs.iosevka-comfy.comfy-duo
      pkgs.iosevka-comfy.comfy-motion
    ];
  };
}
