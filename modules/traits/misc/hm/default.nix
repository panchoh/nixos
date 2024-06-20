{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.misc;
in {
  options.traits.hm.misc = {
    enable = lib.mkEnableOption "misc" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      [
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
        wget2
        restish

        moreutils
        yq-go
        hwloc
        b3sum
        unzip
        zip

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
        cdrkit
        cloud-utils

        intel-gpu-tools

        charasay

        glow

        entr
      ]
      ++ lib.optionals (box.isStation or false) [
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

        telegram-desktop
        discord
        nheko
        tessen

        lapce

        popcorntime

        transmission-gtk
        wormhole-william

        gpt4all
      ];
  };
}
