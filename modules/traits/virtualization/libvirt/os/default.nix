{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.os.libvirt;
in {
  options.traits.os.libvirt = {
    enable = lib.mkEnableOption "libvirt" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    users.users.${box.userName or "alice"}.extraGroups = ["libvirtd"];

    environment.systemPackages = with pkgs; [
      libguestfs
      guestfs-tools
    ];

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu.runAsRoot = false;
      };
    };
  };
}
