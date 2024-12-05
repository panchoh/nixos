{
  config,
  lib,
  ...
}: let
  cfg = config.traits.os.systemd;
in {
  options.traits.os.systemd = {
    enable = lib.mkEnableOption "systemd" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      enableStrictShellChecks = true;
    };

    security.pam.services.systemd-run0 = {};
  };
}
