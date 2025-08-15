flake: {
  nixosModule = import ./module.nix flake "os";

  homeModule = import ./module.nix flake "hm";
}
