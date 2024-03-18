{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.traits.hm.hyprland;

  foot = lib.getExe config.programs.foot.package;
  swayidle = lib.getExe pkgs.swayidle;
  hyprctl = lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl";
  emacsclient = lib.getExe' config.programs.emacs.finalPackage "emacsclient";
  fuzzel = lib.getExe pkgs.fuzzel;
  makoctl = lib.getExe' pkgs.mako "makoctl";
in {
  options.traits.hm.hyprland = {
    enable = lib.mkEnableOption "hyprland" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      swaylock
      grim
      grimblast
      hyprpicker
      satty # TODO: also configure hyprland keybinding
      slurp
      wl-clipboard
      wlrctl
      wev
      xkeyboard_config
      libxkbcommon # for xkbcli interactive-wayland
    ];

    # TODO: migrate to native nix structure and be done with hardcoded paths
    wayland.windowManager.hyprland = {
      enable = true;
      package = osConfig.programs.hyprland.finalPackage;
      xwayland.enable = osConfig.programs.hyprland.xwayland.enable;
      extraConfig = ''
        monitor=, preferred, auto, auto, bitdepth, 10
        exec-once = ${foot}
        exec-once = ${swayidle} -w timeout 300 '${hyprctl} dispatch dpms off' resume '${hyprctl} dispatch dpms on'
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

        device {
            name = keychron-keychron-q10
            kb_model = pc105
            kb_layout = us,us
            kb_variant = altgr-intl,dvorak-alt-intl
            kb_options = lv3:ralt_switch_multikey,grp:caps_toggle,terminate:ctrl_alt_bksp
        }

        device {
            name = keychron-keychron-q8
            kb_model = pc105
            kb_layout = us,us
            kb_variant = altgr-intl,dvorak-alt-intl
            kb_options = lv3:ralt_switch_multikey,grp:caps_toggle,terminate:ctrl_alt_bksp
        }

        device {
            name = PFU_Limited_HHKB-Classic
            kb_model = hhk
            kb_layout = us,us
            kb_variant = altgr-intl,dvorak-alt-intl
            kb_options = lv3:ralt_switch_multikey,grp:caps_toggle,terminate:ctrl_alt_bksp
        }

        device {
            name = at-translated-set-2-keyboard
            kb_model = thinkpad
            kb_layout = us,us
            kb_variant = altgr-intl,dvorak-alt-intl
            kb_options = lv3:ralt_switch_multikey,terminate:ctrl_alt_bksp,ctrl:swapcaps
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

        bind = SUPER, Return, exec, ${foot}
        bind = SUPER, X, exec, ${emacsclient} --no-wait --reuse-frame
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
        bind = SUPER, D, exec, ${fuzzel}

        # Handle notifications
        bind = SUPER,       N, exec, ${makoctl} dismiss
        bind = SUPER SHIFT, N, exec, ${makoctl} dismiss -a

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

        # Radios management
        # https://github.com/dwlocks/scripts-tools-config/blob/master/etc/rfkill-toggle
        bindl =      , XF86WLAN,             exec, sh -c '[[ "$(< /sys/class/rfkill/rfkill0/state)" == "1" ]] && rfkill block all || rfkill unblock all'

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
  };
}
