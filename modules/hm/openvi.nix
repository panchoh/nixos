{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hm.openvi;
in {
  options = {
    hm.openvi.enable = lib.mkEnableOption "openvi";
  };

  config = lib.mkIf cfg.enable {
    home = {
      activation = {
        addDotExrc = lib.hm.dag.entryAfter ["writeBoundary"] ''
          verboseEcho Setting up .exrc
          run echo set verbose showmode number tabstop=2 shiftwidth=2 expandtab > $HOME/.exrc
        '';
      };
      packages = [pkgs.openvi];
    };
  };
}
