{
  config,
  pkgs,
  lib,
  osConfig,
  stylix,
  autofirma-nix,
  attrs ? null,
  ...
} @ inputs: {
  imports = [
    stylix.homeManagerModules.stylix
    autofirma-nix.homeManagerModules.default
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
    # yubioath-flutter

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
    nil

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

  programs.tmux.enable = true;

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
  programs.fzf.enable = true;
  programs.zoxide.enable = true;
  programs.thefuck.enable = true;
  programs.jq.enable = true;

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

  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--incognito"
      "--ozone-platform=wayland"
    ];
  };

  programs.google-chrome = {
    enable = true;
    commandLineArgs = [
      "--ozone-platform=wayland"
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.gpg = {
    enable = true;
    scdaemonSettings = {
      disable-ccid = true; # Play nice with yubikey https://ludovicrousseau.blogspot.com/2019/06/gnupg-and-pcsc-conflicts.html
      reader-port = "Yubico YubiKey CCID 00 00"; # Get this value with pcsc_scan
    };
    homedir = "${config.xdg.dataHome}/gnupg";
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1;
    enableSshSupport = true;
    pinentryFlavor = "gnome3";
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    controlMaster = "no";
    controlPersist = "yes";
    serverAliveInterval = 60;
    extraConfig = ''
      ExitOnForwardFailure yes
      HostKeyAlgorithms    ssh-ed25519
      IdentitiesOnly       yes
      # IdentityFile         ~/.ssh/keys.d/id_ed25519-%r@%h
      IdentityFile         ~/.ssh/keys.d/id_ed25519_openpgp_YubiKey_5C_Nano-%r@%h
      IdentityFile         ~/.ssh/keys.d/id_ed25519_sk_rk_YubiKey_5C_NFC_#1-%r@%h
      IdentityFile         ~/.ssh/keys.d/id_ed25519_sk_rk_YubiKey_5C_NFC_#2-%r@%h
      IdentityFile         ~/.ssh/keys.d/id_ed25519_sk_rk_YubiKey_C_Bio_#1-%r@%h
      IdentityFile         ~/.ssh/keys.d/id_ed25519_sk_rk_YubiKey_C_Bio_#2-%r@%h
      SendEnv              LC_*
      VisualHostKey        yes
    '';
    matchBlocks = {
      "ubuntu* k8s-*" = lib.hm.dag.entryBefore ["*.vm"] {
        user = "sysadmin";
        identityFile = "~/.ssh/keys.d/id_ed25519-sysadmin@ubuntu";
        extraOptions = {
          GlobalKnownHostsFile = "/dev/null";
          UserKnownHostsFile = "/dev/null";
          StrictHostKeyChecking = "no";
        };
      };
      "*.vm" = lib.hm.dag.entryAnywhere {
        extraOptions = {
          GlobalKnownHostsFile = "/dev/null";
          UserKnownHostsFile = "/dev/null";
          StrictHostKeyChecking = "no";
        };
        identityFile = "~/.ssh/keys.d/id_ed25519-wildcard.vm";
        proxyCommand = "${pkgs.libressl}/bin/nc ( string replace .vm '' %h ) %p";
      };
    };
  };

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

  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";

    image = pkgs.fetchurl {
      url = "https://github.com/NixOS/nixos-artwork/raw/master/wallpapers/nix-wallpaper-dracula.png";
      sha256 = "sha256-SykeFJXCzkeaxw06np0QkJCK28e0k30PdY8ZDVcQnh4=";
    };

    # https://www.reddit.com/r/NixOS/comments/3jqd2u/anyone_want_a_wallpaper/
    # also check: https://github.com/NixOS/nixos-artwork/tree/master/wallpapers
    # image = pkgs.fetchurl {
    #   url = "http://reign-studios.com/wallpapers/nixos/wallpaper.svg";
    #   sha256 = "sha256-vXbw39v0sA+aR/9Gg0NOPgL3QHuw0Wl+ACbn9VJ8Fyg=";
    # };

    # image = pkgs.fetchurl {
    #   url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
    #   sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
    # };

    # image = pkgs.fetchurl {
    #   url = "https://cdnb.artstation.com/p/assets/images/images/016/252/301/4k/grady-frederick-atlantis-garbageman-v2.jpg";
    #   sha256 = "tAX6qTm1/7v/auvCHrmRswJsScNieSWpXV6TCBhRP7Y=";
    # };

    fonts = {
      serif = {
        package = pkgs.iosevka-bin.override {variant = "etoile";};
        name = "Iosevka Etoile";
      };

      sansSerif = {
        package = pkgs.iosevka-bin.override {variant = "aile";};
        name = "Iosevka Aile";
      };

      monospace = {
        package = pkgs.iosevka-bin.override {variant = "sgr-iosevka-term";};
        name = "Iosevka Term";
      };

      emoji = {
        name = "OpenMoji Color";
        package = pkgs.openmoji-color;
      };

      sizes = {
        desktop = 10;
        applications = 12;
        terminal = 16;
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = osConfig.programs.hyprland.finalPackage;
    xwayland.enable = osConfig.programs.hyprland.xwayland.enable;
    extraConfig = ''
      monitor=, preferred, auto, auto, bitdepth, 10
      exec-once = ${lib.getExe pkgs.foot}
      exec-once = ${lib.getExe pkgs.swayidle} -w timeout 300 '${lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl"} dispatch dpms off' resume '${lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl"} dispatch dpms on'
      env = XCURSOR_SIZE,24

      input {
          follow_mouse = 1
          touchpad {
              natural_scroll = no
          }
          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }

      # kb_options explanation:
      # Shift-AltGr: compose
      # Caps: group switch
      # Shift-Caps: Ye'Olde Caps

      device:keychron-keychron-q10 {
          kb_model = pc105
          kb_layout = us,us
          kb_variant = altgr-intl,dvorak-alt-intl
          kb_options = lv3:ralt_switch_multikey,grp:caps_toggle,terminate:ctrl_alt_bksp
      }

      device:keychron-keychron-q8 {
          kb_model = pc105
          kb_layout = us,us
          kb_variant = altgr-intl,dvorak-alt-intl
          kb_options = lv3:ralt_switch_multikey,grp:caps_toggle,terminate:ctrl_alt_bksp
      }

      device:PFU_Limited_HHKB-Classic {
          kb_model = hhk
          kb_layout = us,us
          kb_variant = altgr-intl,dvorak-alt-intl
          kb_options = lv3:ralt_switch_multikey,grp:caps_toggle,terminate:ctrl_alt_bksp
      }

      general {
          gaps_in = 5
          gaps_out = 20
          border_size = 2
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)

          layout = master

          cursor_inactive_timeout = 5
          resize_on_border = true
          hover_icon_on_border = true
      }

      decoration {
          rounding = 5
          # blur = yes
          # blur_size = 3
          # blur_passes = 1
          # blur_new_optimizations = on

          # drop_shadow = yes
          # shadow_range = 4
          # shadow_render_power = 3
          # col.shadow = rgba(1a1a1aee)
      }

      animations {
          enabled = no
      }

      master {
          allow_small_split = true
          mfact = 0.66
          new_is_master = true
          no_gaps_when_only = true
          orientation = right
          # orientation = center
      }

      gestures {
          workspace_swipe = off
      }

      # https://www.reddit.com/r/hyprland/comments/zoeqoz/anyway_to_remove_the_hyprland_startup_logo/
      # https://github.com/hyprwm/Hyprland/issues/3073
      misc {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          focus_on_activate = true;
      }

      # https://github.com/hyprwm/Hyprland/pull/352/files
      binds {
          workspace_back_and_forth = false
          allow_workspace_cycles = true
      }

      bind = SUPER, Return, exec, ${lib.getExe pkgs.foot}
      bind = SUPER, X, exec, ${lib.getExe' config.programs.emacs.finalPackage "emacsclient"} --no-wait --reuse-frame --alternate-editor='${lib.getExe pkgs.foot} ${lib.getExe pkgs.neovim}'
      bind = SUPER,       Slash, exec, chromium
      bind = SUPER SHIFT, Slash, exec, google-chrome-stable

      # bind = , Terminate_Server, exit,
      # bind = , terminate_server, exit,
      bind = CONTROL ALT, BackSpace, exit,

      bind = SUPER SHIFT, Q, killactive,

      bind = SUPER SHIFT, Return, layoutmsg, swapwithmaster master
      bind = SUPER,       M,      layoutmsg, focusmaster auto
      bind = SUPER,       SPACE,  focusurgentorlast,
      bind = SUPER SHIFT, SPACE,  togglefloating,

      bind = SUPER,       TAB, layoutmsg, cyclenext
      bind = SUPER SHIFT, TAB, layoutmsg, cycleprev

      bind = SUPER, H, movefocus, l
      bind = SUPER, L, movefocus, r
      bind = SUPER, K, movefocus, u
      bind = SUPER, J, movefocus, d

      bind = SUPER SHIFT, H, layoutmsg, removemaster
      bind = SUPER SHIFT, L, layoutmsg, addmaster
      bind = SUPER SHIFT, K, layoutmsg, swapprev
      bind = SUPER SHIFT, J, layoutmsg, swapnext

      # Switch workspaces with SUPER + [0-9]
      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6
      bind = SUPER, 7, workspace, 7
      bind = SUPER, 8, workspace, 8
      bind = SUPER, 9, workspace, 9
      bind = SUPER, 0, workspace, 10

      bind = SUPER, A, workspace, previous

      # Cycle through active workspaces
      bind = SUPER, right, workspace, e+1
      bind = SUPER, left, workspace, e-1
      bind = SUPER, mouse_down, workspace, e+1
      bind = SUPER, mouse_up, workspace, e-1

      # Move active window to a workspace with SUPER + SHIFT + [0-9]
      bind = SUPER SHIFT, 1, movetoworkspacesilent, 1
      bind = SUPER SHIFT, 2, movetoworkspacesilent, 2
      bind = SUPER SHIFT, 3, movetoworkspacesilent, 3
      bind = SUPER SHIFT, 4, movetoworkspacesilent, 4
      bind = SUPER SHIFT, 5, movetoworkspacesilent, 5
      bind = SUPER SHIFT, 6, movetoworkspacesilent, 6
      bind = SUPER SHIFT, 7, movetoworkspacesilent, 7
      bind = SUPER SHIFT, 8, movetoworkspacesilent, 8
      bind = SUPER SHIFT, 9, movetoworkspacesilent, 9
      bind = SUPER SHIFT, 0, movetoworkspacesilent, 10

      bind = SUPER,       W, movetoworkspacesilent, special
      bind = SUPER SHIFT, W, togglespecialworkspace

      # Select / Move to scratchpads
      bind = SUPER SHIFT, Minus, movetoworkspace,        special:s1
      bind = SUPER,       Minus, togglespecialworkspace, s1
      bind = SUPER SHIFT, Equal, movetoworkspace,        special:s2
      bind = SUPER,       Equal, togglespecialworkspace, s2

      bind = SUPER,       F, fullscreen, 0
      bind = SUPER ALT,   F, fullscreen, 1
      bind = SUPER SHIFT, F, fakefullscreen

      # Start fuzzel opens fuzzel on first press, closes it on second
      # bindr = SUPER, SUPER_L, exec, pkill fuzzel || fuzzel
      bind = SUPER, D, exec, ${lib.getExe pkgs.fuzzel}

      # Handle notifications
      bind = SUPER,       N, exec, ${lib.getExe' pkgs.mako "makoctl"} dismiss
      bind = SUPER SHIFT, N, exec, ${lib.getExe' pkgs.mako "makoctl"} dismiss -a

      # Screenshots
      # bind = SUPER,       P, exec, grimblast save active
      # bind = SUPER SHIFT, P, exec, grimblast save area
      # bind = SUPER ALT,   P, exec, grimblast save output
      # bind = SUPER CTRL,  P, exec, grimblast save screen
      bind =      , Print, exec, grimblast save active
      bind = SHIFT, Print, exec, grimblast save area
      bind = ALT,   Print, exec, grimblast save output
      bind = CTRL,  Print, exec, grimblast save screen

      # Multimedia
      bindl =      , XF86AudioMute,        exec, wpctl set-mute        @DEFAULT_AUDIO_SINK@   toggle
      bindl =      , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@   1%+
      bindl =      , XF86AudioLowerVolume, exec, wpctl set-volume      @DEFAULT_AUDIO_SINK@   1%-
      bindl = SHIFT, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@   5%+
      bindl = SHIFT, XF86AudioLowerVolume, exec, wpctl set-volume      @DEFAULT_AUDIO_SINK@   5%-
      bindl =      , XF86AudioPrev,        exec, playerctl previous
      bindl =      , XF86AudioPlay,        exec, playerctl play-pause
      bindl =      , XF86AudioNext,        exec, playerctl next

      # Move/resize windows with SUPER + LMB/RMB and dragging
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow

      # Resize submap
      bind = SUPER, R, submap, resize
      submap = resize
        bind  = SUPER, R,      submap, reset
        bind  =      , Escape, submap, reset
        bind  =      , Return, submap, reset
        binde =      , L,      resizeactive, 5 0
        binde =      , H,      resizeactive, -5 0
        binde =      , K,      resizeactive, 0 -5
        binde =      , J,      resizeactive, 0 5
        binde = SHIFT, L,      resizeactive, 100 0
        binde = SHIFT, H,      resizeactive, -100 0
        binde = SHIFT, K,      resizeactive, 0 -100
        binde = SHIFT, J,      resizeactive, 0 100
      submap = reset
    '';
  };
}
