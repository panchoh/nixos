{
  config,
  lib,
  ...
}:
let
  cfg = config.traits.hm.bash;
in
{
  options.traits.hm.bash = {
    enable = lib.mkEnableOption "bash" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.bash.enable = true;
  };
}
