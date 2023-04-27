{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.home-manager.enable = true;

  home = {
    username = "pancho";
    homeDirectory = "/home/pancho";
    stateVersion = "22.11";
  };

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
        package = pkgs.iosevka-bin.override { variant = "etoile"; };
        name = "Iosevka Etoile";
      };

      sansSerif = {
        package = pkgs.iosevka-bin.override { variant = "aile"; };
        name = "Iosevka Aile";
      };

      monospace = {
        package = pkgs.iosevka-bin.override { variant = ""; };
        name = "Iosevka Term";
      };

      emoji = {
        name = "OpenMoji Color";
        package = pkgs.openmoji-color;
      };

      # emoji = {
      #   package = pkgs.noto-fonts-emoji;
      #   name = "Noto Color Emoji";
      # };

      sizes = {
        terminal = 16;
        desktop = 14;
      };
    };
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    fd
    ripgrep
    pavucontrol
    fuzzel
    swaylock
    swayidle
    mako
    grim
    slurp
    wl-clipboard
    wev

    alejandra
    emacs-all-the-icons-fonts
    python311Packages.grip
    go
    gotools
    gopls
    gomodifytags
    gotests
    gore
    shfmt
    shellcheck
    nodejs_20

    (nerdfonts.override { fonts = [ "Iosevka" ]; })
    (iosevka-bin.override { variant = "slab"; })
  ];

  # home.extraOutputsToInstall = []; # FIXME

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      monitor=,preferred,auto,auto
      monitor=DP-1, 3840x1600@60, 0x0, 1, bitdepth, 10
      exec-once = ${pkgs.foot}/bin/foot
      exec-once = swayidle -w timeout 300 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'
      env = XCURSOR_SIZE,24

      input {
          kb_layout = us
          kb_variant =
          kb_model =
          kb_options =
          kb_rules =

          follow_mouse = 1

          touchpad {
              natural_scroll = no
          }

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }

      device:keychron-keychron-q8 {
          kb_model = pc105
          kb_layout = us,us
          kb_variant = altgr-intl,dvorak
          #kb_options = compose:sclk,grp:caps_toggle,grp_led:caps,shift:both_capslock
          kb_options = compose:sclk,grp:shifts_toggle
      }

      device:PFU_Limited_HHKB-Classic" {
          kb_model = hhk
          kb_layout = us,us
          kb_variant = altgr-intl,dvorak
          #kb_options = compose:sclk,grp:caps_toggle,grp_led:caps,shift:both_capslock
          kb_options compose:sclk,grp:shifts_toggle
      }

      general {
          gaps_in = 5
          gaps_out = 20
          border_size = 2
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)

          layout = dwindle
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
          enabled = yes

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
      bind = SUPER, X, exec, emacs
      bind = SUPER SHIFT, Slash, exec, google-chrome-stable
      bind = SUPER SHIFT, Q, killactive,
      bind = SUPER SHIFT, E, exit,
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
      bindr = SUPER, SUPER_L, exec, pkill fuzzel || fuzzel

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
    recommendedEnvironment = true;
  };

  xdg.enable = true;
  xdg.configFile."fuzzel/fuzzel.ini" = {
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

  stylix.targets.foot.enable = false;
  programs.foot = {
    enable = true;
    settings = {
      main = {
        include = "${pkgs.foot.themes}/share/foot/themes/dracula";
        font = "IosevkaTerm NFM:weight=Light:size=16";
        font-bold = "IosevkaTerm NFM:weight=Regular:size=16";
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
    loginShellInit = ''
      [ -z "$DISPLAY" -a "$XDG_VTNR" = 1 ] && exec ${pkgs.hyprland}/bin/Hyprland &>~/.Wsession.errors
    '';
  };
  programs.starship.enable = true;
  programs.exa = {
    enable = true;
    enableAliases = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
    icons = true;
  };
  programs.bat.enable = true;

  programs.git = {
    enable = true;
    userName = "pancho horrillo";
    userEmail = "pancho@pancho.name";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.mpv = {
    enable = true;
    bindings = {
      WHEEL_UP = "seek 10";
      WHEEL_DOWN = "seek -10";
      "Alt+0" = "set window-scale 0.5";
    };
    defaultProfiles = ["gpu-hq"];
    profiles = {
      fast = {
        vo = "vdpau";
      };
      "protocol.dvd" = {
        profile-desc = "profile for dvd:// streams";
        alang = "en";
      };
    };
    scripts = [pkgs.mpvScripts.mpris];
    config = {
      fullscreen = true;
      sub-auto = "fuzzy";
      # HDR https://github.com/mpv-player/mpv/issues/4285
      #tone-mapping=reinhard

      #####:vo=dmabuf-wayland
      #####:vo=gpu-next
      vo = "gpu-next";
      gpu-api = "vulkan";
      gpu-context = "waylandvk";
      #gpu-context=wayland
      #gpu-context=displayvk

      #hwdec=vaapi

      # https://github.com/mpv-player/mpv/issues/8981
      hdr-compute-peak = false;

      vd-lavc-dr = false;

      #audio-device=alsa/iec958:CARD=MM1,DEV=0
      #audio-device=alsa/hdmi:CARD=PCH,DEV=0
      #audio-device=alsa/iec958:CARD=X,DEV=0
    };
  };

  programs.firefox.enable = true;

  programs.chromium = {
    enable = true;
    commandLineArgs = ["--incognito"];
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs.override {withPgtk = true;};
    extraPackages = epkgs:
      with epkgs; [
        dracula-theme
        editorconfig
        magit
        pdf-tools
        vterm
      ];
  };

  home.activation = {
    DoomEmacsAction = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [[ ! -d "$XDG_CONFIG_HOME"/emacs ]]; then
        $DRY_RUN_CMD ${pkgs.git}/bin/git clone $VERBOSE_ARG --depth=1 --single-branch https://github.com/doomemacs/doomemacs.git "$XDG_CONFIG_HOME/emacs"
        $DRY_RUN_CMD ${pkgs.git}/bin/git clone $VERBOSE_ARG https://github.com/panchoh/dotconfig-doom.git "$XDG_CONFIG_HOME/doom"
      fi
    '';
  };
}
