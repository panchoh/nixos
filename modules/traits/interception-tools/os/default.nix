{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.os.interception-tools;
in {
  options.traits.os.interception-tools = {
    enable = lib.mkEnableOption "Interception Tools" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    environment.etc."interception/dual-function-keys/hhkb.yaml".source = pkgs.writeText "hhkb.yaml" ''
      TIMING:
        TAP_MILLISEC: 200
        DOUBLE_TAP_MILLISEC: 150

      MAPPINGS:
        - KEY: KEY_LEFTCTRL
          TAP: KEY_ESC
          HOLD: KEY_LEFTCTRL
        - KEY: KEY_LEFTSHIFT
          TAP: KEY_KPLEFTPAREN
          HOLD: KEY_LEFTSHIFT
        - KEY: KEY_RIGHTSHIFT
          TAP: KEY_KPRIGHTPAREN
          HOLD: KEY_RIGHTSHIFT
    '';

    services.interception-tools = {
      enable = true;
      plugins = [
        pkgs.interception-tools-plugins.caps2esc
        pkgs.interception-tools-plugins.dual-function-keys
      ];
      udevmonConfig = ''
        - JOB: >-
            ${lib.getExe' pkgs.interception-tools "intercept"} -g $DEVNODE
            | ${lib.getExe pkgs.interception-tools-plugins.caps2esc} -m 1
            | ${lib.getExe' pkgs.interception-tools "uinput"} -d $DEVNODE
          DEVICE:
            LINK: /dev/input/by-path/platform-i8042-serio-0-event-kbd
            EVENTS:
              EV_KEY: [KEY_CAPSLOCK]
        - JOB: >-
            ${lib.getExe' pkgs.interception-tools "intercept"} -g $DEVNODE
            | ${lib.getExe pkgs.interception-tools-plugins.dual-function-keys} -c /etc/interception/dual-function-keys/hhkb.yaml
            | ${lib.getExe' pkgs.interception-tools "uinput"} -d $DEVNODE
          DEVICE:
            NAME: PFU Limited HHKB-Classic
            EVENTS:
              EV_KEY: [KEY_LEFTCTRL,KEY_LEFTSHIFT,KEY_RIGHTSHIFT]
      '';
    };
  };
}
