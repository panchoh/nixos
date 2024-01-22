{
  pkgs,
  attrs ? null,
  ...
}: {
  imports = [./modules];

  system.stateVersion = "23.11";

  environment.systemPackages = with pkgs; [
    git
    wget
  ];

  traits.usb-drives.enable = true;
  traits.usb-misc.enable = true;
  traits.media-drive.enable = !attrs.isLaptop or false;
  traits.stylix.enable = true;
  traits.boot.enable = true;
  traits.home-manager.enable = true;
  traits.autoupgrade.enable = false;
  traits.networking.enable = true;
  time.timeZone = "Europe/Madrid";
  traits.hardware.enable = true;
  traits.i18n.enable = true;
  traits.epb.enable = true;
  services.fstrim.enable = true;
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
  programs.command-not-found.enable = false;
  traits.editor.enable = true;
  traits.fish.enable = true;
  traits.iotop-c.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;
  traits.ssh.enable = true;
  traits.caddy.enable = false;
  traits.doas.enable = true;
  traits.yubikey.enable = true;
  traits.autofirma.enable = true;
  traits.chromium.enable = true;
  traits.chrome.enable = true;
}
