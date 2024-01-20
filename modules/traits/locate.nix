{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.locate;
in {
  options.traits.locate.enable = lib.mkEnableOption "locate";

  config = lib.mkIf cfg.enable {
    services.locate = {
      enable = true;
      package = pkgs.plocate;
      localuser = null;
    };
  };
}
