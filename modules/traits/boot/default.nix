{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.boot;
in {
  options.traits.boot = {
    enable = lib.mkEnableOption "boot" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    boot = {
      tmp.useTmpfs = true;

      loader = {
        efi.canTouchEfiVariables = true;
        timeout = 0;
        systemd-boot = {
          enable = true;
          consoleMode = "keep";
          memtest86.enable = true;
          configurationLimit = 5;
        };
      };

      kernelPackages = pkgs.linuxPackages_latest;

      kernelParams = ["quiet" "loglevel=3" "systemd.show_status=auto" "udev.log_level=3"];

      initrd = {
        verbose = false;
        systemd.enable = true;
        kernelModules = ["i915" "btrfs"];
      };

      consoleLogLevel = 0;

      plymouth.enable = true;
    };
  };
}
