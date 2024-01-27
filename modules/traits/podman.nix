{
  config,
  lib,
  ...
}: let
  cfg = config.traits.podman;
in {
  options.traits.podman = {
    enable = lib.mkEnableOption "podman";
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
      };
    };
  };
}
