flake:
let
  inherit (flake.inputs.nixpkgs.lib.attrsets) nameValuePair;
  inherit (flake.inputs.nixpkgs.lib) nixosSystem;

  mkSystem =
    box:
    nameValuePair box.hostName (nixosSystem {
      inherit (box) system;
      modules = [ flake.nixosModules.default ] ++ box.extraModules;
      specialArgs = flake.inputs // {
        inherit box;
        inherit (flake.lib) boxen;
        home.imports = [ flake.homeModules.default ] ++ box.extraHomeModules;
        extraSpecialArgs = flake.inputs // {
          inherit box;
          inherit (flake.lib) boxen;
        };
      };
    });

  configurations = flake.lib.boxen |> map mkSystem |> builtins.listToAttrs;
in
configurations
