{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.traits.os.git;
in
{
  options.traits.os.git = {
    enable = lib.mkEnableOption "git" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.git
    ];
  };
}
