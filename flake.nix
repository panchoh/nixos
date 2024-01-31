{
  description = "Nix is love.  Nix is life.  But Nix is also… snow.";

  nixConfig.commit-lockfile-summary = "chore(flake): bump";

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

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    makeBox = {
      hostName ? "nixos",
      hostType ? null,
      macvlanAddr,
      system ? "x86_64-linux",
      stateVersion ? "23.11",
      timeZone ? "Europe/Madrid",
      isLaptop ? false,
      userName ? "pancho",
      userDesc ? "pancho horrillo",
      userEmail ? "pancho@pancho.name",
    }: {
      inherit hostName hostType macvlanAddr system stateVersion timeZone isLaptop userName userDesc userEmail;
    };

    boxen = [
      (makeBox {
        hostName = "helium";
        macvlanAddr = "1c:69:7a:02:8d:23";
        hostType = inputs.nixos-hardware.nixosModules.intel-nuc-8i7beh;
      })
      (makeBox {
        hostName = "krypton";
        macvlanAddr = "1c:69:7a:06:76:c0";
        hostType = inputs.nixos-hardware.nixosModules.intel-nuc-8i7beh;
      })
      (makeBox {
        hostName = "magnesium";
        macvlanAddr = "00:2b:67:11:27:06";
        hostType = inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t490;
        isLaptop = true;
      })
      (makeBox {
        hostName = "neon";
        macvlanAddr = "dc:a6:32:b1:ae:1d";
        system = "aarch64-linux";
        hostType = inputs.nixos-hardware.nixosModules.raspberry-pi-4;
      })
    ];

    inherit (nixpkgs.lib) listToAttrs unique catAttrs;
  in {
    lib = {
      nixosModules = import ./lib/import-modules.nix {
        inherit (nixpkgs) lib;
        baseDir = ./modules/traits;
      };
      hmModules = import ./lib/import-modules.nix {
        inherit (nixpkgs) lib;
        baseDir = ./modules/traits;
        subDir = "hm";
      };
    };

    nixosModules.default = self.lib.nixosModules;

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
          specialArgs =
            inputs
            // {attrs = box;}
            // {inherit (self.lib) hmModules;};
          modules = [
            box.hostType
            self.nixosModules.default
          ];
        };
      })
      boxen
    );
  };
}
