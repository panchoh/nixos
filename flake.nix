{
  description = "Nix is love.  Nix is life.  Nix is also… snow.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";
    autofirma-nix.url = "github:nilp0inter/autofirma-nix";
    autofirma-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {nixpkgs, ...} @ inputs: let
    makeBox = {
      hostName,
      macvlanAddr,
      system,
      stateVersion ? "23.11",
      isLaptop ? false,
    }: {
      inherit hostName macvlanAddr system stateVersion isLaptop;
      userName = "pancho";
      userDesc = "pancho horrillo";
      userEmail = "pancho@pancho.name";
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
          macvlanAddr = "1c:69:7a:06:76:c0";
          system = "x86_64-linux";
        })
      (makeBox
        {
          hostName = "neon";
          macvlanAddr = "dc:a6:32:b1:ae:1d";
          system = "aarch64-linux";
          stateVersion = "23.05";
        })
      (makeBox
        {
          hostName = "magnesium";
          macvlanAddr = "00:2b:67:11:27:06";
          system = "x86_64-linux";
          isLaptop = true;
        })
    ];

    inherit (nixpkgs.lib) listToAttrs unique catAttrs;
  in {
    formatter = (
      listToAttrs (map (system: {
          name = system;
          value = nixpkgs.legacyPackages.${system}.alejandra;
        })
        (unique (catAttrs "system" boxen)))
    );

    nixosConfigurations = builtins.listToAttrs (
      map (box: {
        name = box.hostName;
        value = nixpkgs.lib.nixosSystem {
          inherit (box) system;
          specialArgs = inputs // {attrs = box;};
          modules = [./configuration.nix];
        };
      })
      boxen
    );
  };
}
