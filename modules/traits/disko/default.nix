{
  disko,
  box ? null,
  ...
}: {
  imports = [
    disko.nixosModules.default
    (import ./disko-config.nix {device = box.diskDevice or "/dev/vda";})
  ];
}
