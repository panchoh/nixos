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

    ./traits/state-version.nix
    ./traits/boot.nix
    ./traits/autoupgrade.nix
    ./traits/networking.nix
    ./traits/hardware.nix
    ./traits/i18n.nix
    ./traits/epb.nix
    ./traits/console.nix
    ./traits/kmscon.nix
    ./traits/hyprland.nix
    ./traits/greetd.nix
    ./traits/nix.nix
    ./traits/editor.nix
    ./traits/fish.nix
    ./traits/iotop-c.nix
    ./traits/locate.nix
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
