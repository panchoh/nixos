{
  config,
  lib,
  ...
}: let
  cfg = config.hm.mako;
in {
  options.hm.mako.enable = lib.mkEnableOption "mako" // {default = true;};

  config = lib.mkIf cfg.enable {
    services.mako.enable = true;
  };
}
