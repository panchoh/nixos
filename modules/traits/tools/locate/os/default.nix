{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.locate;
in
{
  options.traits.os.locate = {
    enable = lib.mkEnableOption "locate" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.locate = {
      enable = true;
      package = pkgs.plocate;
    };
  };
}
