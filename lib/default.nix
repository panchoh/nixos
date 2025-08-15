flake: {
  boxen = import ./boxen.nix flake;

  systems = import ./systems.nix flake;

  nixfmt-tree = import ./nixfmt-tree.nix flake;

  appsDiskoAndFunk = import ./apps-disko-and-funk.nix flake;

  devShells = import ./dev-shells.nix flake;

  nixosConfigurations = import ./configurations.nix flake;
}
