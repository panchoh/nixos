# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  lib,
  pkgs,
  nixpkgs,
  nixos-hardware,
  disko,
  stylix,
  hyprland,
  home-manager,
  attrs ? null,
  ...
} @ inputs: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.intel-nuc-8i7beh
    ./usb-misc.nix
    ./usb-drives.nix
    disko.nixosModules.default
    ./disko-config.nix
    stylix.nixosModules.stylix
    hyprland.nixosModules.default
    home-manager.nixosModules.home-manager
    {
      home-manager = {
        verbose = true;
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit stylix hyprland attrs;
        };
        users.${attrs.userName or "alice"} = import ./home.nix;
      };
    }
  ];

  system.stateVersion = "23.05";

  stylix = {
    homeManagerIntegration.followSystem = false;
    homeManagerIntegration.autoImport = false;
    # Either image or base16Scheme is required
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
    fonts.sizes.terminal = 16;
  };

  boot.loader.timeout = 0;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "keep";
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["quiet" "loglevel=3" "systemd.show_status=auto" "udev.log_level=3"];
  boot.initrd.kernelModules = ["i915" "btrfs"];
  boot.initrd.verbose = false;
  boot.initrd.systemd.enable = true;
  boot.consoleLogLevel = 0;
  boot.plymouth.enable = true;

  # system.autoUpgrade.enable = true;
  # system.autoUpgrade.allowReboot = true;
  # system.autoUpgrade.flake = "github:panchoh/nixos-flake-sandbox";
  # system.autoUpgrade.flags = [ "--update-input" "nixpkgs" "--commit-lock-file" ];

  networking = {
    hostName = attrs.hostName or "nixos";
    useDHCP = false;
  };

  systemd.network = {
    enable = true;
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
      "20-eno1" = {
        matchConfig.Name = "eno1";
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
        };
      };
    };
  };

  time.timeZone = "Europe/Madrid";

  hardware = {
    keyboard.qmk.enable = true;
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-ocl
        intel-compute-runtime
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_DK.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_DK.UTF-8";
      LC_MONETARY = "en_IE.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_DK.UTF-8";
      LC_TELEPHONE = "en_DK.UTF-8";
      LC_TIME = "en_DK.UTF-8";
    };
  };

  services.physlock.enable = true;

  services.xserver = {
    xkbModel = "pc105";
    layout = "us,us";
    xkbVariant = "altgr-intl,dvorak-alt-intl";
    xkbOptions = "compose:sclk,grp:shifts_toggle";
  };

  console = {
    earlySetup = true;
    font = "ter-powerline-v24n";
    packages = [pkgs.powerline-fonts];
    useXkbConfig = true;
  };

  services.kmscon = {
    enable = true;
    hwRender = true;
    autologinUser = attrs.userName or "alice";
    extraOptions = "--xkb-layout=us --xkb-variant=altgr-intl";
    fonts = [
      {
        name = "IosevkaTerm NFM Light,"; # commas save lives!
        package = pkgs.nerdfonts.override {fonts = ["IosevkaTerm"];};
      }
    ];
  };

  services.locate = {
    enable = true;
    locate = pkgs.plocate;
    localuser = null;
  };

  services.fwupd.enable = true;

  services.printing = {
    enable = true;
    drivers = [pkgs.hplip];
  };

  # Enable sound with pipewire.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # handled by stylix
  # https://github.com/danth/stylix/blob/master/stylix/nixos/fonts.nix
  # fonts = {
  #   # enableDefaultFonts = true;
  #   fonts = with pkgs; [iosevka-bin openmoji-color];
  #   fontconfig = {
  #     defaultFonts = {
  #       serif = ["Iosevka Etoile"];
  #       sansSerif = ["Iosevka Aile"];
  #       monospace = ["Iosevka Term"];
  #       emoji = ["OpenMoji Color"];
  #     };
  #   };
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.mutableUsers = false;
  users.groups."storage".members = [attrs.userName or "alice"];
  users.users.${attrs.userName or "alice"} = {
    isNormalUser = true;
    description = attrs.userDesc or "Alice Q. User";
    extraGroups = ["wheel" "libvirtd" "docker" "audio"];
    shell = pkgs.fish;
    initialPassword = "password";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5ZMOJffWIhs9I71atUuzjfDBRTkKml/0sCewKBIGNo pancho@krypton"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOK1QiBQzjzVDZoyWwewN8U0B6QRn09dasbcyTI48dWL pancho@ipad"
    ];
  };

  programs.hyprland.enable = true;

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${lib.getBin hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland}/bin/Hyprland &>~/.Wsession.errors";
        user = attrs.userName or "alice";
      };
      default_session = initial_session;
    };
  };

  nix = {
    registry.nixpkgs.flake = nixpkgs;
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes repl-flake
    '';
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    wget
  ];

  programs.command-not-found.enable = false;
  programs.mtr.enable = true;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    configure = {
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [vim-nix];
      };
    };
  };
  environment.variables.EDITOR = "nvim";

  programs.fish = {
    enable = true;
    useBabelfish = true;
    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

  virtualisation.libvirtd.enable = true;
  #virtualisation.docker.enable = true; # FIXME
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;

  programs.mosh.enable = true;
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  services.resolved = {
    enable = true;
    dnssec = "true";
    llmnr = "false";
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
    51413
  ];

  services.fail2ban.enable = true;

  services.caddy = {
    # acmeCA = "https://acme-v02.api.letsencrypt.org/directory"; # while in development
    enable = false;
    email = "pancho@pancho.name";
    logFormat = nixpkgs.lib.mkForce "level INFO";
    virtualHosts."canalplus.pancho.name".extraConfig = ''
      log
      root * /srv/http
      file_server /FF2E6E41-1FE8-4515-82D1-56D5C49EB2B5/* browse
    '';
  };

  services.pcscd.enable = true;

  security.wrappers.intel_gpu_top = {
    source = "${lib.getBin pkgs.intel-gpu-tools}/bin/intel_gpu_top";
    owner = "root";
    group = "root";
    capabilities = "cap_perfmon+ep";
  };
  security.doas.enable = true;
  security.doas.extraRules = [
    {
      groups = ["wheel"];
      persist = true;
    }
  ];
  security.sudo.enable = false;
  security.sudo.execWheelOnly = true;

  services.fstrim.enable = true;
}
