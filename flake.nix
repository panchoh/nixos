{
  description = "Port of archify to NixOS + flakes + Home Manager.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
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
    user = "pancho";
    host = "helium";
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
      modules = [
        nixos-hardware.nixosModules.intel-nuc-8i7beh
        disko.nixosModules.disko
        ./disko-config.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.verbose = true;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = {...}: {
            imports = [
              # stylix.nixosModules.stylix
              stylix.homeManagerModules.stylix
              hyprland.homeManagerModules.default
              ./home.nix
            ];
          };
        }
        stylix.nixosModules.stylix
        hyprland.nixosModules.default
        ./configuration.nix
      ];
    };

    homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        stylix.homeManagerModules.stylix
        hyprland.homeManagerModules.default
        ./home.nix
      ];
    };
  };
}
