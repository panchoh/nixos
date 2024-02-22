{
  config,
  lib,
  ...
}: let
  cfg = config.traits.hm.gnupg;
in {
  options.traits.hm.gnupg = {
    enable = lib.mkEnableOption "gnupg" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      scdaemonSettings = {
        disable-ccid = true; # Play nice with yubikey https://ludovicrousseau.blogspot.com/2019/06/gnupg-and-pcsc-conflicts.html
        pcsc-shared = true; # Play nice with the rest of OpenSC-based tools
        reader-port = "Yubico YubiKey CCID 00 00"; # Get this value with pcsc_scan
        disable-application = "piv"; # Allow gpg-agent to cache the PIN between operations https://bugzilla.redhat.com/show_bug.cgi?id=2018237 https://dev.gnupg.org/T5436
      };
      homedir = "${config.xdg.dataHome}/gnupg";
    };

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1;
      enableSshSupport = true;
      pinentryFlavor = "gnome3";
      extraConfig = ''
        allow-emacs-pinentry
      '';
    };
  };
}
