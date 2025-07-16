inputs:
let
  inherit (inputs) nixpkgs;
  inherit (inputs.nixpkgs.lib) listToAttrs unique catAttrs;
  inherit (inputs.self.lib) boxen;
in
(listToAttrs (
  map (system: {
    name = system;
    value = nixpkgs.legacyPackages.${system}.nixfmt-tree;
  }) (unique (catAttrs "system" boxen))
))
