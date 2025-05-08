{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.gnupg;

  # Matches 6-hex-digit RGB or 8-hex-digit RGBA values
  colourHexPattern = "^[0-9a-fA-F]{6}([0-9a-fA-F]{2})?$";

  isColourHex = str: builtins.match colourHexPattern str != null;

  iniFormat = pkgs.formats.ini {
    mkKeyValue = lib.generators.mkKeyValueDefault {
      mkValueString = v:
        if lib.isString v
        then
          (
            if isColourHex v
            then "0x${lib.strings.toUpper v};"
            else ''"${v}";''
          )
        else lib.generators.mkValueStringDefault {} v + ";";
    } " = ";
  };
in {
  options.traits.hm.gnupg = {
    enable = lib.mkEnableOption "gnupg" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    home.file."${config.xdg.configHome}/wayprompt/config.ini".source = iniFormat.generate "config.ini" {
      general = {
        pin-square-amount = 32;
      };
      colours = {
        background = "ffffffaa";
      };
    };

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
      verbose = true;
      defaultCacheTtl = 1;
      defaultCacheTtlSsh = 1;
      maxCacheTtl = 1;
      maxCacheTtlSsh = 1;
      enableSshSupport = true;
      pinentry.package = pkgs.wayprompt;
      extraConfig = ''
        no-allow-loopback-pinentry
      '';
    };
  };
}
