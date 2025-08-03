{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.quickemu;
in
{
  options.traits.hm.quickemu = {
    enable = lib.mkEnableOption "Quickemu" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # quickemu
      # quickgui
    ];
  };
}
