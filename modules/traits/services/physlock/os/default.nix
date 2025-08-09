{
  config,
  lib,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.physlock;
in
{
  options.traits.os.physlock = {
    enable = lib.mkEnableOption "physlock" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.physlock.enable = true;
  };
}
