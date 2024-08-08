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
          font = lib.mkForce "Iosevka Europa Term:size=${size}";
          font-bold = lib.mkForce "Iosevka Europa Term:size=${size}";
        };
        mouse = {
          hide-when-typing = true;
        };
      };
    };
  };
}
