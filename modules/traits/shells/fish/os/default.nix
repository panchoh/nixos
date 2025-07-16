{
  config,
  lib,
  ...
}:
let
  cfg = config.traits.os.fish;
in
{
  options.traits.os.fish = {
    enable = lib.mkEnableOption "fish" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      useBabelfish = true;
      interactiveShellInit = ''
        set -g fish_greeting
      '';
    };
  };
}
