{
  config,
  lib,
  pkgs,
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
        main = {
          pad = "4x4 center";
        };
        bell = {
          urgent = true;
          notify = true;
          visual = true;
        };
        desktop-notifications = {
          command = "${lib.getExe pkgs.libnotify} -a \${app-id} -i \${app-id} \${title} \${body}";
        };
        mouse = {
          hide-when-typing = true;
        };
      };
    };
  };
}
