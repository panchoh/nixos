{
  config,
  lib,
  pkgs,
  attrs ? null,
  ...
}: let
  cfg = config.traits.networking;
in {
  options.traits.networking.enable = lib.mkEnableOption "networking";

  config = lib.mkIf cfg.enable {
    programs = {
      mtr.enable = true;
      mtr.package = pkgs.mtr-gui;
    };

    networking = {
      hostName = attrs.hostName or "nixos";
      useDHCP = false;
      enableIPv6 = false;
      wireless.iwd.enable = attrs.isLaptop or false;
      firewall.allowedTCPPorts = [
        51413 # transmission-gtk
      ];
    };

    services = {
      fail2ban.enable = true;
      resolved = {
        enable = true;
        dnssec = "true";
        llmnr = "false";
      };
    };

    systemd.network = {
      enable = true;
      wait-online.anyInterface = attrs.isLaptop or false;
      netdevs = {
        "10-mv0" = {
          netdevConfig = {
            Name = "mv0";
            Kind = "macvlan";
            MACAddress = attrs.macvlanAddr or "de:ad:be:ef:42:01";
          };
          macvlanConfig = {
            Mode = "bridge";
          };
        };
      };
      networks = {
        "10-wl" = {
          matchConfig.Name = "wl*";
          networkConfig = {
            DHCP = "ipv4";
            LinkLocalAddressing = "no";
            DNSSECNegativeTrustAnchors = "lemd wifi";
            IgnoreCarrierLoss = "3s";
            # DefaultRouteOnDevice = true;
          };
          linkConfig.RequiredForOnline = "no";
          dhcpV4Config = {
            UseDomains = true;
            RouteMetric = 600;
          };
        };
        "20-en" = {
          matchConfig.Name = "en*";
          macvlan = ["mv0"];
          networkConfig = {
            LinkLocalAddressing = "no";
          };
          linkConfig.RequiredForOnline = "no";
        };
        "30-mv0" = {
          matchConfig.Name = "mv0";
          networkConfig = {
            DHCP = "ipv4";
            IPForward = true;
            LinkLocalAddressing = "no";
            DNSSECNegativeTrustAnchors = "lemd wifi";
          };
          dhcpV4Config = {
            UseDomains = true;
            RouteMetric = 100;
          };
        };
      };
    };
  };
}
