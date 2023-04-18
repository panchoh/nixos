{
  description = "Port of archify to NixOS + flakes + Home Manager.";

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
  } @ inputs: let
    user = "pancho";
    host = "helium";
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

    nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        # https://github.com/NixOS/nixos-hardware#using-nix-flakes-support
        nixos-hardware.nixosModules.intel-nuc-8i7beh
        home-manager.nixosModules.home-manager
        {
          home-manager.useUserPackages = true;
          home-manager.useGlobalPkgs = true;
          home-manager.users.${user} = import ./home.nix;
        }
      ];
    };

    # https://nix-community.github.io/home-manager/index.html#ch-installation
    # https://wiki.hyprland.org/hyprland-wiki/pages/Nix/Hyprland-on-Home-Manager/
    # https://github.com/hyprwm/Hyprland/blob/main/nix/hm-module.nix
    # https://nix-community.github.io/home-manager/release-notes.html#sec-release-22.11-highlights
    homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./home.nix
        #{
        #  home = {
        #    username = "pancho";
        #    homeDirectory = "/home/pancho";
        #    stateVersion = "22.11";
        #  };
        #}
        hyprland.homeManagerModules.default
        {
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
