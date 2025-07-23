{
  config,
  lib,
  nixosConfig,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.fuzzel;
  size = toString (nixosConfig.stylix.fonts.sizes.desktop + 2);
in
{
  options.traits.hm.fuzzel = {
    enable = lib.mkEnableOption "fuzzel" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = lib.mkForce "Iosevka Comfy Duo:size=${size}:weight=extralight";
          layer = "overlay";
          terminal = lib.getExe config.programs.foot.package;
        };
      };
    };
  };
}
