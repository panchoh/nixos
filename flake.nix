{
  description = "Port of archify to NixOS + flakes + Home Manager.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    disko,
    home-manager,
    hyprland,
    stylix,
  } @ inputs: let
    user = "pancho";
    host = "helium";
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    home = {
      username = "${user}";
      homeDirectory = "/home/${user}";
      stateVersion = "22.11";
    };
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

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
            inherit home;
            imports = [
              hyprland.homeManagerModules.default
              stylix.nixosModules.stylix
              ./home.nix
            ];
          };
        }

        hyprland.nixosModules.default
        {
          programs.hyprland.enable = true;
        }
        stylix.nixosModules.stylix
        ./configuration.nix
      ];
    };

    homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        {inherit home;}
        ./home.nix
        hyprland.homeManagerModules.default
      ];
    };
  };
}
