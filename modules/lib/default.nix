inputs: {
  nixosModule = import ./module.nix inputs null;

  hmModule = import ./module.nix inputs "hm";
}
