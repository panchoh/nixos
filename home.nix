{
  config,
  pkgs,
  lib,
  attrs ? null,
  ...
}: {
  imports = [
    ./modules/hm/hyprland.nix
    ./modules/hm/openssh.nix
    ./modules/hm/gnupg.nix
    ./modules/hm/stylix.nix
    ./modules/hm/chromium.nix
    ./modules/hm/chrome.nix
    ./modules/hm/firefox.nix
    ./modules/hm/btop.nix
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
    yubikey-manager-qt
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
    gitg
    tig
    gource
    gti
    gnutls
    zstd
    meld
    vbindiff
    diffoscope

    bvi
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

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = lib.mkForce "Iosevka:size=20:weight=ExtraLight";
        layer = "overlay";
        terminal = lib.getExe pkgs.foot;
      };
    };
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = lib.mkForce "IosevkaTerm NFM Light:size=14";
        font-bold = lib.mkForce "IosevkaTerm NFM:size=14";
      };
      mouse = {
        hide-when-typing = true;
      };
    };
  };

  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    clock24 = true;
    mouse = true;
    terminal = "tmux-256color";
    sensibleOnTop = false;
    escapeTime = 0;
    extraConfig = ''
      set -g focus-events on
      set -g status-interval 5
    '';
  };

  programs.bash.enable = true;

  programs.fish = {
    enable = true;
    shellAliases = {
      e = "${
        lib.getExe' config.programs.emacs.finalPackage "emacsclient"
      } --no-wait --reuse-frame --alternate-editor=${lib.getExe pkgs.neovim}";
    };
  };
  programs.starship = {
    enable = true;
    settings = {
      hostname = {
        ssh_only = false;
      };
      golang = {
        symbol = " ";
      };
    };
  };
  programs.lsd = {
    enable = true;
    enableAliases = true;
    settings = {
      date = "relative";
      header = true;
      blocks = [
        "permission"
        "links"
        # "inode"
        "user"
        "group"
        "context"
        "size"
        "date"
        "name"
        # "git"
      ];
      ignore-globs = [
        ".git"
        ".hg"
      ];
    };
  };
  programs.eza = {
    enable = false;
    enableAliases = true;
    extraOptions = [
      "--group-directories-first"
      "--group"
      "--header"
    ];
    icons = true;
  };
  programs.bat.enable = true;
  programs.fzf = {
    enable = true;
    tmux = {
      enableShellIntegration = true;
      shellIntegrationOptions = ["-d 40%"];
    };
  };
  programs.zoxide.enable = true;
  programs.thefuck.enable = true;
  programs.jq.enable = true;

  programs.lf = {
    enable = true;
    settings = {
      icons = true;
      sixel = true;
    };
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = attrs.userDesc or "Alice Q. User";
    userEmail = attrs.userEmail or "alice@example.org";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      merge.conflictStyle = "zdiff3";
    };
    delta = {
      enable = true;
      options = {
        side-by-side = true;
      };
    };
    signing = {
      key = "4430F5028B19FAF4A40EC4E811E0447D4ABBA7D0";
      signByDefault = true;
    };
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  programs.aria2.enable = true;
  programs.yt-dlp = {
    enable = true;
    settings = {
      embed-thumbnail = true;
      embed-subs = true;
      sub-langs = "all";
      downloader = "aria2c";
      downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
    };
  };

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
