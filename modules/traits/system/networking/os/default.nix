{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.networking;
in
{
  options.traits.os.networking = {
    enable = lib.mkEnableOption "networking" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = lib.optionals (box.isLaptop or false) [
      pkgs.iw
      pkgs.iwgtk
    ];

    programs = {
      mtr.enable = true;
      mtr.package = pkgs.mtr-gui;
    };

    networking = {
      hostName = box.hostName or "nixos";
      useDHCP = false;
      enableIPv6 = false;
      wireless.iwd.enable = box.isLaptop or false;
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
      wait-online.anyInterface = box.isLaptop or false;
      netdevs = {
        "10-mv0" = {
          netdevConfig = {
            Name = "mv0";
            Kind = "macvlan";
            MACAddress = box.macvlanAddr or "de:ad:be:ef:42:01";
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
          macvlan = [ "mv0" ];
          networkConfig = {
            LinkLocalAddressing = "no";
          };
          linkConfig.RequiredForOnline = "no";
        };
        "30-mv0" = {
          matchConfig.Name = "mv0";
          networkConfig = {
            DHCP = "ipv4";
            IPv4Forwarding = true;
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
