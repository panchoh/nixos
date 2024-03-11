{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.hm.iosevka;
in {
  options.traits.hm.iosevka = {
    enable = lib.mkEnableOption "iosevka" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (nerdfonts.override {fonts = ["IosevkaTerm"];})
      (iosevka-bin.override {variant = "Slab";})
      iosevka-bin
    ];
  };
}
