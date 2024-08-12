{
  config,
  lib,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.mako;
in {
  options.traits.hm.mako = {
    enable = lib.mkEnableOption "mako" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    services.mako = {
      enable = true;
      borderRadius = 5;
    };
  };
}
