{
  config,
  lib,
  ...
}: let
  cfg = config.traits.fish;
in {
  options.traits.fish.enable = lib.mkEnableOption "fish";

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
