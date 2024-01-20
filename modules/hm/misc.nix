{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hm.misc;
in {
  options.hm.misc.enable = lib.mkEnableOption "misc";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      efibootmgr
      gptfdisk
      parted
      psmisc
      sysstat
      pciutils
      usbutils
      usbtop
      smartmontools
      hdparm
      nvme-cli
      sg3_utils
      lm_sensors
      ldns
      dogdns
      nmap
      mtr-gui
      speedtest-go
      moreutils
      hwloc
      b3sum
      unzip
      zip
      ipcalc

      qastools
      pavucontrol
      helvum

      v4l-utils
      graphviz
      ffmpeg
      vlc
      mkvtoolnix
      evince
      gimp
      inkscape
      audacity
      picard
      youtube-tui
      zoom-us

      qmk
      qmk_hid
      keymapviz

      binutils
      dua
      duf
      du-dust
      file
      fdupes
      rdfind
      rmlint
      gnutls
      zstd

      bc

      ccls

      telegram-desktop
      discord
      nheko
      tessen

      cdrkit
      cloud-utils

      popcorntime

      transmission-gtk
      wormhole-william

      intel-gpu-tools

      lapce
      neovide
    ];
  };
}