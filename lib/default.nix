inputs: {
  flakeInputsClosure = import ./collect-flake-inputs.nix inputs.self;

  extraSpecialArgs = import ./extra-special-args.nix inputs;

  boxen = import ./boxen.nix inputs;

  fmtAlejandra = import ./fmt-alejandra.nix inputs;

  appsDiskoAndFunk = import ./apps-disko-and-funk.nix inputs;

  devShells = import ./dev-shells.nix inputs;

  nixosConfigurations = import ./configurations.nix inputs;
}
