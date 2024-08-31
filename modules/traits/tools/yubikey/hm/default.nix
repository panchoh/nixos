{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.hm.yubikey;
in {
  options.traits.hm.yubikey = {
    enable = lib.mkEnableOption "yubikey" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      pam_u2f
      pamtester
      libfido2

      opensc
      pcsctools
      ccid
      scmccid

      openssl

      pwgen

      yubico-piv-tool
      yubikey-manager
      yubikey-personalization
      yubikey-personalization-gui
      yubikey-touch-detector
      yubioath-flutter
    ];
  };
}
