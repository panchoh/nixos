{
  description = "Nix is love.  Nix is life.  But Nix is also… snow.";

  nixConfig.commit-lockfile-summary = "chore(flake): bump";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";
    autofirma-nix.url = "github:nilp0inter/autofirma-nix";
    autofirma-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) listToAttrs unique catAttrs;
    inherit (self.lib) boxen;
  in {
    lib = {
      nixosModules = import ./lib/import-modules.nix {
        inherit (nixpkgs) lib;
        baseDir = ./modules/traits;
      };
      hmModules = import ./lib/import-modules.nix {
        inherit (nixpkgs) lib;
        baseDir = ./modules/traits;
        subDir = "hm";
      };
      boxen = import ./lib/boxen.nix {inherit (inputs) nixos-hardware;};
    };

    nixosModules.default = self.lib.nixosModules;

    formatter = (
      listToAttrs (map (system: {
          name = system;
          value = nixpkgs.legacyPackages.${system}.alejandra;
        })
        (unique (catAttrs "system" boxen)))
    );

    nixosConfigurations = builtins.listToAttrs (
      map (box: {
        name = box.hostName;
        value = nixpkgs.lib.nixosSystem {
          inherit (box) system;
          specialArgs =
            inputs
            // {attrs = box;}
            // {inherit (self.lib) hmModules;};
          modules = [
            box.hostType
            self.nixosModules.default
          ];
        };
      })
      boxen
    );
  };
}
