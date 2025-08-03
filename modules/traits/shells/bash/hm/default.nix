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
    enable = lib.mkEnableOption "Bash" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      bash.enable = true;
      readline = {
        enable = true;
        variables.bell-style = "visible";
      };
    };
  };
}
