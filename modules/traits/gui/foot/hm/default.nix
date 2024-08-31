{
  config,
  lib,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.foot;
in {
  options.traits.hm.foot = {
    enable = lib.mkEnableOption "foot" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    programs.foot = {
      enable = true;
      settings = {
        mouse = {
          hide-when-typing = true;
        };
      };
    };
  };
}
