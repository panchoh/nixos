{
  config,
  lib,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.fuzzel;
in {
  options.traits.hm.fuzzel = {
    enable = lib.mkEnableOption "fuzzel" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = lib.mkForce "Iosevka Comfy Duo:size=26:weight=extralight";
          layer = "overlay";
          terminal = lib.getExe config.programs.foot.package;
        };
      };
    };
  };
}
