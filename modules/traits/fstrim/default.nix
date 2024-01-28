{
  config,
  lib,
  ...
}: let
  cfg = config.traits.fstrim;
in {
  options.traits.fstrim = {
    enable = lib.mkEnableOption "fstrim" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    services.fstrim.enable = true;
  };
}
