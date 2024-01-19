{
  config,
  pkgs,
  lib,
  nix-index-database,
  attrs ? null,
  ...
}: {
  imports = [
    nix-index-database.hmModules.nix-index
    ./modules/hm/hyprland.nix
    ./modules/hm/fuzzel.nix
    ./modules/hm/foot.nix
    ./modules/hm/tmux.nix
    ./modules/hm/fish.nix
    ./modules/hm/git.nix
    ./modules/hm/openssh.nix
    ./modules/hm/gnupg.nix
    ./modules/hm/stylix.nix
    ./modules/hm/chromium.nix
    ./modules/hm/chrome.nix
    ./modules/hm/firefox.nix
    ./modules/hm/btop.nix
    ./modules/hm/yt-dlp.nix
    ./modules/hm/mpv.nix
    ./modules/hm/virt-manager.nix
    ./modules/hm/openvi.nix
    ./modules/hm/gopass.nix
    ./modules/hm/mdb.nix
    ./modules/hm/emacs.nix
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

    pam_u2f
    pamtester
    libfido2

    opensc
    pcsctools
    ccid
    scmccid

    openssl

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

    pwgen
    yubico-piv-tool
    yubikey-manager
    yubikey-personalization
    yubikey-personalization-gui
    yubikey-touch-detector
    yubioath-flutter

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

  hm.btop.enable = true;

  hm.gopass.enable = true;

  xdg = {
    enable = true;
    userDirs.download = "${config.home.homeDirectory}/incoming";
  };

  hm.virt-manager.enable = true;

  hm.fuzzel.enable = true;

  hm.foot.enable = true;

  hm.tmux.enable = true;

  programs.bash.enable = true;

  hm.fish.enable = true;

  hm.git.enable = true;

  hm.yt-dlp.enable = true;

  services.mako.enable = true;

  programs.k9s.enable = true;

  programs.imv = {
    enable = true;
    settings = {
      binds."<Shift+Delete>" = ''
        exec rm "$imv_current_file"; close
      '';
    };
  };

  programs.man = {
    enable = true;
    generateCaches = true;
  };

  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;

  hm.mpv.enable = true;

  programs.obs-studio = {
    enable = true;
    plugins = [pkgs.obs-studio-plugins.wlrobs];
  };

  hm.firefox.enable = true;

  hm.chromium.enable = true;
  hm.chrome.enable = true;

  hm.gnupg.enable = true;

  hm.openssh.enable = true;

  programs.helix.enable = true;

  hm.emacs.enable = true;

  hm.openvi.enable = true;

  hm.mdb.enable = true;

  programs.texlive.enable = true;

  programs.vscode.enable = true;

  hm.stylix.enable = true;

  hm.hyprland.enable = true;
}
