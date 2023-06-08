# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  lib,
  pkgs,
  nixpkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

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
  powerManagement.cpuFreqGovernor = "performance";

  networking = {
    hostName = "helium";
    useDHCP = false;
  };

  systemd.network = {
    enable = true;
    netdevs = {
      "10-mv0" = {
        netdevConfig = {
          Name = "mv0";
          Kind = "macvlan";
          MACAddress = "1c:69:7a:02:8d:23";
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
      };
      "30-mv0" = {
        matchConfig.Name = "mv0";
        networkConfig = {
          DHCP = "ipv4";
          IPForward = true;
          LinkLocalAddressing = "no";
          LLMNR = false;
        };
        dhcpV4Config = {
          UseDomains = true;
        };
      };
    };
  };

  time.timeZone = "Europe/Madrid";

  hardware.opengl = {
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

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_DK.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_DK.UTF-8";
  };

  console = {
    earlySetup = true;
    font = "ter-powerline-v24b";
    packages = with pkgs; [terminus_font powerline-fonts];
    useXkbConfig = true;
  };

  # TTY
  #fonts.fonts = with pkgs; [ meslo-lgs-nf iosevka ];
  #services.kmscon =
  #{
  #  enable = true;
  #  hwRender = true;
  #    #font-name=MesloLGS NF
  #  extraConfig =
  #  ''
  #    font-name=Iosevka
  #    font-size=20
  #  '';
  #};

  services.fwupd.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkbModel = "hhk";
    layout = "us,us";
    xkbVariant = "altgr-intl,dvorak-alt-intl";
    xkbOptions = "compose:sclk,grp:shifts_toggle";
    # videoDrivers = [ "intel" ];
  };

  # FIXME Enable CUPS to print documents.
  # services.printing.enable = true;

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

  stylix = {
    homeManagerIntegration.followSystem = false;
    homeManagerIntegration.autoImport = false;
    # Either image or base16Scheme is required
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pancho = {
    isNormalUser = true;
    description = "pancho horrillo";
    extraGroups = ["wheel" "libvirtd" "docker" "audio"];
    shell = pkgs.fish;
    packages = with pkgs; [
      # (nerdfonts.override {fonts = ["Iosevka"];})
    ];
    initialPassword = "password";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5ZMOJffWIhs9I71atUuzjfDBRTkKml/0sCewKBIGNo pancho@krypton"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOK1QiBQzjzVDZoyWwewN8U0B6QRn09dasbcyTI48dWL pancho@ipad"
    ];
  };
  services.getty.autologinUser = "pancho";

  nix = {
    registry.nixpkgs.flake = nixpkgs;
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
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

  # FIXME: add this via HM
  # xdg.portal.wlr.enable = true;
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

  programs.mosh.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
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

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  services.resolved.enable = true;
  services.resolved.llmnr = "false";
  #services.resolved.domains = ["home"];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  services.fail2ban.enable = true;

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
      keepEnv = true;
    }
  ];
  security.sudo.enable = false;
  security.sudo.execWheelOnly = true;

  system.stateVersion = "23.05";
}
