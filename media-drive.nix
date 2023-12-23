{config, ...}: {
  fileSystems."/srv/media" = {
    device = "/dev/disk/by-label/media";
    fsType = "btrfs";
    options = ["nofail" "noexec" "nosuid" "nodev" "noatime" "compress=zstd:1"];
  };
}
