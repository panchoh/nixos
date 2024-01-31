  boxen = import ./boxen.nix {
    inherit (inputs) nixos-hardware;
  };
inputs: {

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
