{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.hm.misc;
in {
  options.traits.hm.misc = {
    enable = lib.mkEnableOption "misc" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      efibootmgr
      gptfdisk
      parted
      psmisc
      sysstat
      sysfsutils
      pciutils
      usbutils
      usbtop
      iotop-c
      smartmontools
      hdparm
      nvme-cli
      sg3_utils
      lm_sensors

      ldns
      doggo
      dogdns
      nmap
      speedtest-go
      ipcalc

      curl
      wget
      restish

      moreutils
      yq-go
      hwloc
      b3sum
      unzip
      zip

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

      charasay

      glow

      entr

      gpt4all
    ];
  };
}
