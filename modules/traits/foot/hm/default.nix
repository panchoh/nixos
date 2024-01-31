{
  config,
  lib,
  osConfig,
  ...
}: let
  cfg = config.hm.foot;
  size = toString osConfig.traits.font.terminal;
in {
  options.hm.foot = {
    enable = lib.mkEnableOption "foot" // {default = true;};
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