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
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";
    autofirma-nix.url = "github:nilp0inter/autofirma-nix";
    autofirma-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {self, ...} @ inputs: {
    lib = import ./lib inputs // import ./modules/lib inputs;

    formatter = self.lib.fmtAlejandra;

    apps = self.lib.appsDiskoAndFunk;

    nixosModules.default = self.lib.nixosModule;

    nixosConfigurations = self.lib.nixosConfigurations;
  };
}
