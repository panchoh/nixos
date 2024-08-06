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
    fonts.packages = with pkgs; [
      (nerdfonts.override {fonts = ["IosevkaTerm"];})
      (iosevka-bin.override {variant = "Aile";})
      (iosevka-bin.override {variant = "Slab";})
      iosevka-bin
    ];
  };
}
