{
  config,
  lib,
  nixpkgs,
  ...
}: let
  cfg = config.traits.caddy;
in {
  options.traits.caddy.enable = lib.mkEnableOption "caddy";

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.caddy = {
      # acmeCA = "https://acme-v02.api.letsencrypt.org/directory"; # while in development
      enable = true;
      email = "pancho@pancho.name";
      logFormat = nixpkgs.lib.mkForce "level INFO";
      virtualHosts."canalplus.pancho.name".extraConfig = ''
        log
        root * /srv/http
        file_server /FF2E6E41-1FE8-4515-82D1-56D5C49EB2B5/* browse
      '';
    };
  };
}
