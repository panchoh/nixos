{
  config,
  lib,
  ...
}: let
  cfg = config.traits.doas;
in {
  options.traits.doas.enable = lib.mkEnableOption "doas";

  config = lib.mkIf cfg.enable {
    security = {
      sudo = {
        enable = false;
        execWheelOnly = true;
      };

      doas = {
        enable = true;
        extraRules = [
          {
            groups = ["wheel"];
            persist = true;
            # keepEnv = true;
            setEnv = ["LOCALE_ARCHIVE" "NIXOS_INSTALL_BOOTLOADER"];
          }
        ];
      };
    };
  };
}
