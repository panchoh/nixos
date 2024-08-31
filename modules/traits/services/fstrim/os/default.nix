{
  config,
  lib,
  ...
}: let
  cfg = config.traits.os.fstrim;
in {
  options.traits.os.fstrim = {
    enable = lib.mkEnableOption "fstrim" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    services.fstrim.enable = true;
  };
}
