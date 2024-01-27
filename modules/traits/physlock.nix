{
  config,
  lib,
  ...
}: let
  cfg = config.traits.physlock;
in {
  options.traits.physlock = {
    enable = lib.mkEnableOption "physlock" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    services.physlock.enable = true;
  };
}
