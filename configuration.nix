{
  config,
  lib,
  pkgs,
  nixpkgs,
  nixos-hardware,
  disko,
  modulesPath,
  attrs ? null,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.intel-nuc-8i7beh
    ./modules/traits/usb
    ./modules/traits/media-drive.nix
    disko.nixosModules.default
    ./disko-config.nix

    ./modules/traits/boot.nix
    ./modules/traits/autoupgrade.nix
    ./modules/traits/networking.nix
    ./modules/traits/hardware.nix
    ./modules/traits/i18n.nix
    ./modules/traits/epb.nix
    ./modules/traits/console.nix
    ./modules/traits/kmscon.nix

    {disabledModules = [(modulesPath + "/programs/chromium.nix")];}
    ./modules/programs/chromium.nix
    ./modules/programs/chrome.nix
    ./modules/traits/chromium.nix
    ./modules/traits/chrome.nix
    ./modules/traits/autofirma.nix
    ./modules/traits/stylix.nix
    ./modules/traits/home-manager.nix
  ];

  system.stateVersion = "23.11";

  traits.usb-drives.enable = true;
  traits.usb-misc.enable = true;
  traits.media-drive.enable = true;

  traits.stylix.enable = true;

  traits.home-manager.enable = true;

  traits.boot.enable = true;

  traits.autoupgrade.enable = false;

  traits.networking.enable = true;

  time.timeZone = "Europe/Madrid";

  traits.hardware.enable = true;

  traits.i18n.enable = true;

  traits.epb.enable = true;

  services.physlock.enable = true;

  services.dbus.implementation = "broker";
  services.dbus.packages = [pkgs.gcr]; # for pinentry-gnome3

  services.upower.enable = true;

  traits.console.enable = true;

  traits.kmscon.enable = true;

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
    restart = true;
    settings = rec {
      default_session = initial_session;
      initial_session = {
        command = "${lib.getExe config.programs.hyprland.finalPackage} &>~/.Wsession.errors";
        user = attrs.userName or "alice";
      };
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
    # fix pcscd
    # https://github.com/NixOS/nixpkgs/issues/280826
    pcscliteWithPolkit.out
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
  services.udev.packages = [pkgs.yubikey-personalization];

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
      # keepEnv = true;
      setEnv = ["LOCALE_ARCHIVE" "NIXOS_INSTALL_BOOTLOADER"];
    }
  ];
  security.sudo.enable = false;
  security.sudo.execWheelOnly = true;

  # security.pam.u2f.enable = true;
  # security.pam.u2f.cue = true;
  security.pam.services = {
    login.u2fAuth = true;
    doas.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  services.fstrim.enable = true;

  traits.autofirma.enable = true;
  traits.chromium.enable = true;
  traits.chrome.enable = true;
}
