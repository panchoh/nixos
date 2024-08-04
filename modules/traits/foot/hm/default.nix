{
  config,
  lib,
  osConfig,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.foot;
  size = toString osConfig.stylix.fonts.sizes.terminal;
in {
  options.traits.hm.foot = {
    enable = lib.mkEnableOption "foot" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font-bold = lib.mkForce "IosevkaTerm NFM:size=${size}";
        };
        mouse = {
          hide-when-typing = true;
        };
      };
    };
  };
}
