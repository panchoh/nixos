{
  config,
  lib,
  ...
}: let
  cfg = config.traits.qmk;
in {
  options.traits.qmk = {
    enable = lib.mkEnableOption "qmk" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    hardware.keyboard.qmk.enable = true;
  };
}
