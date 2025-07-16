{
  config,
  lib,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.qmk;
in
{
  options.traits.os.qmk = {
    enable = lib.mkEnableOption "qmk" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.keyboard.qmk.enable = true;
  };
}
