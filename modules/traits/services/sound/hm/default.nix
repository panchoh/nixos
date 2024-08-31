{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.sound;
in {
  options.traits.hm.sound = {
    enable = lib.mkEnableOption "sound" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      audacity
      helvum
      picard
      pwvucontrol
      qastools
    ];
  };
}
