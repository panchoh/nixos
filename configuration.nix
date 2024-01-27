{
  pkgs,
  attrs ? null,
  ...
}: {
  imports = [./modules];

  traits.usb-drives.enable = true;
  traits.usb-misc.enable = true;
  traits.media-drive.enable = !attrs.isLaptop or false;
  traits.stylix.enable = true;
  traits.boot.enable = true;
  traits.home-manager.enable = true;
  traits.autoupgrade.enable = false;
  traits.networking.enable = true;
  traits.time-zone.enable = true;
  traits.hardware.enable = true;
  traits.i18n.enable = true;
  traits.epb.enable = true;
  traits.fstrim.enable = true;
  traits.physlock.enable = true;
  traits.dbus.enable = true;
  traits.upower.enable = true;
  traits.console.enable = true;
  traits.kmscon.enable = true;
  traits.locate.enable = true;
  traits.fwupd.enable = true;
  traits.printing.enable = true;
  traits.sound.enable = true;
  traits.user.enable = true;
  traits.hyprland.enable = true;
  traits.greetd.enable = true;
  traits.nix.enable = true;
  traits.allow-unfree.enable = true;
  traits.command-not-found.enable = false;
  traits.editor.enable = true;
  traits.fish.enable = true;
  traits.iotop-c.enable = true;
  traits.libvirt.enable = true;
  traits.podman.enable = true;
  traits.ssh.enable = true;
  traits.caddy.enable = false;
  traits.doas.enable = true;
  traits.yubikey.enable = true;
  traits.autofirma.enable = true;
  traits.chromium.enable = true;
  traits.chrome.enable = true;
}
