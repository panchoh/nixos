{
  config,
  lib,
  ...
}: let
  cfg = config.hm.imv;
in {
  options.hm.imv.enable = lib.mkEnableOption "imv";

  config.programs.imv = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      binds."<Shift+Delete>" = ''
        exec rm "$imv_current_file"; close
      '';
    };
  };
}
