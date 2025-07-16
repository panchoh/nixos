{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.foot;
in
{
  options.traits.hm.foot = {
    enable = lib.mkEnableOption "foot" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      # For notify-send, used by programs.foot.settings.desktop-notifications.command’s default value
      pkgs.libnotify
    ];

    programs.foot = {
      enable = true;
      settings = {
        main = {
          pad = "4x4 center";
        };
        bell = {
          urgent = true;
          notify = true;
          visual = true;
        };
        mouse = {
          hide-when-typing = true;
        };
      };
    };
  };
}
