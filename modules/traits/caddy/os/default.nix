{
  config,
  lib,
  box ? null,
  ...
}: let
  cfg = config.traits.os.caddy;
in {
  options.traits.os.caddy = {
    enable = lib.mkEnableOption "caddy" // {default = false;};
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.caddy = {
      # acmeCA = "https://acme-v02.api.letsencrypt.org/directory"; # while in development
      enable = true;
      email = box.userEmail;
      logFormat = lib.mkForce "level INFO";
      virtualHosts."${box.virtualHost}".extraConfig = ''
        log
        root * /srv/http
        file_server /${box.virtualHostRoot}/* browse
      '';
    };
  };
}
