inputs:
let
  inherit (inputs.self.lib) boxen;
  inherit (inputs.self) nixosModules homeModules;
  inherit (inputs.nixpkgs.lib.attrsets) nameValuePair;
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (builtins) listToAttrs;

  mkSystem =
    box:
    nameValuePair box.hostName (nixosSystem {
      inherit (box) system;
      modules = [ nixosModules.default ] ++ box.extraModules;
      specialArgs = inputs // {
        inherit box boxen;
        home.imports = [ homeModules.default ] ++ box.extraHomeModules;
        extraSpecialArgs = inputs // {
          inherit box boxen;
        };
      };
    });
in
boxen |> map mkSystem |> listToAttrs
