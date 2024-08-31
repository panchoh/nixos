{
  config,
  lib,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.neomutt;
in {
  options.traits.hm.neomutt = {
    enable = lib.mkEnableOption "NeoMutt" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    programs.neomutt.enable = true;
  };
}
