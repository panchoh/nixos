{
  disko,
  box ? null,
  ...
}:
{
  imports = [
    disko.nixosModules.default
    (import ./disk-config.nix { device = box.diskDevice or "/dev/vda"; })
  ];
}
