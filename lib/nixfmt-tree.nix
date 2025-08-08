inputs:
let
  inherit (inputs.self.lib) systems;
  inherit (inputs.nixpkgs.lib.attrsets) genAttrs;
  inherit (inputs.nixpkgs) legacyPackages;

  nixFmtTreeForSystem = system: legacyPackages.${system}.nixfmt-tree;
in
genAttrs systems nixFmtTreeForSystem
