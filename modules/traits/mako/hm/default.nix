{
  config,
  lib,
  ...
}: let
  cfg = config.traits.hm.mako;
in {
  options.traits.hm.mako = {
    enable = lib.mkEnableOption "mako" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    services.mako.enable = true;
  };
}
