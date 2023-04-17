{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  outputs = { self, nixpkgs, nixos-hardware }:
    let
      system = "x86_64-linux";
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
      nixosConfigurations.helium = nixpkgs.lib.nixosSystem {
        modules = [
          nixos-hardware.nixosModules.intel-nuc-8i7beh
          ./configuration.nix
        ];
      };
    };
}
