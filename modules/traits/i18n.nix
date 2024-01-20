{
  config,
  lib,
  ...
}: let
  cfg = config.traits.i18n;
in {
  options.traits.i18n.enable = lib.mkEnableOption "i18n";
  config.i18n = lib.mkIf cfg.enable {
    extraLocaleSettings = {
      LC_MEASUREMENT = "en_DK.UTF-8"; # m, not in
      LC_MONETARY = "en_IE.UTF-8"; # €, not $
      LC_PAPER = "en_DK.UTF-8"; # DIN A4, not legal
      LC_TIME = "en_DK.UTF-8"; # yes, that means ISO-8601 ;-)
    };
  };
}
