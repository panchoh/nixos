inputs: {
  boxen = import ./boxen.nix inputs.nixos-hardware;

  fmt-alejandra = import ./fmt-alejandra.nix inputs;
}
