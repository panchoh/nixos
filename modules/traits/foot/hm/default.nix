{
  config,
  lib,
  osConfig,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.foot;
  size = toString osConfig.traits.font.terminal;
in {
  options.traits.hm.foot = {
    enable = lib.mkEnableOption "foot" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = lib.mkForce "IosevkaTerm NFM Light:size=${size}";
          font-bold = lib.mkForce "IosevkaTerm NFM:size=${size}";
        };
        mouse = {
          hide-when-typing = true;
        };
      };
    };
  };
}
