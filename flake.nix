{
  description = "Nix is love.  Nix is life.  But Nix is also… snow.";

  nixConfig = {
    commit-lockfile-summary = "chore(flake): bump";

    extra-substituters = [
      "https://autofirma-nix.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "autofirma-nix.cachix.org-1:cDC9Dtee+HJ7QZcM8s36836scXyRToqNX/T+yvjiI0E="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";
    autofirma-nix.url = "github:nilp0inter/autofirma-nix";
    autofirma-nix.inputs.nixpkgs.follows = "nixpkgs";
    vmtools.url = "github:4km3/vmtools";
    vmtools.flake = false;
    kubelab.url = "github:4km3/kubelab";
    kubelab.flake = false;
  };

  outputs = {self, ...} @ inputs: {
    lib = import ./lib inputs // import ./modules/lib inputs;

    formatter = self.lib.fmtAlejandra;

    apps = self.lib.appsDiskoAndFunk;

    devShells = self.lib.devShells;

    homeModules.default = self.lib.homeModule;

    nixosModules.default = self.lib.nixosModule;

    nixosConfigurations = self.lib.nixosConfigurations;
  };
}
