{
  config,
  lib,
  modulesPath,
  attrs ? null,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  config = {
    boot = {
      initrd = {
        availableKernelModules = ["xhci_pci" "ahci" "nvme" "sd_mod"];
        kernelModules = [];
      };
      kernelModules = ["kvm-intel"];
      extraModulePackages = [];
    };

    nixpkgs.hostPlatform = lib.mkDefault attrs.system or "x86_64-linux";

    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
