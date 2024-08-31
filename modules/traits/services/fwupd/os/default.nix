{
  config,
  lib,
  box ? null,
  ...
}: let
  cfg = config.traits.os.fwupd;
in {
  options.traits.os.fwupd = {
    enable = lib.mkEnableOption "fwupd" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    services.fwupd.enable = true;
  };
}
