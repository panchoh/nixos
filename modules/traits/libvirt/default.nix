{
  config,
  lib,
  ...
}: let
  cfg = config.traits.libvirt;
in {
  options.traits.libvirt = {
    enable = lib.mkEnableOption "libvirt" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
  };
}
