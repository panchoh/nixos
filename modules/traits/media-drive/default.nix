{
  config,
  lib,
  box ? null,
  ...
}: let
  cfg = config.traits.media-drive;
in {
  options.traits.media-drive = {
    enable = lib.mkEnableOption "big media drive" // {default = box.hasMedia or false;};
  };

  config = lib.mkIf cfg.enable {
    fileSystems."/srv/media" = {
      device = "/dev/disk/by-label/media";
      fsType = "btrfs";
      options = ["nofail" "noexec" "nosuid" "nodev" "noatime" "compress=zstd:1" "X-fstrim.notrim"];
    };
  };
}
