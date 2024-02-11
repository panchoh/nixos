{
  config,
  pkgs,
  lib,
  box ? null,
  ...
}: let
  cfg = config.traits.usb-drives;
in {
  options.traits.usb-drives = {
    enable = lib.mkEnableOption "usb drives" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    users.groups."storage".members = [
      box.userName or "alice"
    ];

    services.udev.packages = [
      (pkgs.writeTextFile rec {
        name = "99-usb-drives.rules";
        destination = "/etc/udev/rules.d/${name}";
        text = ''
          # Create /media/<label> dir upon connection of USB drives
          ACTION=="add",                       \
            KERNEL=="sd[a-z]",                 \
            SUBSYSTEM=="block",                \
            ENV{ID_USB_DRIVER}=="usb-storage", \
            ENV{ID_FS_LABEL}!="",              \
            RUN+="${lib.getExe' pkgs.coreutils "mkdir"} -p '/media/%E{ID_FS_LABEL}'"

          # Remove /media/<label> dir upon disconnection of USB drives
          ACTION=="remove",                    \
            KERNEL=="sd[a-z]",                 \
            SUBSYSTEM=="block",                \
            ENV{ID_USB_DRIVER}=="usb-storage", \
            ENV{ID_FS_LABEL}!="",              \
            RUN+="${lib.getExe' pkgs.coreutils "rmdir"} --ignore-fail-on-non-empty '/media/%E{ID_FS_LABEL}'"

          # Allow direct access to usb block devices to the members of the storage group
          KERNEL=="sd[a-z]*",                  \
            SUBSYSTEM=="block",                \
            ENV{ID_USB_DRIVER}=="usb-storage", \
            GROUP="storage"
        '';
      })
    ];

    fileSystems = builtins.listToAttrs (
      map (label: {
        name = "/media/${label}";
        value = {
          device = "/dev/disk/by-label/${label}";
          fsType = "btrfs";
          options = ["noauto" "users" "noexec" "nosuid" "nodev" "noatime" "nodiscard" "X-fstrim.notrim"];
        };
      })
      [
        # My Passport Drives
        "onyx"
        "graphite"
        "gold"

        "goo"
        "blue"
        "white"

        # Red is dead, babe.  Red is dead.
        "orange"
        "yellow"

        # Black stack
        "tesseract"
        "void"
        "monolith"

        # My Passport Ultra Drives
        ## Silver
        "uru"
        "quicksilver"
        "silver"

        ## Blue
        "neon"
        "cobalt"
        "copper"

        ## Silver
        "lithium"
        "sodium"
        "kalium"

        "backup"

        # 2022-08-20T15:57:56 CEST
        # Zeroed.
        # Seems to have trouble spinning up, maybe some connector issue.
        # I think is best not to use it anymore.
        # "black"
      ]
    );
  };
}
