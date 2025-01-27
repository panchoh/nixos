{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.os.locate;
in {
  options.traits.os.locate = {
    enable = lib.mkEnableOption "locate" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    services.locate = {
      enable = true;
      package = pkgs.plocate;
    };
  };
}
