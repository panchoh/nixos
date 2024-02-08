inputs: {
  boxen = import ./boxen.nix inputs;

  fmt-alejandra = import ./fmt-alejandra.nix inputs;

  apps-disko-and-funk = import ./apps-disko-and-funk.nix inputs;

  nixosConfigurations = import ./configurations.nix inputs;
}
