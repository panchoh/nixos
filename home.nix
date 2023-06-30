{
  config,
  pkgs,
  lib,
  stylix,
  hyprland,
  attrs ? null,
  ...
} @ inputs: {
  imports = [
    stylix.homeManagerModules.stylix
    hyprland.homeManagerModules.default
  ];

  home = {
    stateVersion = "23.11";
    username = attrs.userName or "alice";
    homeDirectory = "/home/${attrs.userName or "alice"}";
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.local/bin.go"
      "${config.xdg.configHome}/emacs/bin"
    ];
    # sessionVariables = {
    #   foo = "bar";
    # };

    activation = {
      DoomEmacsAction = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [[ ! -d "${config.xdg.configHome}"/emacs ]]; then
          $DRY_RUN_CMD ${pkgs.git}/bin/git clone $VERBOSE_ARG --depth=1 --single-branch https://github.com/doomemacs/doomemacs.git "${config.xdg.configHome}"/emacs
        fi
        if [[ ! -d "${config.xdg.configHome}"/doom ]]; then
          $DRY_RUN_CMD ${pkgs.git}/bin/git clone $VERBOSE_ARG https://github.com/panchoh/dotconfig-doom.git "${config.xdg.configHome}"/doom
          # PATH="${pkgs.git}/bin:$PATH" EMACS="${config.programs.emacs.finalPackage}"/bin/emacs $DRY_RUN_CMD "${config.xdg.configHome}"/emacs/bin/doom sync
        fi
      '';
    };

    packages = with pkgs; [
      psmisc
      sysstat
      pciutils
      usbutils
      usbtop
      btop
      smartmontools
      hdparm
      nvme-cli
      sg3_utils
      lm_sensors
      ldns
      dogdns
      nmap
      mtr-gui
      moreutils
      hwloc
      b3sum

      (nerdfonts.override {fonts = ["IosevkaTerm"];})
      (iosevka-bin.override {variant = "slab";})
      iosevka-bin

      pavucontrol
      playerctl

      fuzzel
      swaylock
      swayidle
      grim
      slurp
      wl-clipboard
      wev
      xkeyboard_config

      v4l-utils
      graphviz
      vlc
      mkvtoolnix
      evince
      gimp
      inkscape
      audacity
      picard
      zoom-us

      qmk
      qmk_hid
      keymapviz

      alejandra
      (aspellWithDicts (ds: with ds; [en en-computers en-science]))
      binutils
      duf
      editorconfig-core-c
      file
      fd
      gcc
      gitg
      tig
      gource
      gti
      gnutls
      zstd
      tmux
      emacs-all-the-icons-fonts
      python311Packages.grip
      meld

      jq
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

      google-chrome
      telegram-desktop
      discord
      nheko
      tessen

      transmission-gtk

      mangohud
      intel-gpu-tools

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
          exec ${alejandra}/bin/alejandra --quiet "\$@"
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
      sl
      neofetch
      hyperrogue
    ];
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
    configFile."fuzzel/fuzzel.ini" = {
      enable = true;
      text = ''
        [main]
        font = Iosevka:size=16:weight=ExtraLight
        terminal = ${pkgs.foot}/bin/foot -e

        # https://raw.githubusercontent.com/dracula/fuzzel/main/fuzzel.ini
        [colors]
        background=282a36dd
        text=f8f8f2ff
        match=8be9fdff
        selection-match=8be9fdff
        selection=44475add
        selection-text=f8f8f2ff
        border=bd93f9ff
      '';
    };
  };

  stylix.targets.foot.enable = false;
  programs.foot = {
    enable = true;
    settings = {
      main = {
        include = "${pkgs.foot.themes}/share/foot/themes/dracula";
        font = "IosevkaTerm NFM Light:size=16";
        font-bold = "IosevkaTerm NFM:size=16";
        dpi-aware = false;
      };
      mouse = {
        hide-when-typing = true;
      };
    };
  };

  programs.bash.enable = true;

  programs.fish = {
    enable = true;
    shellAliases = {
      e = "emacsclient --no-wait --reuse-frame --alternate-editor=nvim";
    };
  };
  programs.starship.enable = true;
  programs.lsd = {
    enable = true;
    enableAliases = true;
    settings = {
      date = "relative";
      header = true;
      ignore-globs = [
        ".git"
        ".hg"
      ];
    };
  };
  programs.exa = {
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

  programs.imv.enable = true;

  programs.mpv = {
    enable = true;
    scripts = [pkgs.mpvScripts.mpris];
    bindings = {
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

  programs.firefox.enable = true;

  programs.chromium = {
    enable = true;
    commandLineArgs = ["--incognito"];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1;
    enableSshSupport = false;
    pinentryFlavor = "gtk2";
  };

  programs.ssh = {
    enable = true;
    controlMaster = "no";
    controlPersist = "yes";
    serverAliveInterval = 60;
    extraConfig = ''
      AddKeysToAgent       yes
      ExitOnForwardFailure yes
      HostKeyAlgorithms    ssh-ed25519
      IdentitiesOnly       yes
      IdentityFile         ~/.ssh/keys.d/id_ed25519-%r@%h
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

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
    extraPackages = epkgs: [epkgs.vterm];
  };

  services.emacs = {
    enable = true;
    defaultEditor = true;
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
    recommendedEnvironment = true;
    extraConfig = ''
      monitor=, preferred, auto, auto, bitdepth, 10
      exec-once = ${pkgs.foot}/bin/foot
      exec-once = swayidle -w timeout 300 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'
      env = XCURSOR_SIZE,24

      input {
          follow_mouse = 1

          touchpad {
              natural_scroll = no
          }

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }

      device:keychron-keychron-q10 {
          kb_model = pc105
          kb_layout = us,us
          kb_variant = altgr-intl,dvorak-alt-intl
          kb_options = lv3:ralt_switch_multikey,grp:caps_toggle,terminate:ctrl_alt_bksp
          # Shift-Alt: compose
          # Caps: group switch
          # Shift-Caps: Ye'Olde Caps
      }

      device:keychron-keychron-q8 {
          kb_model = pc105
          kb_layout = us,us
          kb_variant = altgr-intl,dvorak-alt-intl
          kb_options = lv3:ralt_switch_multikey,grp:caps_toggle
      }

      device:PFU_Limited_HHKB-Classic {
          kb_model = hhk
          kb_layout = us,us
          kb_variant = altgr-intl,dvorak-alt-intl
          kb_options = lv3:ralt_switch_multikey,grp:caps_toggle
      }

      general {
          gaps_in = 5
          gaps_out = 20
          border_size = 2
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)

          # layout = dwindle
          layout = master

          cursor_inactive_timeout = 5
          resize_on_border = true
          hover_icon_on_border = true

          # FIXME: For next release?
          # workspace_back_and_forth = true
          # allow_workspace_cycles = true
      }

      decoration {
          rounding = 10
          blur = yes
          blur_size = 3
          blur_passes = 1
          blur_new_optimizations = on

          drop_shadow = yes
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)
      }

      animations {
          enabled = no

          bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }

      dwindle {
          pseudotile = yes # master switch for pseudotiling. Enabling is bound to SUPER + P in the keybinds section below
          preserve_split = yes # you probably want this
          no_gaps_when_only = yes
      }

      master {
          mfact = 0.50
          new_is_master = true
          orientation = center
          no_gaps_when_only = yes
      }

      gestures {
          workspace_swipe = off
      }

      # https://www.reddit.com/r/hyprland/comments/zoeqoz/anyway_to_remove_the_hyprland_startup_logo/
      misc {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
      }

      bind = SUPER, Return, exec, ${pkgs.foot}/bin/foot
      bind = SUPER, Slash, exec, chromium
      bind = SUPER, X, exec, ${config.programs.emacs.finalPackage}/bin/emacsclient --no-wait --reuse-frame --alternate-editor="${pkgs.foot}/bin/foot -e nvim"
      bind = SUPER SHIFT, Slash, exec, google-chrome-stable
      bind = SUPER SHIFT, Q, killactive,
      bind = , Terminate_Server, exit,
      bind = , terminate_server, exit,
      # bind = CONTROL ALT, BackSpace, exit,
      bind = SUPER SHIFT, SPACE, togglefloating,
      bind = SUPER, SPACE, focusurgentorlast,
      bind = SUPER, P, pseudo, # dwindle
      bind = SUPER, S, togglesplit, # dwindle

      # Master
      bind = SUPER SHIFT, Return, layoutmsg, swapwithmaster auto
      bind = SUPER, M, layoutmsg, focusmaster auto

      # Move focus with SUPER + cursors
      bind = SUPER, H, movefocus, l
      bind = SUPER, L, movefocus, r
      bind = SUPER, K, movefocus, u
      bind = SUPER, J, movefocus, d
      bind = SUPER, TAB, cyclenext,
      bind = SUPER SHIFT, TAB, cyclenext, prev

      # Swap windows with SUPER SHIFT + cursors
      # FIXME for the next release
      #bind = SUPER SHIFT, H, swapwindow, l
      #bind = SUPER SHIFT, L, swapwindow, r
      #bind = SUPER SHIFT, K, swapwindow, u
      #bind = SUPER SHIFT, J, swapwindow, d
      bind = SUPER SHIFT, H, movewindow, l
      bind = SUPER SHIFT, L, movewindow, r
      bind = SUPER SHIFT, K, movewindow, u
      bind = SUPER SHIFT, J, movewindow, d

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

      # Cycle through active workspaces
      bind = SUPER, right, workspace, e+1
      bind = SUPER, left, workspace, e-1

      # FIXME
      #bind = SUPER, left, workspace, previous

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

      bind = SUPER SHIFT, Minus, movetoworkspace, special:s1
      bind = SUPER, Minus, togglespecialworkspace, s1
      bind = SUPER SHIFT, Equal, movetoworkspace, special:s2
      bind = SUPER, Equal, togglespecialworkspace, s2

      # FIXME https://github.com/hyprwm/Hyprland/pull/352
      #bind = SUPER, A, focuscurrentorlast,
      bind = SUPER, A, workspace, previous

      # Scroll through existing workspaces with SUPER + scroll
      bind = SUPER, mouse_down, workspace, e+1
      bind = SUPER, mouse_up, workspace, e-1

      bind = SUPER, F, fullscreen, 0
      bind = SUPER ALT, F, fullscreen, 1
      bind = SUPER SHIFT, F, fakefullscreen,

      # Submaps, see https://wiki.hyprland.org/Configuring/Binds/#submaps
      # will switch to a submap called resize
      bind = SUPER, R, submap, resize

      # will start a submap called "resize"
      submap = resize

      # sets repeatable binds for resizing the active window
      binde = , L, resizeactive, 5 0
      binde = , H, resizeactive, -5 0
      binde = , K, resizeactive, 0 -5
      binde = , J, resizeactive, 0 5
      binde = SHIFT, L, resizeactive, 100 0
      binde = SHIFT, H, resizeactive, -100 0
      binde = SHIFT, K, resizeactive, 0 -100
      binde = SHIFT, J, resizeactive, 0 100

      # use reset to go back to the global submap
      bind = , Escape, submap, reset
      bind = , Return, submap, reset
      bind = SUPER, R, submap, reset

      # will reset the submap, meaning end the current one and return to the global one
      submap = reset
      # keybinds further down will be global again...


      # Move/resize windows with SUPER + LMB/RMB and dragging
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow

      # Start fuzzel opens fuzzel on first press, closes it on second
      # bindr = SUPER, SUPER_L, exec, pkill fuzzel || fuzzel
      bind = SUPER, D, exec, fuzzel

      # Handle notifications
      bind = SUPER, N, exec, makoctl dismiss
      bind = SUPER SHIFT, N, exec, makoctl dismiss -a

      # Multimedia
      #bindl = , XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@   +1%
      #bindl = , XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@   -1%
      #bindl = , XF86AudioMute,        exec, pactl set-sink-mute   @DEFAULT_SINK@   toggle
      #bindl = , XF86AudioMute,        exec, wpctl set-mute        @DEFAULT_SINK@   toggle

      bindl =      , XF86AudioMute,        exec, wpctl set-mute        @DEFAULT_AUDIO_SINK@   toggle
      bindl =      , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@   1%+
      bindl =      , XF86AudioLowerVolume, exec, wpctl set-volume      @DEFAULT_AUDIO_SINK@   1%-
      bindl = SHIFT, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@   5%+
      bindl = SHIFT, XF86AudioLowerVolume, exec, wpctl set-volume      @DEFAULT_AUDIO_SINK@   5%-

      bindl = , XF86AudioPlay, exec, playerctl play-pause
      bindl = , XF86AudioNext, exec, playerctl next
      bindl = , XF86AudioPrev, exec, playerctl previous
    '';
  };
}
