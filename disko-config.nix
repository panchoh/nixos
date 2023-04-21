let
  sharedMountOptions = [
    "compress=zstd:1" "noatime" "discard=async" "autodefrag"
  ];
in
{
  disko.devices.disk.nvm0en1 = {
    type = "disk";
    device = "/dev/nvme0n1";
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
            mountpoint = "/boot";
          };
        }
        {
          type = "partition";
          name = "swap";
          start = "512MiB";
          end = "4GiB";
          part-type = "primary";
          content = {
            type = "swap";
            # randomEncryption = true;
          };
        }
        {
          name = "root";
          start = "4GiB";
          end = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ]; # Override existing partition
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
        }
      ];
    };
  };
}
