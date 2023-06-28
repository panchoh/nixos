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
    hyprland.url = "github:hyprwm/Hyprland/7ed66abe57c493379721997224332379f6e18a9a";
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
    makeBox = {
      hostName,
      macvlanAddr,
      system,
    }: {
      userName = "pancho";
      userDesc = "pancho horrillo";
      userEmail = "pancho@pancho.name";
      inherit hostName macvlanAddr system;
    };

    boxen = [
      (makeBox
        {
          hostName = "helium";
          macvlanAddr = "1c:69:7a:02:8d:23";
          system = "x86_64-linux";
        })
      (makeBox
        {
          hostName = "krypton";
          macvlanAddr = "1c:69:7a:05:b5:98";
          system = "x86_64-linux";
        })
      (makeBox
        {
          hostName = "neon";
          macvlanAddr = "dc:a6:32:b1:ae:1d";
          system = "aarch64-linux";
        })
    ];
  in {
    formatter = builtins.listToAttrs (map (box: {
        name = box.system;
        value = nixpkgs.legacyPackages.${box.system}.alejandra;
      })
      boxen);

    nixosConfigurations = builtins.listToAttrs (
      map (box: {
        name = box.hostName;
        value = nixpkgs.lib.nixosSystem {
          system = box.system;
          specialArgs = {
            attrs = box;
            inherit nixpkgs nixos-hardware disko stylix hyprland home-manager;
          };
          modules = [./configuration.nix];
        };
      })
      boxen
    );
  };
}
