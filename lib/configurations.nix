flake:
let
  inherit (flake.lib) boxen;
  inherit (flake) nixosModules homeModules;
  inherit (flake.inputs.nixpkgs.lib.attrsets) nameValuePair;
  inherit (flake.inputs.nixpkgs.lib) nixosSystem;
  inherit (builtins) listToAttrs;

  mkSystem =
    box:
    nameValuePair box.hostName (nixosSystem {
      inherit (box) system;
      modules = [ nixosModules.default ] ++ box.extraModules;
      specialArgs = flake.inputs // {
        inherit box boxen;
        home.imports = [ homeModules.default ] ++ box.extraHomeModules;
        extraSpecialArgs = flake.inputs // {
          inherit box boxen;
        };
      };
    });
in
boxen |> map mkSystem |> listToAttrs
