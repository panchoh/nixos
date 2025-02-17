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
        wget2
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

        bc
        cdrkit

        intel-gpu-tools

        glow

        entr

        pv

        fx
      ]
      ++ lib.optionals (box.isStation or false) [
        hwatch

        recode

        whois

        pdftk
        pdfchain

        asciinema
        asciinema-agg
        asciinema-scenario

        bgnet

        v4l-utils
        graphviz
        ffmpeg
        vlc
        mkvtoolnix
        evince
        gimp
        inkscape
        youtube-tui
        zoom-us

        telegram-desktop
        discord
        dissent
        # nheko
        fractal

        # Editors
        lapce

        transmission_4-gtk
        wormhole-william

        stellarium
        celestia
      ];
  };
}
