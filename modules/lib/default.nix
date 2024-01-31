inputs: rec {
  boxen = import ./boxen.nix {
    inherit (inputs) nixos-hardware;
  };

  fmt-alejandra = import ./fmt-alejandra.nix {
    inherit (inputs) nixpkgs;
    inherit (inputs.nixpkgs) lib;
    inherit boxen;
  };

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
