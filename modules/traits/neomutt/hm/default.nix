{
  config,
  lib,
  ...
}: let
  cfg = config.traits.hm.neomutt;
in {
  options.traits.hm.neomutt = {
    enable = lib.mkEnableOption "NeoMutt" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.neomutt.enable = true;
  };
}
