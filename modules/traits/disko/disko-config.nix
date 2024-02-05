{...}: let
  sharedMountOptions = [
    "compress=zstd:1"
    "noatime"
    "autodefrag"
    "X-fstrim.notrim"
  ];
in {
  disko.devices.disk.nvme0n1 = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
          label = "ESP";
          type = "ef00";
          size = "512M";
          content = {
            type = "filesystem";
            format = "vfat";
            extraArgs = ["-F32"];
            mountpoint = "/boot";
            mountOptions = ["umask=0077"];
          };
        };
        swap = {
          label = "swap";
          type = "8200";
          size = "4G";
          content = {
            type = "swap";
            # randomEncryption = true;
          };
        };
        root = {
          label = "root";
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = ["-f"]; # Override existing partition
            subvolumes = {
              "@" = {
                mountpoint = "/";
                mountOptions = sharedMountOptions;
              };
              "@home" = {
                mountpoint = "/home";
                mountOptions = sharedMountOptions;
              };
              "@nix" = {
                mountpoint = "/nix";
                mountOptions = sharedMountOptions;
              };
              "@var" = {
                mountpoint = "/var";
                mountOptions = sharedMountOptions;
              };
              "@srv" = {
                mountpoint = "/srv";
                mountOptions = sharedMountOptions;
              };
              "@snapshots" = {
                mountpoint = "/.snapshots";
                mountOptions = sharedMountOptions;
              };
            };
          };
        };
      };
    };
  };
}
