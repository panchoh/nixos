{
  description = "Port of archify to NixOS + flakes +Home Manager.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {
    self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      hyprland,
  }: let
    user = "pancho";
    host = "helium";
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

    nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
      modules = [
        nixos-hardware.nixosModules.intel-nuc-8i7beh
        ./configuration.nix
        home-manager.nixosModules.home-manager
      ];
    };

    # https://nix-community.github.io/home-manager/index.html#ch-installation
    # https://wiki.hyprland.org/hyprland-wiki/pages/Nix/Hyprland-on-Home-Manager/
    # https://github.com/hyprwm/Hyprland/blob/main/nix/hm-module.nix
    homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./home.nix
        hyprland.homeManagerModules.default {
          wayland.windowManager.hyprland.enable = true;
          wayland.windowManager.hyprland.extraConfig = ''
            bind = SUPER, Return, exec, foot
            # ...
          '';
        }
        # ...
      ];
    };
  };
}
