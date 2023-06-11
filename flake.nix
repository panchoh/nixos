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
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

    nixosConfigurations = builtins.listToAttrs (
      map (attrs: {
        name = attrs.hostName;
        value = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit nixpkgs nixos-hardware disko stylix hyprland attrs;};
          modules = [
            hyprland.nixosModules.default
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                verbose = true;
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {inherit stylix attrs;};
                users.${attrs.userName} = {...}: {
                  imports = [
                    hyprland.homeManagerModules.default
                    ./home.nix
                  ];
                };
              };
            }
          ];
        };
      }) (
        let
          commonAttrs = {
            userName = "pancho";
            userDesc = "pancho horrillo";
            userEmail = "pancho@pancho.name";
          };
        in [
          (commonAttrs
            // {
              hostName = "helium";
              macvlanAddress = "1c:69:7a:02:8d:23";
            })
          (commonAttrs
            // {
              hostName = "krypton";
              macvlanAddress = "1c:69:7a:05:b5:98";
            })
        ]
      )
    );
  };
}
