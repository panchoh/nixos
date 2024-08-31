{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.hm.openvi;
in {
  options.traits.hm.openvi = {
    enable = lib.mkEnableOption "openvi" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [pkgs.openvi];
      activation = {
        addOviDotExrc = lib.hm.dag.entryAfter ["writeBoundary"] ''
          verboseEcho Setting up .exrc
          run echo set verbose showmode number tabstop=2 shiftwidth=2 expandtab > $HOME/.exrc
        '';
      };
    };
  };
}
