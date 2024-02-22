{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.hardware;
in {
  options.traits.hardware = {
    enable = lib.mkEnableOption "hardware" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    hardware = {
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

    security.wrappers.intel_gpu_top = {
      source = lib.getExe' pkgs.intel-gpu-tools "intel_gpu_top";
      owner = "root";
      group = "root";
      capabilities = "cap_perfmon+ep";
    };
  };
}
