{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.git;
in {
  options.traits.git = {
    enable = lib.mkEnableOption "git" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.git
    ];
  };
}
