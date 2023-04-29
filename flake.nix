{
  description = "Port of archify to NixOS + flakes + Home Manager.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
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
    nix-index-database,
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
    hm-modules = [
      nix-index-database.hmModules.nix-index
      stylix.homeManagerModules.stylix
      hyprland.homeManagerModules.default
      {programs.nix-index.enable = true;}
      ./home.nix
    ];
  in {
    formatter.${system} = pkgs.alejandra;

    homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = hm-modules;
    };

    nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit nixpkgs;};
      modules = [
        nix-index-database.nixosModules.nix-index
        nixos-hardware.nixosModules.intel-nuc-8i7beh
        disko.nixosModules.disko
        ./disko-config.nix
        stylix.nixosModules.stylix
        hyprland.nixosModules.default
        {programs.hyprland.enable = true;}
        ./configuration.nix
        {programs.command-not-found.enable = false;}
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            verbose = true;
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${user} = {...}: {
              imports = hm-modules;
            };
          };
        }
      ];
    };
  };
}
