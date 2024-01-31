inputs: {
  boxen = import ./boxen.nix inputs.nixos-hardware;

  fmt-alejandra = import ./fmt-alejandra.nix inputs;

  nixosModule = import ./module.nix inputs null;

  hmModule = import ./module.nix inputs "hm";
}
