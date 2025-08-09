{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.qmk;
in
{
  options.traits.hm.qmk = {
    enable = lib.mkEnableOption "QMK" // {
      default = box.isStation or false;
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
