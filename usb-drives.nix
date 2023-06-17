{
  config,
  pkgs,
  ...
}: {
  services.udev.packages = [
    (pkgs.writeTextFile rec {
      name = "99-usb-drives.rules";
      destination = "/etc/udev/rules.d/${name}";
      text = ''
        ACTION=="add", KERNEL=="sd?", SUBSYSTEMS=="usb", ENV{ID_FS_LABEL}!="", RUN+="${pkgs.coreutils}/bin/mkdir -p '/media/%E{ID_FS_LABEL}'"
        ACTION=="remove", KERNEL=="sd?", SUBSYSTEMS=="usb", ENV{ID_FS_LABEL}!="", RUN+="${pkgs.coreutils}/bin/rmdir --ignore-fail-on-non-empty '/media/%E{ID_FS_LABEL}'"
      '';
    })
  ];

  fileSystems = builtins.listToAttrs (
    map (label: {
      name = "/media/${label}";
      value = {
        device = "/dev/disk/by-label/${label}";
        fsType = "btrfs";
        options = ["noauto" "users" "noexec" "nosuid" "nodev" "noatime"];
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
}
