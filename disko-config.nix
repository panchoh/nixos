{ disks ? [ "/dev/nvme0n1" ], ... }: {
  disko.devices = {
    disk = {
      nvm0en1 = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "ESP";
              start = "1MiB";
              end = "512MiB";
              fs-type = "fat32";
              bootable = true;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efi";
              };
            }
            {
              name = "root";
              start = "512MiB";
              end = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                subvolumes = {
                  # Subvolume name is different from mountpoint
                  "/rootfs" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd:1" "noatime" "discard=async" "autodefrag" ];
                  };
                  # Mountpoints inferred from subvolume name
                  "/home" = {
                    mountOptions = [ "compress=zstd:1" "noatime" "discard=async" "autodefrag" ];
                  };
                  "/nix" = {
                    mountOptions = [ "compress=zstd:1" "noatime" "discard=async" "autodefrag" ];
                  };
                  "/test" = { };
                };
              };
            }
          ];
        };
      };
    };
  };
}
