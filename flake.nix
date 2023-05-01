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
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
    # emacs-overlay.inputs.flake-utils.follows = "flake-utils";
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
    emacs-overlay,
  } @ inputs: let
    user = "pancho";
    host = "helium";
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [emacs-overlay.overlay];
      config = {allowUnfree = true;};
    };
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
        nixos-hardware.nixosModules.intel-nuc-8i7beh
        disko.nixosModules.disko
        ./disko-config.nix
        stylix.nixosModules.stylix
        hyprland.nixosModules.default
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = [emacs-overlay.overlay];
          programs = {
            hyprland.enable = true;
            command-not-found.enable = false;
          };
          home-manager = {
            verbose = true;
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${user} = {...}: {imports = hm-modules;};
          };
        }
      ];
    };
  };
}
