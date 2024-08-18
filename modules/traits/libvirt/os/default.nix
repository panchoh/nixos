{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.libvirt;
in {
  options.traits.libvirt = {
    enable = lib.mkEnableOption "libvirt" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    users.users.${box.userName or "alice"}.extraGroups = ["libvirtd"];

    environment.systemPackages = [
      pkgs.libguestfs
      pkgs.guestfs-tools
    ];

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu.runAsRoot = false;
      };
    };
  };
}
