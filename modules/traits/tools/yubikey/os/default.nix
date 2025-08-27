{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.traits.os.yubikey;
in
{
  options.traits.os.yubikey = {
    enable = lib.mkEnableOption "YubiKey" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.gpgSmartcards.enable = true;

    services = {
      pcscd.enable = true;
      udev.packages = [ pkgs.yubikey-personalization ];
    };

    security = {
      pam = {
        u2f = {
          enable = true;
          settings.cue = true;
        };
        services = {
          login.u2fAuth = true;
          run0.u2fAuth = true;
        };
      };
    };
  };
}
