{
  config,
  lib,
  ...
}: let
  cfg = config.hm.imv;
in {
  options.hm.imv = {
    enable = lib.mkEnableOption "imv" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.imv = {
      enable = true;
      settings = {
        binds."<Shift+Delete>" = ''
          exec rm "$imv_current_file"; close
        '';
      };
    };
  };
}
