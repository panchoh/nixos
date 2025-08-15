flake:
let
  inherit (flake.lib) systems;
  inherit (flake.inputs.nixpkgs.lib.attrsets) genAttrs;
  inherit (flake.inputs.nixpkgs) legacyPackages;

  nixFmtTreeForSystem = system: legacyPackages.${system}.nixfmt-tree;
in
genAttrs systems nixFmtTreeForSystem
