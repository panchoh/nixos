{
  config,
  pkgs,
  ...
}: {
  home.username = "pancho";
  home.homeDirectory = "/home/pancho";

  home.stateVersion = "22.11";

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Iosevka Nerd Font Mono:weight=Light:size=16";
        font-bold = "Iosevka Nerd Font Mono:weight=Regular:size=16";
        dpi-aware = false;
      };
      mouse = {
        hide-when-typing = true;
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
  programs.home-manager.enable = true;
}
