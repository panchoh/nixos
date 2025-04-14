{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.os.console;
in {
  options.traits.os.console = {
    enable = lib.mkEnableOption "console" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    services.xserver.xkb = {
      model = "pc104";
      layout = "us,us";
      variant = "altgr-intl,colemak_dh";
      options = "lv3:ralt_switch_multikey,grp:alt_caps_toggle,nbsp:level3n,terminate:ctrl_alt_bksp";
    };

    console = {
      earlySetup = true;
      font = "ter-powerline-v24n";
      packages = [pkgs.powerline-fonts];
      useXkbConfig = true;
    };
  };
}
