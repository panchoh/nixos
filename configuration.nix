{
  config,
  lib,
  pkgs,
  nixpkgs,
  nixos-hardware,
  disko,
  modulesPath,
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
    ./modules/traits/hyprland.nix
    ./modules/traits/greetd.nix
    ./modules/traits/nix.nix
    ./modules/traits/editor.nix
    ./modules/traits/fish.nix
    ./modules/traits/locate.nix
    ./modules/traits/user.nix
    ./modules/traits/printing.nix
    ./modules/traits/sound.nix
    ./modules/traits/ssh.nix
    ./modules/traits/caddy.nix
    ./modules/traits/doas.nix
    ./modules/traits/yubikey.nix

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

  traits.locate.enable = true;

  services.fwupd.enable = true;

  traits.printing.enable = true;

  traits.sound.enable = true;

  traits.user.enable = true;

  traits.hyprland.enable = true;

  traits.greetd.enable = true;

  traits.nix.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    wget
  ];

  programs.command-not-found.enable = false;

  traits.editor.enable = true;

  traits.fish.enable = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;

  traits.ssh.enable = true;

  networking.firewall.allowedTCPPorts = [
    51413
  ];

  services.fail2ban.enable = true;

  traits.caddy.enable = false;

  traits.doas.enable = true;

  traits.yubikey.enable = true;

  services.fstrim.enable = true;

  traits.autofirma.enable = true;
  traits.chromium.enable = true;
  traits.chrome.enable = true;
}
