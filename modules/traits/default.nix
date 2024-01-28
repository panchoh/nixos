{
  nixos-hardware,
  disko,
  modulesPath,
  ...
}: {
  imports = [
    ./hardware-configuration
    nixos-hardware.nixosModules.intel-nuc-8i7beh
    ./usb
    ./media-drive
    disko.nixosModules.default
    ./disko-config

    ./system-packages
    ./state-version
    ./boot
    ./auto-upgrade
    ./networking
    ./time-zone
    ./hardware
    ./i18n
    ./epb
    ./fstrim
    ./physlock
    ./dbus
    ./upower
    ./console
    ./kmscon
    ./hyprland
    ./greetd
    ./nix
    ./allow-unfree
    ./command-not-found
    ./editor
    ./fish
    ./iotop-c
    ./locate
    ./fwupd
    ./libvirt
    ./podman
    ./user
    ./printing
    ./sound
    ./ssh
    ./caddy
    ./doas
    ./yubikey
    ./autofirma

    {disabledModules = [(modulesPath + "/programs/chromium.nix")];}
    ../programs/chromium.nix
    ../programs/chrome.nix
    ./chromium
    ./chrome

    ./font
    ./stylix
    ./home-manager
  ];
}
