{
  config,
  lib,
  ...
}: let
  cfg = config.hm.helix;
in {
  options.hm.helix = {
    enable = lib.mkEnableOption "helix" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.helix.enable = true;
  };
}
