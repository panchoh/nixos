# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  nixpkgs,
  ...
}: let
  emacsWithPgtk = pkgs.emacs.override {withPgtk = true;};
  emacsWithPackages = (pkgs.emacsPackagesFor emacsWithPgtk).emacsWithPackages;
  customEmacs = emacsWithPackages (epkgs: with epkgs.melpaPackages; [magit pdf-tools vterm dracula-theme]);
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  #boot.loader.timeout = null;
  boot.loader.timeout = 0;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "keep";
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.efi.efiSysMountPoint = "/boot";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["quiet" "loglevel=3" "systemd.show_status=auto" "udev.log_level=3"];
  # boot.initrd.kernelModules = [ "btrfs" ];
  boot.initrd.verbose = false;
  # EXPERIMENTAL:
  boot.initrd.systemd.enable = true;
  boot.consoleLogLevel = 0;
  boot.plymouth.enable = true;

  # system.autoUpgrade.enable = true;
  # system.autoUpgrade.allowReboot = true;
  # system.autoUpgrade.flake = "github:panchoh/nixos-flake-sandbox";
  # system.autoUpgrade.flags = [ "--update-input" "nixpkgs" "--commit-lock-file" ];
  powerManagement.cpuFreqGovernor = "performance";

  networking.usePredictableInterfaceNames = false;
  networking.enableIPv6 = false;
  networking.hostName = "helium"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.useNetworkd = true;
  networking.search = ["home"];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  # networking.networkmanager.enable = true;

  # Set your time zone.
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

  # Enable the X11 windowing system.
  #services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  #services.xserver = {
  #  xkbModel = "hhk";
  #  layout = "us,us";
  #  xkbVariant = "altgr-intl,dvorak-alt-intl";
  #  xkbOptions = "compose:sclk,grp:shifts_toggle";
  #  videoDrivers = [ "intel" ];
  #};
  # Configure keymap in X11
  services.xserver = {
    xkbModel = "hhk";
    layout = "us,us";
    xkbVariant = "altgr-intl,dvorak-alt-intl";
    xkbOptions = "compose:sclk,grp:shifts_toggle";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
    wireplumber.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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
  # TOTEST
  # https://discourse.nixos.org/t/advice-needed-installing-doom-emacs/8806/8

  # nixpkgs.config.packageOverrides = pkgs: {
  # emacs = pkgs.emacs.override { withPgtk = true; };
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
    description = "pancho";
    extraGroups = ["wheel" "libvirtd" "docker" "audio"];
    shell = pkgs.fish;
    packages = with pkgs; [
      # dracula-theme
      bat
      chromium
      firefox
      starship
      babelfish
      #### (nerdfonts.override {fonts = ["Iosevka"];})
      # https://nixos.org/manual/nixos/stable/#sec-customising-packages
      # https://git.sr.ht/~glorifiedgluer/monorepo/tree/a0748af498a7eaa25f227145de7b4e31a63a63d6/item/dotfiles/home/doom/default.nix
      #(emacs.override { withPgtk = true; })
      customEmacs
      emacs-all-the-icons-fonts
      fd
      ripgrep
      pavucontrol
      fuzzel
    ];
    initialPassword = "password";
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5ZMOJffWIhs9I71atUuzjfDBRTkKml/0sCewKBIGNo pancho@krypton"];
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
      experimental-features = nix-command flakes
    '';
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      foot
      foot.themes
      swaylock
      swayidle
      wofi
      mako
      dracula-theme
      grim
      slurp
      wl-clipboard
      wev
    ];
  };
  environment.etc = {
    "sway/config".source = sway/config;
    "xdg/foot/foot.ini".text = ''
      include=${pkgs.foot.themes}/share/foot/themes/dracula
      [main]
      font=Iosevka:weight=Light:size=16
      font-bold=Iosevka:weight=Regular:size=16
      dpi-aware=no
    '';
  };
  xdg.portal.wlr.enable = true;
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
  programs.starship.enable = true;

  virtualisation.libvirtd.enable = true;
  #virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.passwordAuthentication = false;
  };

  services.resolved.enable = true;
  services.resolved.llmnr = "false";
  #services.resolved.domains = ["home"];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable the fail2ban service
  services.fail2ban.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
