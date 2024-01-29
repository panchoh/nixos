{
  config,
  lib,
  ...
}: let
  cfg = config.hm.fuzzel;
in {
  options.hm.fuzzel = {
    enable = lib.mkEnableOption "fuzzel" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = lib.mkForce "Iosevka:size=20:weight=ExtraLight";
          layer = "overlay";
          terminal = lib.getExe config.programs.foot.package;
        };
      };
    };
  };
}
