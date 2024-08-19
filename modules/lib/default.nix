inputs: {
  nixosModule = import ./module.nix inputs "os";

  hmModule = import ./module.nix inputs "hm";
}
