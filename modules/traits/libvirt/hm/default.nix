{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.virt-manager;
in {
  options.traits.hm.virt-manager = {
    enable = lib.mkEnableOption "virt-manager" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.virt-manager
      pkgs.virt-viewer
    ];

    # https://github.com/virt-manager/virt-manager/blob/main/data/org.virt-manager.virt-manager.gschema.xml
    dconf.settings = {
      "org/virt-manager/virt-manager" = {
        xmleditor-enabled = true;
      };
      "org/virt-manager/virt-manager/confirm" = {
        forcepoweroff = false;
      };
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
      "org/virt-manager/virt-manager/new-vm" = {
        firmware = "uefi";
      };
      "org/virt-manager/virt-manager/stats" = {
        enable-disk-poll = true;
        enable-net-poll = true;
        enable-memory-poll = true;
      };
      "org/virt-manager/virt-manager/vmlist-fields" = {
        disk-usage = true;
        network-traffic = true;
        cpu-usage = true;
        host-cpu-usage = true;
        memory-usage = true;
      };
    };
  };
}
