{
  nixos-hardware,
  disko,
  modulesPath,
  ...
}: {
  imports = [
    ../hardware-configuration.nix
    nixos-hardware.nixosModules.intel-nuc-8i7beh
    ./traits/usb
    ./traits/media-drive.nix
    disko.nixosModules.default
    ../disko-config.nix

    ./traits/system-packages.nix
    ./traits/state-version.nix
    ./traits/boot.nix
    ./traits/auto-upgrade.nix
    ./traits/networking.nix
    ./traits/time-zone.nix
    ./traits/hardware.nix
    ./traits/i18n.nix
    ./traits/epb.nix
    ./traits/fstrim.nix
    ./traits/physlock.nix
    ./traits/dbus.nix
    ./traits/upower.nix
    ./traits/console.nix
    ./traits/kmscon.nix
    ./traits/hyprland.nix
    ./traits/greetd.nix
    ./traits/nix.nix
    ./traits/allow-unfree.nix
    ./traits/command-not-found.nix
    ./traits/editor.nix
    ./traits/fish.nix
    ./traits/iotop-c.nix
    ./traits/locate.nix
    ./traits/fwupd.nix
    ./traits/libvirt.nix
    ./traits/podman.nix
    ./traits/user.nix
    ./traits/printing.nix
    ./traits/sound.nix
    ./traits/ssh.nix
    ./traits/caddy.nix
    ./traits/doas.nix
    ./traits/yubikey.nix
    ./traits/autofirma.nix

    {disabledModules = [(modulesPath + "/programs/chromium.nix")];}
    ./programs/chromium.nix
    ./programs/chrome.nix
    ./traits/chromium.nix
    ./traits/chrome.nix

    ./traits/font.nix
    ./traits/stylix.nix
    ./traits/home-manager.nix
  ];
}
