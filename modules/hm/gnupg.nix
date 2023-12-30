{
  config,
  lib,
  ...
}: let
  cfg = config.hm.gnupg;
in {
  options.hm.gnupg = {
    enable = lib.mkEnableOption "gnupg";
  };

  config = lib.mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      scdaemonSettings = {
        disable-ccid = true; # Play nice with yubikey https://ludovicrousseau.blogspot.com/2019/06/gnupg-and-pcsc-conflicts.html
        reader-port = "Yubico YubiKey CCID 00 00"; # Get this value with pcsc_scan
      };
      homedir = "${config.xdg.dataHome}/gnupg";
    };

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1;
      enableSshSupport = true;
      pinentryFlavor = "gnome3";
    };
  };
}
