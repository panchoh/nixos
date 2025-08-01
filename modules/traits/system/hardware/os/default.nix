{
  config,
  lib,
  pkgs,
  modulesPath,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.hardware;
in
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ]
    ++ lib.optionals (box.hostName == "nixos") [
      (modulesPath + "/profiles/qemu-guest.nix")
    ];

  options.traits.os.hardware = {
    enable = lib.mkEnableOption "hardware" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      initrd = {
        availableKernelModules = [
          "xhci_pci"
          "ahci"
          "nvme"
          "sd_mod"
        ];
        kernelModules = [ ];
      };
      kernelModules = [ "kvm-intel" ];
      extraModulePackages = [ ];
    };

    nixpkgs.hostPlatform = lib.mkDefault box.system or "x86_64-linux";

    hardware = {
      cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

      logitech.wireless = {
        enable = true;
        enableGraphical = true;
      };

      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          # https://wiki.nixos.org/wiki/Intel_Graphics
          vpl-gpu-rt
          # https://nixos.wiki/wiki/Accelerated_Video_Playback
          intel-ocl
          intel-compute-runtime
          intel-media-driver
          libva-vdpau-driver
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
