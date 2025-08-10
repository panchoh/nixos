{
  disko,
  box ? null,
  ...
}:
{
  imports = [
    disko.nixosModules.disko
    (import ./disk-config.nix { device = box.diskDevice or "/dev/vda"; })
  ];
}
