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
    makeHost = {
      hostName,
      macvlanAddress,
      system,
    }: {
      userName = "pancho";
      userDesc = "pancho horrillo";
      userEmail = "pancho@pancho.name";
      inherit hostName macvlanAddress system;
    };

    hosts = [
      (makeHost
        {
          hostName = "helium";
          macvlanAddress = "1c:69:7a:02:8d:23";
          system = "x86_64-linux";
        })
      (makeHost
        {
          hostName = "krypton";
          macvlanAddress = "1c:69:7a:05:b5:98";
          system = "x86_64-linux";
        })
      (makeHost
        {
          hostName = "neon";
          macvlanAddress = "dc:a6:32:b1:ae:1d";
          system = "aarch64-linux";
        })
    ];
  in {
    formatter = builtins.listToAttrs (map (host: {
        name = host.system;
        value = nixpkgs.legacyPackages.${host.system}.alejandra;
      })
      hosts);

    nixosConfigurations = builtins.listToAttrs (
      map (host: {
        name = host.hostName;
        value = nixpkgs.lib.nixosSystem {
          system = host.system;
          specialArgs = {
            attrs = host;
            inherit nixpkgs nixos-hardware disko stylix hyprland home-manager;
          };
          modules = [./configuration.nix];
        };
      })
      hosts
    );
  };
}
