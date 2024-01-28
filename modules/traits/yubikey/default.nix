{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.yubikey;
in {
  options.traits.yubikey = {
    enable = lib.mkEnableOption "YubiKey" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # FIXME: fix pcscd
      # https://github.com/NixOS/nixpkgs/issues/280826
      pcscliteWithPolkit.out
    ];

    services = {
      pcscd.enable = true;
      udev.packages = [pkgs.yubikey-personalization];
    };

    # security.pam.u2f.enable = true;
    # security.pam.u2f.cue = true;
    security.pam.services = {
      login.u2fAuth = true;
      doas.u2fAuth = true;
      sudo.u2fAuth = true;
    };
  };
}
