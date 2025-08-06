{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.misc;
in
{
  options.traits.hm.misc = {
    enable = lib.mkEnableOption "misc" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        dmidecode
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
        # wget2
        xh
        restish
        slumber

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
        czkawka
        fclones
        gnutls
        zstd

        inotify-info

        bc
        cdrkit

        intel-gpu-tools

        glow

        entr

        pv

        fx
      ]
      ++ lib.optionals (box.isStation or false) [
        ddrescue
        ddrescueview

        hwatch

        recode

        whois

        pdf4qt
        pdfchain
        pdfcpu
        pdfgrep
        pdftk

        asciinema
        asciinema-agg
        asciinema-scenario

        pinact

        bgnet

        flac

        mission-center
        v4l-utils
        libation
        ffmpeg
        vlc
        mkvtoolnix
        gimp3
        inkscape
        youtube-tui
        zoom-us

        discord
        dissent
        # nheko
        fractal
        session-desktop

        # Editors
        lapce

        wormhole-william

        stellarium
        celestia
      ];
  };
}
