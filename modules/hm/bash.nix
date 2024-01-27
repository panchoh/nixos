{
  config,
  lib,
  ...
}: let
  cfg = config.hm.bash;
in {
  options.hm.bash.enable = lib.mkEnableOption "bash" // {default = true;};

  config = lib.mkIf cfg.enable {
    programs.bash.enable = true;
  };
}
