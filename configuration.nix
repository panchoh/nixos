# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.timeout = 0;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.plymouth.enable = true;

  powerManagement.cpuFreqGovernor = "performance";

  networking.hostName = "cobalt"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.useNetworkd = true;
  networking.search = ["home"];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty
    xorg.xrandr
    xorg.xsetroot
    xloadimage
    rofi
    pandoc
    git
#    ((emacsPackagesNgGen emacs).emacsWithPackages (epkgs: [
#      epkgs.vterm
#      epkgs.pdf-tools
#    ]))
    ((emacsPackagesGen emacs).emacsWithPackages (epkgs: [
      epkgs.vterm
      epkgs.pdf-tools
    ]))
    emacs-all-the-icons-fonts
    ripgrep
    coreutils
    fd
    clang
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bcc.enable = true;
  programs.fish.enable = true;
  programs.vim.defaultEditor = true;
  programs.ssh.startAgent = true;
  programs.mosh.enable = true;
  programs.slock.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable the fail2ban service.
  services.fail2ban.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  services.fwupd.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.setupCommands = ''
    # modesetting
    #${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --off --output DP-1 --primary --mode 3840x1600 --pos 0x0 --rotate normal --output HDMI-1 --off --output DP-2 --off
    # intel
    ${pkgs.xorg.xrandr}/bin/xrandr --output eDP1 --off --output DP1 --primary --mode 3840x1600 --pos 0x0 --rotate normal --output DP2 --off --output HDMI1 --off --output VIRTUAL1 --off
    ##${pkgs.xorg.xsetroot}/bin/xsetroot -solid '#282A36'
    ${pkgs.xloadimage}/bin/xsetbg -onroot -fullscreen -border '#282A36' /srv/backgrounds/dracula-base.png
  '';

  services.xserver.displayManager.lightdm.greeters.mini = {
    enable = true;
    user = "pancho";
    extraConfig = ''
      # https://github.com/prikhi/lightdm-mini-greeter/blob/master/data/lightdm-mini-greeter.conf
      [greeter]
      show-password-label = false
      password-alignment = left

      [greeter-hotkeys]
      mod-key = meta
      shutdown-key = s
      restart-key = r

      [greeter-theme]
      font = "IBM Plex Mono"
      font-size = 1.1em
      background-image = ""
      #background-image = "/srv/backgrounds/Camera_Film_by_Markus_Spiske.jpg"
      #background-image = "/srv/backgrounds/dracula-base.png"
      background-color = "#282A36"
      '';
    };

  services.xserver.xkbModel = "hhk";
  services.xserver.layout = "us,us";
  services.xserver.xkbOptions = "compose:sclk,grp:shifts_toggle";
  services.xserver.xkbVariant = "altgr-intl,dvorak-alt-intl";
  #services.xserver.videoDrivers = [ "modesetting" ];
  #services.xserver.useGlamor = true;
  services.xserver.videoDrivers = [ "intel" ];
  services.xserver.deviceSection = ''
    Option "TearFree" "true"
  '';

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  services.xserver.windowManager.spectrwm.enable = true;

  services.unclutter-xfixes.enable = true;

  fonts = {
    enableDefaultFonts = true;
    fonts = [
      pkgs.ibm-plex
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "IBM Plex" ];
        sansSerif = [ "IBM Plex Sans" ];
        monospace = [ "IBM Plex Mono" ];
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pancho = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  security.sudo.wheelNeedsPassword = false;

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

