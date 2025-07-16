{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.typst;
in
{
  options.traits.hm.typst = {
    enable = lib.mkEnableOption "Typst" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.typst
      pkgs.typstyle
      pkgs.tinymist
    ];
  };
}
