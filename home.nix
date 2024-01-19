{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/hm/stylix.nix
    ./modules/hm/virt-manager.nix
    ./modules/hm/hyprland.nix
    ./modules/hm/fuzzel.nix
    ./modules/hm/foot.nix
    ./modules/hm/tmux.nix
    ./modules/hm/gopass.nix
    ./modules/hm/fish.nix
    ./modules/hm/git.nix
    ./modules/hm/btop.nix
    ./modules/hm/comma.nix
    ./modules/hm/mdb.nix
    ./modules/hm/openvi.nix
    ./modules/hm/emacs.nix
    ./modules/hm/openssh.nix
    ./modules/hm/gnupg.nix
    ./modules/hm/yubikey.nix
    ./modules/hm/firefox.nix
    ./modules/hm/chromium.nix
    ./modules/hm/chrome.nix
    ./modules/hm/imv.nix
    ./modules/hm/yt-dlp.nix
    ./modules/hm/mpv.nix
    ./modules/hm/obs-studio.nix
  ];

  home.stateVersion = "23.11";

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
    man-pages
    man-pages-posix
    ipcalc

    (nerdfonts.override {fonts = ["IosevkaTerm"];})
    (iosevka-bin.override {variant = "slab";})
    iosevka-bin

    qastools
    pavucontrol
    helvum

    swaylock
    swayidle
    grim
    satty # TODO: also configure hyprland keybinding
    slurp
    wl-clipboard
    wlrctl
    wev
    xkeyboard_config
    libxkbcommon # for xkbcli interactive-wayland

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

    grimblast
    hyprpicker

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

    bb
    # bsdgames # provides wtf, but conflicts with fish shell
    # FIXME: PR with the current BSD Games, which fixes this an more
    (stdenv.mkDerivation {
      pname = "bsdgames-custom";
      version = pkgs.bsdgames.version;
      src = pkgs.bsdgames;
      installPhase = ''
        mkdir -p $out
        cp -a ${pkgs.bsdgames}/. $out/
        chmod +w $out/bin
        mv -f $out/bin/fish $out/bin/gofish
      '';
    })
    crawl
    sl
    neofetch
    hyperrogue
  ];

  # Reload system services when changing configs
  systemd.user.startServices = "sd-switch";

  xdg = {
    enable = true;
    userDirs.download = "${config.home.homeDirectory}/incoming";
  };

  hm.stylix.enable = true;
  hm.virt-manager.enable = true;
  hm.hyprland.enable = true;
  hm.fuzzel.enable = true;
  services.mako.enable = true;
  hm.foot.enable = true;
  hm.tmux.enable = true;
  hm.gopass.enable = true;
  programs.bash.enable = true;
  hm.fish.enable = true;
  hm.git.enable = true;
  hm.btop.enable = true;
  programs.man = {
    enable = true;
    generateCaches = true;
  };
  hm.comma.enable = true;
  hm.mdb.enable = true;
  hm.openvi.enable = true;
  hm.emacs.enable = true;
  programs.helix.enable = true;
  programs.vscode.enable = true;
  programs.texlive.enable = true;
  programs.k9s.enable = true;
  hm.openssh.enable = true;
  hm.gnupg.enable = true;
  hm.yubikey.enable = true;
  hm.firefox.enable = true;
  hm.chromium.enable = true;
  hm.chrome.enable = true;
  hm.imv.enable = true;
  hm.yt-dlp.enable = true;
  hm.mpv.enable = true;
  hm.obs-studio.enable = true;
}
