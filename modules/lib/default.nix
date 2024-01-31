inputs: rec {
  boxen = import ./boxen.nix {
    inherit (inputs) nixos-hardware;
  };

  fmt-alejandra = import ./fmt-alejandra.nix {
    inherit (inputs) nixpkgs;
    inherit (inputs.nixpkgs) lib;
    inherit boxen;
  };

  nixosModule = import ./import-modules.nix {
    inherit (inputs.nixpkgs) lib;
    baseDir = ../traits;
  };

  hmModule = import ./import-modules.nix {
    inherit (inputs.nixpkgs) lib;
    baseDir = ../traits;
    subDir = "hm";
  };
}
