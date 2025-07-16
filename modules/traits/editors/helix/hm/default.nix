{
  config,
  lib,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.helix;
in
{
  options.traits.hm.helix = {
    enable = lib.mkEnableOption "helix" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.helix.enable = true;
  };
}
