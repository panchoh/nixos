{
  description = "Port of archify to NixOS + flakes + Home Manager.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
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
    home = {
      username = "${user}";
      homeDirectory = "/home/${user}";
      stateVersion = "22.11";
    };
    # hypr = {
    #   wayland.windowManager.hyprland.enable = true;
    #   wayland.windowManager.hyprland.extraConfig = ''
    #     bind = SUPER, Return, exec, foot
    #     # ...
    #     # *
    #     # **
    #     # ***
    #   '';
    # };
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

    # https://www.reddit.com/r/NixOS/comments/10zr4wl/nixos_home_manager_module_not_detected/
    nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
      # specialArgs = home;
      modules = [
        ./configuration.nix

        # https://github.com/NixOS/nixos-hardware#using-nix-flakes-support
        nixos-hardware.nixosModules.intel-nuc-8i7beh

        # https://github.com/nix-community/home-manager/issues/252
        # https://github.com/nix-community/home-manager/issues/1698
        # https://discourse.nixos.org/t/nixos-flakes-with-home-manager/18476
        home-manager.nixosModules.home-manager
        {
          home-manager.verbose = true;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = {...}: {
            inherit home;
            imports = [
              ./home.nix
              hyprland.homeManagerModules.default
              # hypr
            ];
          };
          #home-manager.extraSpecialArgs = { inherit home; };
          #home-manager.extraSpecialArgs = { home-manager.users.${user} = home; };
        }

        hyprland.nixosModules.default
        {
          programs.hyprland.enable = true;
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
        {inherit home;}
        ./home.nix
        hyprland.homeManagerModules.default
        # hypr
      ];
    };
  };
}
