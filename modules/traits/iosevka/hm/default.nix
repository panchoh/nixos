{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hm.iosevka;
in {
  options.hm.iosevka = {
    enable = lib.mkEnableOption "iosevka" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (nerdfonts.override {fonts = ["IosevkaTerm"];})
      (iosevka-bin.override {variant = "slab";})
      iosevka-bin
    ];
  };
}
