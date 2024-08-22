{
  config,
  lib,
  pkgs,
  osConfig,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.hyprland;

  foot = lib.getExe config.programs.foot.package;
  hyprctl = lib.getExe' config.wayland.windowManager.hyprland.package "hyprctl";
  emacs = lib.getExe config.programs.emacs.finalPackage;
  emacsclient = lib.getExe' config.programs.emacs.finalPackage "emacsclient";
  fuzzel = lib.getExe pkgs.fuzzel;
  makoctl = lib.getExe' pkgs.mako "makoctl";
in {
  options.traits.hm.hyprland = {
    enable = lib.mkEnableOption "hyprland" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    services.hyprpaper.enable = lib.mkForce false;
    services.hypridle = {
      enable = true;
      settings = {
        listener = [
          {
            timeout = 300;
            on-timeout = "${hyprctl} dispatch dpms off";
            on-resume = "${hyprctl} dispatch dpms on";
          }
        ];
      };
    };

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

    wayland.windowManager.hyprland = {
      enable = true;
      package = osConfig.programs.hyprland.package;
      xwayland.enable = osConfig.programs.hyprland.xwayland.enable;
      importantPrefixes = [
        "bezier"
        "name"
        "source"
      ];
      settings = {
        # CAVEAT EMPTOR: Google Meet does not support 10-bit depth, colors of shared windows will be off
        monitor = [
          "desc:Dell Inc. DELL U3818DW 5KC0386E05KL, preferred, auto, auto, bitdepth, 10"
        ];

        exec-once = [
          "${foot}"
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
        # AltGr-Space: non-breakable space
        # Shift-AltGr: compose
        # Caps: Ye'Olde Caps
        # Alt-Caps: group switch
        #
        # TODO: reply here that grp:alt_caps_toggle does the job
        # https://unix.stackexchange.com/questions/589075/using-both-ctrlswapcaps-and-grpcaps-toggle-with-setxkbmap

        device = map (overrides:
          {
            name = "unnamed-keyboard";
            kb_model = "pc104";
            kb_layout = "us,us";
            kb_variant = "altgr-intl,dvorak-alt-intl";
            kb_options = "lv3:ralt_switch_multikey,grp:alt_caps_toggle,nbsp:level3n,terminate:ctrl_alt_bksp";
          }
          // overrides) [
          {
            name = "keychron-keychron-q10";
          }

          {
            name = "keychron-keychron-q8";
          }

          {
            name = "PFU_Limited_HHKB-Classic";
            kb_model = "hhk";
          }

          {
            name = "at-translated-set-2-keyboard";
            kb_model = "thinkpad";
            kb_options = "lv3:ralt_switch_multikey,grp:alt_caps_toggle,nbsp:level3n,terminate:ctrl_alt_bksp";
          }

          {
            name = "logitech-k400-plus";
            kb_options = "lv3:ralt_switch_multikey,ctrl:swapcaps,grp:alt_caps_toggle,nbsp:level3n,terminate:ctrl_alt_bksp";
          }
        ];

        cursor = {
          inactive_timeout = 5;
          hide_on_key_press = true;
        };

        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          "col.active_border" = lib.mkForce "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = lib.mkForce "rgba(595959aa)";

          layout = "master";

          resize_on_border = true;
          hover_icon_on_border = true;
        };

        decoration = {
          rounding = 5;
          # blur = true;
          # blur_size = 3;
          # blur_passes = 1;
          # blur_new_optimizations = true;

          # drop_shadow = true;
          # shadow_range = 4;
          # shadow_render_power = 3;
          # "col.shadow" = "rgba(1a1a1aee)";
        };

        animations = {
          enabled = false;
        };

        master = {
          mfact = 0.66;
          new_status = "inherit";
          new_on_active = "before";
          new_on_top = true;
          no_gaps_when_only = true;
          orientation = "right";
          # orientation = "center";
          special_scale_factor = 0.98;
        };

        gestures = {
          workspace_swipe = false;
        };

        # https://www.reddit.com/r/hyprland/comments/zoeqoz/anyway_to_remove_the_hyprland_startup_logo/
        # https://github.com/hyprwm/Hyprland/issues/3073
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          focus_on_activate = true;
        };

        # https://github.com/hyprwm/Hyprland/pull/352/files
        binds = {
          workspace_back_and_forth = false;
          allow_workspace_cycles = true;
        };

        bind = [
          "SUPER      , Return, exec, ${foot}"
          "SUPER      , X     , exec, ${emacs}"
          "SUPER SHIFT, X     , exec, ${emacsclient} --no-wait --reuse-frame"
          "SUPER      , Slash , exec, chromium"
          "SUPER SHIFT, Slash , exec, google-chrome-stable"

          # TODO: debug why the Terminate_Server symbol is not honored
          # ", Terminate_Server, exit,"
          # ", terminate_server, exit,"
          "CONTROL ALT, BackSpace, exit,"

          "SUPER SHIFT, Q, killactive,"

          "SUPER SHIFT, Return, layoutmsg, swapwithmaster master"
          "SUPER,       M,      layoutmsg, focusmaster auto"
          "SUPER,       SPACE,  focusurgentorlast,"
          "SUPER SHIFT, SPACE,  togglefloating,"

          "SUPER,       TAB, layoutmsg, cyclenext"
          "SUPER SHIFT, TAB, layoutmsg, cycleprev"

          "SUPER, H, movefocus, l"
          "SUPER, L, movefocus, r"
          "SUPER, K, movefocus, u"
          "SUPER, J, movefocus, d"

          "SUPER SHIFT, H, layoutmsg, removemaster"
          "SUPER SHIFT, L, layoutmsg, addmaster"
          "SUPER SHIFT, K, layoutmsg, swapprev"
          "SUPER SHIFT, J, layoutmsg, swapnext"

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
          "SUPER, right,      workspace, e+1"
          "SUPER, left,       workspace, e-1"
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
          "SUPER SHIFT, Minus, movetoworkspace,        special:s1"
          "SUPER,       Minus, togglespecialworkspace,         s1"
          "SUPER SHIFT, Equal, movetoworkspace,        special:s2"
          "SUPER,       Equal, togglespecialworkspace,         s2"

          "SUPER,       F, fullscreen"
          "SUPER ALT,   F, fullscreenstate, 1, 1" # TODO: when 0.43 arrives, replace with "maximize"
          "SUPER SHIFT, F, fullscreenstate, 0, 2"

          # Start fuzzel opens fuzzel on first press, closes it on second
          # bindr = SUPER, SUPER_L, exec, pkill fuzzel || fuzzel
          "SUPER, D, exec, ${fuzzel}"

          # Handle notifications
          "SUPER,       N, exec, ${makoctl} dismiss"
          "SUPER SHIFT, N, exec, ${makoctl} dismiss -a"

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
          "     , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@   4%+"
          "     , XF86AudioLowerVolume, exec, wpctl set-volume      @DEFAULT_AUDIO_SINK@   4%-"
          "SHIFT, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@   1%+"
          "SHIFT, XF86AudioLowerVolume, exec, wpctl set-volume      @DEFAULT_AUDIO_SINK@   1%-"
          "     , XF86AudioPrev,        exec, playerctl previous"
          "     , XF86AudioPlay,        exec, playerctl play-pause"
          "     , XF86AudioNext,        exec, playerctl next"

          # Radios management
          # https://github.com/dwlocks/scripts-tools-config/blob/master/etc/rfkill-toggle
          # TODO: extract shell script to its own rfkill-toggle executable
          '', XF86WLAN, exec, sh -c '[[ "$(< /sys/class/rfkill/rfkill0/state)" == "1" ]] && rfkill block all || rfkill unblock all' ''
        ];

        bindm = [
          # Move/resize windows with SUPER + LMB/RMB and dragging
          "SUPER, mouse:272, movewindow"
          "SUPER, mouse:273, resizewindow"
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
          bind  = SUPER, R,      submap, reset
          bind  =      , Escape, submap, reset
          bind  =      , Return, submap, reset
          binde =      , L,      resizeactive,    5    0
          binde =      , H,      resizeactive,   -5    0
          binde =      , K,      resizeactive,    0   -5
          binde =      , J,      resizeactive,    0    5
          binde = SHIFT, L,      resizeactive,  100    0
          binde = SHIFT, H,      resizeactive, -100    0
          binde = SHIFT, K,      resizeactive,    0 -100
          binde = SHIFT, J,      resizeactive,    0  100
        submap = reset
      '';
    };
  };
}
