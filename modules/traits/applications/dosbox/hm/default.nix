{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.dosbox;
in
{
  options.traits.hm.dosbox = {
    enable = lib.mkEnableOption "DOSBox Staging" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.dosbox-staging ];
  };
}
