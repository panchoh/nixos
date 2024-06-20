{
  config,
  lib,
  box ? null,
  ...
}: let
  cfg = config.traits.fwupd;
in {
  options.traits.fwupd = {
    enable = lib.mkEnableOption "fwupd" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    services.fwupd.enable = true;
  };
}
