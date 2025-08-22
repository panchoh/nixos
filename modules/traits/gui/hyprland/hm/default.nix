{
  config,
  lib,
  pkgs,
  nixosConfig,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.hyprland;
in
{
  options.traits.hm.hyprland = {
    enable = lib.mkEnableOption "Hyprland" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.hyprpaper.enable = lib.mkForce false;
    services.hypridle = {
      enable = true;
      settings = {
        listener = [
          {
            timeout = 300;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };

    home.packages = with pkgs; [
      (pkgs.writeShellApplication {
        name = "toggle-bitdepth";
        runtimeInputs = [ pkgs.jq ];
        text = ''
          # Toggle monitor bit depth between 8-bit and 10-bit

          MON=$(hyprctl monitors -j | jq -r '.[0].name')

          CUR=$(hyprctl monitors -j | jq -r --arg mon "$MON" '.[] | select(.name==$mon) | .currentFormat')

          if [[ "$CUR" == *"101010" ]]; then
            hyprctl keyword monitor 'desc:Dell Inc. DELL U4025QW B1MKH34, highrr, auto, auto, bitdepth, 8'
            hyprctl keyword monitor 'desc:Dell Inc. DELL U3818DW 5KC0386E05KL, preferred, auto, auto, bitdepth, 8'
            hyprctl keyword monitor 'desc:XXX Beyond TV 0x00010000, preferred, auto, 1.5, bitdepth, 8'
          else
            hyprctl keyword monitor 'desc:Dell Inc. DELL U4025QW B1MKH34, highrr, auto, auto, bitdepth, 10'
            hyprctl keyword monitor 'desc:Dell Inc. DELL U3818DW 5KC0386E05KL, preferred, auto, auto, bitdepth, 10'
            hyprctl keyword monitor 'desc:XXX Beyond TV 0x00010000, preferred, auto, 1.5, bitdepth, 10'
          fi
        '';
      })
      hyprpolkitagent
      hyprland-qtutils
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
      libinput # for libinput list-devices
      wayland-utils # for wayland-info
      wtype
      vrrtest
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = nixosConfig.programs.hyprland.package;
      xwayland.enable = nixosConfig.programs.hyprland.xwayland.enable;
      importantPrefixes = [
        "bezier"
        "name"
        "source"
      ];
      settings = {
        # CAVEAT EMPTOR: Google Meet does not support 10-bit depth, colors of shared windows will be off
        monitor = [
          # "desc:Dell Inc. DELL U4025QW B1MKH34, highrr, auto, auto, bitdepth, 10, vrr, 1"
          "desc:Dell Inc. DELL U4025QW B1MKH34, highrr, auto, auto, bitdepth, 10"
          "desc:Dell Inc. DELL U3818DW 5KC0386E05KL, preferred, auto, auto, bitdepth, 10"
          "desc:Chimei Innolux Corporation 0x14D4, preferred, auto, 1"
          "desc:XXX Beyond TV 0x00010000, preferred, auto, 1.5, bitdepth, 10"
        ];

        exec-once = [
          "systemctl --user start hyprpolkitagent"
        ];

        env = lib.mapAttrsToList (name: value: "${name}, ${toString value}") {
          XCURSOR_SIZE = 24;
        };

        input = {
          follow_mouse = 1;
          touchpad = {
            natural_scroll = false;
          };
          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        };

        # kb_options explanation:
        # AltGr: 3rd. level
        # AltGr-Shift: 4th. level
        # AltGr-Space: non-breaking space
        # AltGr-Shift-Space: thin non-breaking space
        # Shift-AltGr: compose
        # Caps: Ye'Olde Caps
        # Right Control: group switch

        device =
          let
            defaults = {
              name = "unnamed-keyboard";
              kb_model = "pc104";
              kb_layout = "us,us";
              kb_variant = "altgr-intl,colemak_dh";
              kb_options = "lv3:ralt_switch_multikey,grp:rctrl_toggle,nbsp:level3n";
            };
          in
          [
            {
              name = "apple-inc.-apple-internal-keyboard-/-trackpad-1";
              kb_model = "applealu_ansi";
            }
            {
              name = "at-translated-set-2-keyboard-1";
              kb_model = "thinkpad";
            }
            {
              name = "PFU_Limited_HHKB-Classic";
              kb_model = "hhk";
            }
            { name = "keychron-keychron-q8"; }
            { name = "keychron-keychron-q10"; }
            { name = "logitech-k400-plus-2"; }
            { name = "logitech-usb-receiver-2"; }
          ]
          |> map (overrides: defaults // overrides);

        cursor = {
          inactive_timeout = 5;
          hide_on_key_press = true;
        };

        general = {
          border_size = 2;
          "col.active_border" = lib.mkForce "rgba(33ccffee) rgba(00ff99ee) 45deg";
          # "col.inactive_border" = lib.mkForce "rgba(595959aa)";

          layout = "master";

          resize_on_border = true;
          hover_icon_on_border = true;
        };

        decoration = {
          rounding = 5;
          dim_inactive = true;
          dim_strength = 0.1;
        };

        animations = {
          enabled = true;
        };

        master = {
          mfact = 0.66;
          new_status = "inherit";
          new_on_active = "before";
          new_on_top = true;
          drop_at_cursor = false;
          smart_resizing = false;
          orientation = "right";
          slave_count_for_center_master = 0;
        };

        gestures = {
          workspace_swipe = false;
        };

        misc = {
          # https://www.reddit.com/r/hyprland/comments/zoeqoz/anyway_to_remove_the_hyprland_startup_logo/
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          force_default_wallpaper = 2;

          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;

          enable_swallow = true;
          swallow_regex = "^foot$";
          swallow_exception_regex = "^(.* *\.tex|wev.*|xkbcli.*)$";

          # https://github.com/hyprwm/Hyprland/issues/3073
          focus_on_activate = true;
        };

        # https://github.com/hyprwm/Hyprland/pull/352/files
        binds = {
          workspace_back_and_forth = false;
          hide_special_on_workspace_change = true;
          allow_workspace_cycles = true;
          workspace_center_on = 1;
        };

        render = {
          direct_scanout = 2;
        };

        animation = [
          "specialWorkspace, 1, 8, default, slidefadevert 20%"
        ];

        bind = [
          "SUPER SHIFT, Return, exec, foot"
          "SUPER,       D,      exec, doom-emacs"
          "SUPER,       E,      exec, emacs"
          "SUPER SHIFT, E,      exec, emacsclient --no-wait --reuse-frame"
          "SUPER,       slash,  exec, chromium"
          "SUPER SHIFT, slash,  exec, google-chrome-stable"

          "CONTROL ALT, BackSpace, exit,"

          "SUPER,       Q, forcerendererreload,"
          "SUPER,       X, killactive,"
          "SUPER SHIFT, X, exec, hyprctl kill"

          "SUPER,       U, focusurgentorlast,"
          "SUPER,       T, togglefloating, active"
          "SUPER SHIFT, B, exec, toggle-bitdepth"

          # Paste
          "SUPER,       V, sendshortcut, , mouse:274, activewindow"

          "SUPER,       Return,       layoutmsg, swapwithmaster master"
          "SUPER,       M,            layoutmsg, focusmaster auto"
          "SUPER SHIFT, backslash,    layoutmsg, orientationcycle left right"
          "SUPER,       space,        layoutmsg, orientationnext"
          "SUPER SHIFT, space,        layoutmsg, focusmaster master"
          "SUPER SHIFT, space,        layoutmsg, mfact exact 0.66"
          "SUPER SHIFT, space,        layoutmsg, orientationright"
          "SUPER,       bracketright, layoutmsg, rollnext"
          "SUPER,       bracketleft,  layoutmsg, rollprev"
          "SUPER,       period,       layoutmsg, addmaster"
          "SUPER,       comma,        layoutmsg, removemaster"
          "SUPER SHIFT, J,            layoutmsg, swapnext"
          "SUPER SHIFT, K,            layoutmsg, swapprev"
          "SUPER,       J,            layoutmsg, cyclenext"
          "SUPER,       Tab,          layoutmsg, cyclenext"
          "SUPER,       K,            layoutmsg, cycleprev"
          "SUPER SHIFT, Tab,          layoutmsg, cycleprev"
          "SUPER,       H,            layoutmsg, mfact +0.05"
          "SUPER SHIFT, H,            layoutmsg, mfact +0.2"
          "SUPER,       L,            layoutmsg, mfact -0.05"
          "SUPER SHIFT, L,            layoutmsg, mfact -0.2"

          # Switch workspaces with SUPER + [0-9]
          "SUPER, 1, workspace,  1"
          "SUPER, 2, workspace,  2"
          "SUPER, 3, workspace,  3"
          "SUPER, 4, workspace,  4"
          "SUPER, 5, workspace,  5"
          "SUPER, 6, workspace,  6"
          "SUPER, 7, workspace,  7"
          "SUPER, 8, workspace,  8"
          "SUPER, 9, workspace,  9"
          "SUPER, 0, workspace, 10"

          "SUPER, A, workspace, previous"

          # Cycle through active workspaces
          "SUPER, Right,      workspace, e+1"
          "SUPER, Left,       workspace, e-1"
          "SUPER, mouse_down, workspace, e+1"
          "SUPER, mouse_up,   workspace, e-1"

          # Move active window to a workspace with SUPER + SHIFT + [0-9]
          "SUPER SHIFT, 1, movetoworkspacesilent,  1"
          "SUPER SHIFT, 2, movetoworkspacesilent,  2"
          "SUPER SHIFT, 3, movetoworkspacesilent,  3"
          "SUPER SHIFT, 4, movetoworkspacesilent,  4"
          "SUPER SHIFT, 5, movetoworkspacesilent,  5"
          "SUPER SHIFT, 6, movetoworkspacesilent,  6"
          "SUPER SHIFT, 7, movetoworkspacesilent,  7"
          "SUPER SHIFT, 8, movetoworkspacesilent,  8"
          "SUPER SHIFT, 9, movetoworkspacesilent,  9"
          "SUPER SHIFT, 0, movetoworkspacesilent, 10"

          # Select / Move to scratchpads
          "SUPER SHIFT, grave, movetoworkspacesilent,  special"
          "SUPER,       grave, togglespecialworkspace"
          "SUPER SHIFT, Minus, movetoworkspacesilent,  special:Telegram"
          "SUPER,       Minus, togglespecialworkspace,         Telegram"
          "SUPER SHIFT, Equal, movetoworkspacesilent,  special:Transmission"
          "SUPER,       Equal, togglespecialworkspace,         Transmission"

          # Simulate “iconify”
          "SUPER,       W,     togglespecialworkspace,         magic"
          "SUPER,       W,     movetoworkspace,                +0"
          "SUPER,       W,     togglespecialworkspace,         magic"
          "SUPER,       W,     movetoworkspace,        special:magic"
          "SUPER,       W,     togglespecialworkspace,         magic"

          "SUPER,       F, fullscreen"
          "SUPER ALT,   F, fullscreenstate, 1, 1" # TODO: when 0.43 arrives, replace with "maximize"
          "SUPER SHIFT, F, fullscreenstate, 0, 2"

          # Start fuzzel opens fuzzel on first press, closes it on second
          # bindr = SUPER, SUPER_L, exec, pkill fuzzel || fuzzel
          "SUPER, P, exec, fuzzel"

          # Handle notifications
          "SUPER,       Escape, exec, makoctl dismiss"
          "SUPER SHIFT, Escape, exec, makoctl dismiss --all"

          # Screenshots
          # "SUPER,       P, exec, grimblast save active"
          # "SUPER SHIFT, P, exec, grimblast save area"
          # "SUPER ALT,   P, exec, grimblast save output"
          # "SUPER CTRL,  P, exec, grimblast save screen"
          "     , Print, exec, grimblast save active"
          "SHIFT, Print, exec, grimblast save area"
          "ALT,   Print, exec, grimblast save output"
          "CTRL,  Print, exec, grimblast save screen"
        ];

        bindl = [
          # Multimedia
          "     , XF86AudioMute,        exec, wpctl set-mute        @DEFAULT_AUDIO_SINK@   toggle"
          "     , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@   3%+"
          "     , XF86AudioLowerVolume, exec, wpctl set-volume      @DEFAULT_AUDIO_SINK@   3%-"
          "ALT  , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@   1%+"
          "ALT  , XF86AudioLowerVolume, exec, wpctl set-volume      @DEFAULT_AUDIO_SINK@   1%-"
          "SHIFT, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@   6%+"
          "SHIFT, XF86AudioLowerVolume, exec, wpctl set-volume      @DEFAULT_AUDIO_SINK@   6%-"
          "     , XF86AudioPrev,        exec, playerctl previous"
          "     , XF86AudioPlay,        exec, playerctl play-pause"
          "     , XF86AudioNext,        exec, playerctl next"

          # Radios management
          # https://github.com/dwlocks/scripts-tools-config/blob/master/etc/rfkill-toggle
          # TODO: extract shell script to its own rfkill-toggle executable
          '', XF86WLAN, exec, sh -c '[[ "$(< /sys/class/rfkill/rfkill0/state)" == "1" ]] && rfkill block all || rfkill unblock all' ''

          # Lid management
          '', switch:on:Lid Switch, exec, hyprctl keyword monitor "eDP-1, disable"''
          '', switch:off:Lid Switch, exec, hyprctl keyword monitor "eDP-1, preferred, auto, 1"''
        ];

        bindm = [
          # Move/resize windows with SUPER + LMB/RMB and dragging
          "SUPER, mouse:272, movewindow"
          "SUPER, mouse:273, resizewindow"
        ];

        # Smart gaps (old no_gaps_when_only)
        # https://wiki.hyprland.org/Configuring/Workspace-Rules/#smart-gaps
        workspace = [
          "w[tv1] s[false], gapsout:0,   gapsin:0"
          "f[1] s[false],   gapsout:0,   gapsin:0"
          "s[true],         gapsout:100, gapsin:50"

          "1,               defaultName:Doom,     on-created-empty: doom-emacs"
          "2,               defaultName:Chromium, on-created-empty:[float] chromium"
          "3,               defaultName:Chrome,   on-created-empty: google-chrome-stable"
          "4,               defaultName:Firefox,  on-created-empty: firefox"
          "special:special,                       on-created-empty: foot"
          "special:Telegram,                      on-created-empty: Telegram"
          "special:Transmission,                  on-created-empty: transmission-gtk"
        ];

        windowrulev2 = [
          "bordersize 0, floating:0, onworkspace:w[tv1] s[false]"
          "rounding 0,   floating:0, onworkspace:w[tv1] s[false]"
          "bordersize 0, floating:0, onworkspace:f[1] s[false]"
          "rounding 0,   floating:0, onworkspace:f[1] s[false]"

          "float,                                 class:^(org.telegram.desktop)$, title:^(Media viewer)$"
          "workspace special:Telegram silent,     class:^(org.telegram.desktop)$"
          "workspace special:Transmission silent, class:^(transmission-gtk)$, title:^(Transmission)$"
          "center,                                class:^(transmission-gtk)$, title:^(Torrent Options)$"

          "noanim 1,                              class:^(gcr-prompter)$"
          "xray 1,                                class:^(gcr-prompter)$"
          "dimaround 1,                           class:^(gcr-prompter)$"
          "stayfocused,                           class:^(gcr-prompter)$"
        ];

        layerrule = [
          "xray 1,    launcher"
          "dimaround, launcher"
          "xray 1,    wayprompt"
          "dimaround, wayprompt"
        ];
      };

      # TODO: migrate to native nix structure and be done with hardcoded paths
      # Explore toHyprconf
      # https://github.com/nix-community/home-manager/blob/af70fc502a15d7e1e4c5a4c4fc8e06c2ec561e0c/modules/lib/generators.nix#L4
      # to understand how to express the submap below as plain (nix) settings:
      extraConfig = ''

        # Resize submap
        bind = SUPER, R, submap, resize
        submap = resize
          bind  = SUPER  , R,      submap, reset
          bind  =        , Escape, submap, reset
          bind  =        , Return, submap, reset
          binde = CONTROL, L,      resizeactive,    1    0
          binde = CONTROL, H,      resizeactive,   -1    0
          binde = CONTROL, K,      resizeactive,    0   -1
          binde = CONTROL, J,      resizeactive,    0    1
          binde =        , L,      resizeactive,    8    0
          binde =        , H,      resizeactive,   -8    0
          binde =        , K,      resizeactive,    0   -8
          binde =        , J,      resizeactive,    0    8
          binde = SHIFT  , L,      resizeactive,  128    0
          binde = SHIFT  , H,      resizeactive, -128    0
          binde = SHIFT  , K,      resizeactive,    0 -128
          binde = SHIFT  , J,      resizeactive,    0  128
        submap = reset
      '';
    };
  };
}
