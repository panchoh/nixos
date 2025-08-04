inputs:
let
  inherit (inputs) nixpkgs;
  inherit (inputs.nixpkgs.lib) unique catAttrs;
  inherit (inputs.self.lib) boxen;
in
(builtins.listToAttrs (
  map (system: {
    name = system;
    value = nixpkgs.legacyPackages.${system}.nixfmt-tree;
  }) (unique (catAttrs "system" boxen))
))
