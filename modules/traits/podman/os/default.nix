{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.os.podman;
in {
  options.traits.os.podman = {
    enable = lib.mkEnableOption "podman" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.dive
      pkgs.podman-tui
      pkgs.podman-compose
    ];

    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
