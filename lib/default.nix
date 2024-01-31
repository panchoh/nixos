{inputs}: {
  boxen = import ./boxen.nix {
    inherit (inputs) nixos-hardware;
  };

  nixosModules = import ./import-modules.nix {
    inherit (inputs.nixpkgs) lib;
    baseDir = ../modules/traits;
  };

  hmModules = import ./import-modules.nix {
    inherit (inputs.nixpkgs) lib;
    baseDir = ../modules/traits;
    subDir = "hm";
  };
}
