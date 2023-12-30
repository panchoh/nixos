{
  config,
  pkgs,
  lib,
  stylix,
  autofirma-nix,
  attrs ? null,
  ...
}: {
  imports = [
    autofirma-nix.homeManagerModules.default
    ./modules/hm/hyprland.nix
    ./modules/hm/openssh.nix
    ./modules/hm/gnupg.nix
    ./modules/hm/stylix.nix
    ./modules/hm/chromium.nix
    ./modules/hm/chrome.nix
  ];

  home.stateVersion = "23.11";
  home.username = attrs.userName or "alice";
  home.homeDirectory = "/home/${attrs.userName or "alice"}";
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.local/bin.go"
    "${config.xdg.configHome}/emacs/bin"
  ];
  # home.sessionVariables = {
  #   foo = "bar";
  # };

  home.activation = {
    DoomEmacsAction = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [[ ! -d "${config.xdg.configHome}"/emacs ]]; then
        $DRY_RUN_CMD ${lib.getExe pkgs.git} clone $VERBOSE_ARG --depth=1 --single-branch https://github.com/doomemacs/doomemacs.git "${config.xdg.configHome}"/emacs
      fi
      if [[ ! -d "${config.xdg.configHome}"/doom ]]; then
        $DRY_RUN_CMD ${lib.getExe pkgs.git} clone $VERBOSE_ARG https://github.com/panchoh/dotconfig-doom.git "${config.xdg.configHome}"/doom
        # PATH="${pkgs.git}/bin:$PATH" EMACS="${lib.getExe config.programs.emacs.finalPackage}" $DRY_RUN_CMD "${config.xdg.configHome}"/emacs/bin/doom sync
      fi
    '';
  };

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
    playerctl
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

    alejandra
    (aspellWithDicts (ds: with ds; [en en-computers en-science]))
    binutils
    dua
    duf
    editorconfig-core-c
    file
    fd
    fdupes
    rdfind
    rmlint
    gcc
    gnumake
    gitg
    tig
    gource
    gti
    gnutls
    zstd
    python311Packages.grip
    meld
    deadnix
    nil # TODO: nix lsp server, to the doom module!
    vbindiff
    diffoscope

    bvi
    bc
    shfmt
    shellcheck
    nodejs_20
    sqlite
    python3
    pipenv

    gotools
    go-tools
    gopls
    gofumpt
    gomodifytags
    gotests
    gore
    delve
    gdlv

    ccls

    telegram-desktop
    discord
    nheko
    tessen

    virt-manager
    cdrkit
    cloud-utils

    popcorntime

    transmission-gtk
    wormhole-william

    intel-gpu-tools

    lapce
    neovide

    # FIXME: Hack until Doom Emacs can handle alejandra directly
    (stdenv.mkDerivation {
      name = "alejandra-posing-as-nixfmt";
      buildInputs = [alejandra];
      phases = ["installPhase"];
      installPhase = ''
        mkdir -p $out/bin
        cat <<EOF > $out/bin/nixfmt
        #!/bin/sh
        exec ${lib.getExe alejandra} --quiet "\$@"
        EOF
        chmod +x $out/bin/nixfmt
      '';
    })

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

  programs.btop = {
    enable = true;
    settings = {
      # https://github.com/aristocratos/btop#configurability
      vim_keys = true;
      color_theme = "dracula";
    };
  };

  programs.password-store = {
    enable = true;
    package = pkgs.gopass;
    settings = {PASSWORD_STORE_DIR = "${config.xdg.dataHome}/gopass/stores/root";};
  };

  programs.go = {
    enable = true;
    goBin = ".local/bin.go";
  };

  xdg = {
    enable = true;
    userDirs.download = "${config.home.homeDirectory}/incoming";
  };

  # https://github.com/virt-manager/virt-manager/blob/main/data/org.virt-manager.virt-manager.gschema.xml
  dconf.settings = {
    "org/virt-manager/virt-manager" = {
      xmleditor-enabled = true;
    };
    "org/virt-manager/virt-manager/confirm" = {
      forcepoweroff = false;
    };
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
    "org/virt-manager/virt-manager/new-vm" = {
      firmware = "uefi";
    };
    "org/virt-manager/virt-manager/stats" = {
      enable-disk-poll = true;
      enable-net-poll = true;
      enable-memory-poll = true;
    };
    "org/virt-manager/virt-manager/vmlist-fields" = {
      disk-usage = true;
      network-traffic = true;
      cpu-usage = true;
      host-cpu-usage = true;
      memory-usage = true;
    };
  };

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
        font = lib.mkForce "IosevkaTerm NFM Light:size=16";
        font-bold = lib.mkForce "IosevkaTerm NFM:size=16";
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

  services.playerctld.enable = true;

  programs.mangohud.enable = true;

  programs.man = {
    enable = true;
    generateCaches = true;
  };

  programs.mpv = {
    enable = true;
    scripts = [pkgs.mpvScripts.mpris];
    bindings = {
      ENTER = "playlist-next force";
      WHEEL_UP = "seek 10";
      WHEEL_DOWN = "seek -10";
      "Alt+0" = "set window-scale 0.5";
    };
    defaultProfiles = ["gpu-hq"];
    config = {
      fullscreen = true;
      sub-auto = "fuzzy";

      vo = "gpu-next";
      gpu-api = "vulkan";
      gpu-context = "waylandvk";
      sub-font = "Iosevka";

      # https://github.com/mpv-player/mpv/issues/8981
      hdr-compute-peak = false;

      # https://github.com/mpv-player/mpv/issues/10972#issuecomment-1340100762
      vd-lavc-dr = false;
    };
    profiles = {
      alsa-mm1 = {
        profile-desc = "Sound via alsa interface: MM-1";
        profile = "gpu-hq";
        audio-device = "alsa/iec958:CARD=MM1,DEV=0";
      };
      alsa-x = {
        profile-desc = "Sound via alsa interface: X";
        profile = "gpu-hq";
        audio-device = "alsa/iec958:CARD=X,DEV=0";
      };
      alsa-hdmi = {
        profile-desc = "Sound via alsa interface: HDMI";
        profile = "gpu-hq";
        audio-device = "alsa/hdmi:CARD=PCH,DEV=0";
      };
      "extension.mkv" = {
        keep-open = true;
        volume-max = "150";
      };
      "extension.mp4" = {
        keep-open = true;
        volume-max = "150";
      };
      "extension.gif" = {
        osc = "no";
        loop-file = true;
      };
      "protocol.dvd" = {
        profile-desc = "profile for dvd:// streams";
        alang = "en";
      };
    };
  };

  programs.obs-studio = {
    enable = true;
    plugins = [pkgs.obs-studio-plugins.wlrobs];
  };

  # https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
  # https://github.com/Misterio77/nix-config/blob/main/home/misterio/features/desktop/common/firefox.nix
  # https://gitlab.com/usmcamp0811/dotfiles/-/blob/nixos/modules/home/apps/firefox/default.nix?ref_type=heads
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      cfg.smartcardSupport = true;
    };
    profiles.default.id = 0;
    policies = {
      # https://mozilla.github.io/policy-templates
      # about:policies#documentation
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      DNSOverHTTPS.Enabled = 0;
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
      DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
      Homepage.StartPage = "none";
      NewTabPage = false;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      SearchBar = "unified"; # alternative: "separate"
      Preferences = let
        lock-true = {
          Value = true;
          Status = "locked";
        };
        lock-false = {
          Value = false;
          Status = "locked";
        };
        lock-strict = {
          Value = "strict";
          Status = "locked";
        };
      in {
        "browser.display.use_document_fonts" = 1; # Force stylix fonts on all pages
        "browser.sessionstore.resume_from_crash" = false;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "browser.contentblocking.category" = lock-strict;
        "extensions.pocket.enabled" = lock-false;
        "extensions.screenshots.disabled" = lock-true;
        "browser.topsites.contile.enabled" = lock-false;
        "browser.formfill.enable" = lock-false;
        "browser.search.suggest.enabled" = lock-false;
        "browser.search.suggest.enabled.private" = lock-false;
        "browser.urlbar.suggest.searches" = lock-false;
        "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
        "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
      };
    };
  };

  programs.autofirma = {
    enable = true;
    firefoxIntegration.profiles.default.enable = true;
  };

  programs.configuradorfnmt = {
    enable = true;
    firefoxIntegration.profiles.default.enable = true;
  };

  hm.chromium.enable = true;
  hm.chrome.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  hm.gnupg.enable = true;

  hm.openssh.enable = true;

  programs.ripgrep = {
    enable = true;
    package = pkgs.ripgrep.override {withPCRE2 = true;};
    arguments = ["--no-config"];
  };

  programs.helix.enable = true;

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
    extraPackages = epkgs: [epkgs.vterm];
  };

  home.sessionVariables = {
    EDITOR = lib.getBin (
      pkgs.writeShellScript "editor" ''
        exec ${lib.getExe' config.programs.emacs.finalPackage "emacsclient"}  \
          --reuse-frame                                                       \
          --alternate-editor=${lib.getExe pkgs.neovim}                        \
        "''${@:---create-frame}"
      ''
    );
    MOZ_USE_XINPUT2 = "1";
  };

  services.emacs = {
    enable = true;
    defaultEditor = false;
    startWithUserSession = "graphical";
    client = {
      enable = true;
      arguments = [
        "--reuse-frame"
        "--alternate-editor=nvim"
      ];
    };
  };

  programs.texlive.enable = true;

  programs.vscode.enable = true;

  hm.stylix.enable = true;

  hm.hyprland.enable = true;
}
