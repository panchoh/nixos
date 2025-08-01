{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.mpv;
in
{
  options.traits.hm.mpv = {
    enable = lib.mkEnableOption "mpv" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.playerctl ];

    services.playerctld.enable = true;

    programs.mangohud.enable = true;

    programs.mpv = {
      enable = true;
      scripts = [ pkgs.mpvScripts.mpris ];
      bindings = {
        ENTER = "playlist-next force";
        WHEEL_UP = "seek 10";
        WHEEL_DOWN = "seek -10";
        "Alt+0" = "set window-scale 0.5";
      };
      defaultProfiles = [ "gpu-hq" ];
      config = {
        fullscreen = true;
        sub-auto = "fuzzy";

        vo = "gpu-next";
        gpu-api = "vulkan";
        gpu-context = "waylandvk";

        # https://github.com/mpv-player/mpv/issues/8981
        hdr-compute-peak = false;

        # https://github.com/mpv-player/mpv/issues/10972#issuecomment-1340100762
        vd-lavc-dr = false;

        drm-vrr-enabled = "auto";
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
  };
}
