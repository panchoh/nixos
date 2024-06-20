{
  config,
  lib,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.k9s;
in {
  options.traits.hm.k9s = {
    enable = lib.mkEnableOption "k9s" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    programs.k9s.enable = true;
  };
}
