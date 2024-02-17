{
  config,
  lib,
  ...
}: let
  cfg = config.traits.hm.helix;
in {
  options.traits.hm.helix = {
    enable = lib.mkEnableOption "helix" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.helix.enable = true;
  };
}
