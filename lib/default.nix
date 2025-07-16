inputs: {
  boxen = import ./boxen.nix inputs;

  nixfmt-tree = import ./nixfmt-tree.nix inputs;

  appsDiskoAndFunk = import ./apps-disko-and-funk.nix inputs;

  devShells = import ./dev-shells.nix inputs;

  nixosConfigurations = import ./configurations.nix inputs;
}
