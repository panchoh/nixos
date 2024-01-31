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
    inherit (self.lib) boxen formatter nixosModules hmModules;
  in {
    lib = import ./modules/lib {inherit inputs;};

    inherit formatter;

    nixosModules.default = nixosModules;

    nixosConfigurations = builtins.listToAttrs (
      map (box: {
        name = box.hostName;
        value = nixpkgs.lib.nixosSystem {
          inherit (box) system;
          specialArgs =
            inputs
            // {inherit box hmModules;};
          modules = [
            box.hostType
            nixosModules
          ];
        };
      })
      boxen
    );
  };
}
