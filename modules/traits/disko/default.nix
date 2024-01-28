{disko, ...}: {
  imports = [
    disko.nixosModules.default
    ./disko-config.nix
  ];
}
