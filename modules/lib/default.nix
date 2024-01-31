inputs: {
  boxen = import ./boxen.nix inputs.nixos-hardware;

  fmt-alejandra = import ./fmt-alejandra.nix inputs;

  nixosModule = import ./module.nix {
    inherit (inputs.nixpkgs) lib;
    baseDir = ../traits;
  };

  hmModule = import ./module.nix {
    inherit (inputs.nixpkgs) lib;
    baseDir = ../traits;
    subDir = "hm";
  };
}
