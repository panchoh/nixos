inputs:
let
  inherit (inputs.self.lib) boxen;
  inherit (builtins) catAttrs listToAttrs;
  inherit (inputs.nixpkgs.lib.lists) unique;
  inherit (inputs.nixpkgs.lib.attrsets) nameValuePair;
  inherit (inputs.nixpkgs) legacyPackages;
in
boxen
|> catAttrs "system"
|> unique
|> map (system: nameValuePair system legacyPackages.${system}.nixfmt-tree)
|> listToAttrs
