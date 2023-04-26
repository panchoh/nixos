{
  config,
  pkgs,
  ...
}: {
  programs.home-manager.enable = true;

  home = {
    username = "pancho";
    homeDirectory = "/home/pancho";
    stateVersion = "22.11";
  };

  stylix = {
    autoEnable = false;

    # image = pkgs.fetchurl {
    #   url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
    #   sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
    # };

    # image = pkgs.fetchurl {
    #   url = "https://cdnb.artstation.com/p/assets/images/images/016/252/301/4k/grady-frederick-atlantis-garbageman-v2.jpg";
    #   sha256 = "tAX6qTm1/7v/auvCHrmRswJsScNieSWpXV6TCBhRP7Y=";
    # };

    # image = ./wallpaper.jpg;

    # polarity = "dark";

    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";

    fonts = {
      serif = {
        package = pkgs.iosevka-bin;
        name = "Iosevka Etoile";
      };

      sansSerif = {
        package = pkgs.iosevka-bin;
        name = "Iosevka Aile";
      };

      monospace = {
        package = pkgs.iosevka-bin;
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

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      ########################################################################################
      AUTOGENERATED HYPR CONFIG.
      PLEASE USE THE CONFIG PROVIDED IN THE GIT REPO /examples/hypr.conf AND EDIT IT,
      OR EDIT THIS ONE ACCORDING TO THE WIKI INSTRUCTIONS.
      ########################################################################################

      #
      # Please note not all available settings / options are set here.
      # For a full list, see the wiki
      #

      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor=,preferred,auto,auto
      monitor=DP-1, 3840x1600@60, 0x0, 1, bitdepth, 10

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more

      # Execute your favorite apps at launch
      # exec-once = waybar & hyprpaper & firefox
      exec-once = foot

      # https://github.com/hyprwm/Hyprland/issues/1475
      # https://github.com/hyprwm/Hyprland/discussions/179
      exec-once = swayidle -w timeout 300 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on'

      # Source a file (multi-file configs)
      # source = ~/.config/hypr/myColors.conf

      # Some default env vars.
      env = XCURSOR_SIZE,24

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
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

      # https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs
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
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

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
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

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

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }

      dwindle {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = yes # master switch for pseudotiling. Enabling is bound to SUPER + P in the keybinds section below
          preserve_split = yes # you probably want this
          no_gaps_when_only = yes
      }

      master {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          mfact = 0.50
          new_is_master = true
          orientation = center
          no_gaps_when_only = yes
      }

      gestures {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = off
      }

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
      device:epic-mouse-v1 {
          sensitivity = -0.5
      }

      # Example windowrule v1
      # windowrule = float, ^(kitty)$
      # Example windowrule v2
      # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

      # https://www.reddit.com/r/hyprland/comments/zoeqoz/anyway_to_remove_the_hyprland_startup_logo/
      misc {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
      }

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      #$mainMod = SUPER

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = SUPER, Return, exec, foot
      bind = SUPER, Slash, exec, chromium
      bind = SUPER, X, exec, emacs
      bind = SUPER SHIFT, Slash, exec, google-chrome-stable
      bind = SUPER SHIFT, Q, killactive,
      bind = SUPER SHIFT, E, exit,
      #bind = SUPER, E, exec, dolphin
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
      # for the next release
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

      # https://github.com/hyprwm/Hyprland/pull/352
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

      # will reset the submap, meaning end the current one and return to the global one
      submap = reset
      # keybinds further down will be global again...


      # Move/resize windows with SUPER + LMB/RMB and dragging
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow

      # Start wofi opens wofi on first press, closes it on second
      #bindr = SUPER, SUPER_L, exec, pkill wofi || wofi --show drun
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
  };

  xdg.enable = true;
  xdg.configFile."fuzzel/fuzzel.ini".enable = true;
  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    [main]
    font = Iosevka:size=16:weight=light
    terminal = foot -e

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

  programs.foot = {
    enable = true;
    settings = {
      main = {
        #include = "${pkgs.foot.themes}/share/foot/themes/dracula";
        #font = "Iosevka:weight=Light:size=16";
        #font-bold = "Iosevka:weight=Regular:size=16";
        #dpi-aware = false;
      };
      mouse = {
        hide-when-typing = true;
      };
    };
  };

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

  programs.mpv.enable = true;
  programs.mpv.defaultProfiles = ["gpu-hq"];
  programs.mpv.bindings = {
    WHEEL_UP = "seek 10";
    WHEEL_DOWN = "seek -10";
    "Alt+0" = "set window-scale 0.5";
  };
  programs.mpv.profiles = {
    fast = {
      vo = "vdpau";
    };
    "protocol.dvd" = {
      profile-desc = "profile for dvd:// streams";
      alang = "en";
    };
  };
  programs.mpv.scripts = [pkgs.mpvScripts.mpris];
  programs.mpv.config = {
    fullscreen = true;
    sub-auto = "fuzzy";
    #profile=gpu-hq
    #scale=ewa_lanczossharp
    #cscale=ewa_lanczossharp
    #video-sync=display-resample
    #interpolation
    #tscale=oversample
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

    # If vo=gpu-next is enabled, the hdr-compute-peak=no is not needed :-?

    #audio-device=alsa/iec958:CARD=MM1,DEV=0
    #audio-device=alsa/hdmi:CARD=PCH,DEV=0
    #audio-device=alsa/iec958:CARD=X,DEV=0
  };
}
