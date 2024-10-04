{
  config,
  lib,
  box ? null,
  ...
}: let
  cfg = config.traits.os.fwupd;
in {
  options.traits.os.fwupd = {
    enable = lib.mkEnableOption "fwupd" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    services.fwupd.enable = true;
  };
}
