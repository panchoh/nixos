flake: {
  boxen = import ./boxen.nix flake;

  systems = import ./systems.nix flake;
}
