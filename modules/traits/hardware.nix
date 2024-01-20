{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.hardware;
in {
  options.traits.hardware.enable = lib.mkEnableOption "hardware";

  config.hardware = lib.mkIf cfg.enable {
    keyboard.qmk.enable = true;

    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };

    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        # https://nixos.wiki/wiki/Accelerated_Video_Playback
        intel-ocl
        intel-compute-runtime
        intel-media-driver
        intel-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };
}
