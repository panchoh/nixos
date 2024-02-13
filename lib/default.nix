inputs: {
  flakeInputsClosure = import ./collect-flake-inputs.nix inputs.self;

  boxen = import ./boxen.nix inputs;

  fmtAlejandra = import ./fmt-alejandra.nix inputs;

  appsDiskoAndFunk = import ./apps-disko-and-funk.nix inputs;

  nixosConfigurations = import ./configurations.nix inputs;
}
