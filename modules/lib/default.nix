{inputs}: rec {
  boxen = import ./boxen.nix {
    inherit (inputs) nixos-hardware;
  };

  fmt-alejandra = import ./fmt-alejandra.nix {
    inherit (inputs) nixpkgs;
    inherit (inputs.nixpkgs) lib;
    inherit boxen;
  };

  nixosModules = import ./import-modules.nix {
    inherit (inputs.nixpkgs) lib;
    baseDir = ../traits;
  };

  hmModules = import ./import-modules.nix {
    inherit (inputs.nixpkgs) lib;
    baseDir = ../traits;
    subDir = "hm";
  };
}
