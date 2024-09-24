inputs: {
  nixosModule = import ./module.nix inputs "os";

  homeModule = import ./module.nix inputs "hm";
}
