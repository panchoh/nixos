{
  config,
  lib,
  ...
}: let
  cfg = config.traits.fwupd;
in {
  options.traits.fwupd = {
    enable = lib.mkEnableOption "fwupd" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    services.fwupd.enable = true;
  };
}
