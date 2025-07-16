{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.traits.hm.qmk;
in
{
  options.traits.hm.qmk = {
    enable = lib.mkEnableOption "qmk" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      qmk
      qmk_hid
      keymapviz
      clang-tools
      dfu-programmer
      dfu-util
    ];
  };
}
