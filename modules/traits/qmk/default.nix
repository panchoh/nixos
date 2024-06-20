{
  config,
  lib,
  box ? null,
  ...
}: let
  cfg = config.traits.qmk;
in {
  options.traits.qmk = {
    enable = lib.mkEnableOption "qmk" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    hardware.keyboard.qmk.enable = true;
  };
}
