{
  config,
  lib,
  pkgs,
  nixpkgs,
  nixos-hardware,
  disko,
  stylix,
  autofirma-nix,
  home-manager,
  attrs ? null,
  ...
} @ inputs: {
  imports = [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.intel-nuc-8i7beh
    ./usb-misc.nix
    ./usb-drives.nix
    ./media-drive.nix
    disko.nixosModules.default
    ./disko-config.nix
    stylix.nixosModules.stylix
    home-manager.nixosModules.default
    {
      home-manager = {
        backupFileExtension = "backup";
        verbose = true;
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit stylix autofirma-nix attrs;
        };
        users.${attrs.userName or "alice"} = import ./home.nix;
      };
    }
  ];

  system.stateVersion = "23.11";

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
        # https://nixos.wiki/wiki/Accelerated_Video_Playback
        intel-ocl
        intel-compute-runtime
        intel-media-driver
        intel-vaapi-driver
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
      LC_TIME = "en_DK.UTF-8"; # yes, that means ISO-8601 ;-)
    };
  };

  # https://docs.kernel.org/admin-guide/pm/intel_epb.html
  # https://bbs.archlinux.org/viewtopic.php?id=270199
  # https://stackoverflow.com/questions/58243712/how-to-install-systemd-service-on-nixos
  # cat /sys/devices/system/cpu/cpu*/power/energy_perf_bias
  systemd.services.epb = {
    enable = true;
    description = "Run x86_energy_perf_policy at boot";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStartPre = "${lib.getExe' pkgs.kmod "modprobe"} msr";
      ExecStart = "${lib.getExe' pkgs.linuxPackages_latest.x86_energy_perf_policy "x86_energy_perf_policy"} performance";
      ExecStartPost = "${lib.getExe' pkgs.kmod "modprobe"} -r msr";
    };
  };

  services.physlock.enable = true;

  services.dbus.implementation = "broker";
  services.dbus.packages = [pkgs.gcr]; # for pinentry-gnome3

  services.xserver.xkb = {
    model = "pc105";
    layout = "us,us";
    variant = "altgr-intl,dvorak-alt-intl";
    options = "compose:sclk,grp:shifts_toggle";
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
    # TODO: report issue upstream (single font requires trailing comma)
    fonts = lib.mkBefore [
      {
        # name = "IosevkaTerm NFM Light,"; # commas save lives!
        name = "IosevkaTerm NFM Light";
        package = pkgs.nerdfonts.override {fonts = ["IosevkaTerm"];};
      }
    ];
  };

  services.locate = {
    enable = true;
    package = pkgs.plocate;
    localuser = null;
  };

  services.fwupd.enable = true;

  services.printing = {
    enable = true;
    drivers = [pkgs.hplip];
  };

  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBhtv6KrJc04bydU2mj6j/V6g/g+RiY1+gTg9h4z3STm pancho"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOK1QiBQzjzVDZoyWwewN8U0B6QRn09dasbcyTI48dWL pancho@ipad"
    ];
  };

  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${lib.getExe config.programs.hyprland.finalPackage} &>~/.Wsession.errors";
        user = attrs.userName or "alice";
      };
      default_session = initial_session;
    };
  };

  nix = {
    channel.enable = false;
    registry.nixpkgs.flake = nixpkgs;
    settings = {
      auto-optimise-store = true;
      use-xdg-base-directories = true;
      experimental-features = ["nix-command" "flakes" "repl-flake"];
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    wget
  ];

  programs.command-not-found.enable = false;
  programs.mtr.enable = true;
  programs.nano.enable = false;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    configure = {
      customRC = ''
        set mouse=
      '';
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
    source = lib.getExe' pkgs.intel-gpu-tools "intel_gpu_top";
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

  # security.pam.u2f.enable = true;
  security.pam.services = {
    login.u2fAuth = true;
    doas.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  services.fstrim.enable = true;
}
