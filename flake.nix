{
  description = "Port of archify to NixOS + flakes + Home Manager.";

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
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    disko,
    home-manager,
    stylix,
    hyprland,
  } @ inputs: let
    system = "x86_64-linux";
    attrs = {
      userName = "pancho";
      userDesc = "pancho horrillo";
      userEmail = "pancho@pancho.name";
      hostName = "helium";
    };
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

    nixosConfigurations.${attrs.hostName} = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit nixpkgs hyprland attrs;};
      modules = [
        nixos-hardware.nixosModules.intel-nuc-8i7beh
        disko.nixosModules.disko
        ./disko-config.nix
        stylix.nixosModules.stylix
        hyprland.nixosModules.default
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            verbose = true;
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {inherit attrs;};
            users.${attrs.userName} = {...}: {
              imports = [
                stylix.homeManagerModules.stylix
                hyprland.homeManagerModules.default
                ./home.nix
              ];
            };
          };
        }
      ];
    };
  };
}
