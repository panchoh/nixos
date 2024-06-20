{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.console;
in {
  options.traits.console = {
    enable = lib.mkEnableOption "console" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    services.xserver.xkb = {
      model = "pc105";
      layout = "us,us";
      variant = "altgr-intl,dvorak-alt-intl";
      options = "lv3:ralt_switch_multikey,grp:caps_toggle";
    };

    console = {
      earlySetup = true;
      font = "ter-powerline-v24n";
      packages = [pkgs.powerline-fonts];
      useXkbConfig = true;
    };
  };
}
