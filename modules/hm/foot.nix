{
  config,
  lib,
  ...
}: let
  cfg = config.hm.foot;
in {
  options.hm.foot.enable = lib.mkEnableOption "foot";

  config.programs.foot = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      main = {
        font = lib.mkForce "IosevkaTerm NFM Light:size=14";
        font-bold = lib.mkForce "IosevkaTerm NFM:size=14";
      };
      mouse = {
        hide-when-typing = true;
      };
    };
  };
}
