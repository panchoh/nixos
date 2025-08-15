flake:
let
  inherit (flake.inputs.nixpkgs) legacyPackages;
  inherit (flake.inputs.nixpkgs.lib.attrsets) genAttrs;

  nixFmtTreeForSystem = system: legacyPackages.${system}.nixfmt-tree;

  nixfmt-tree = genAttrs flake.lib.systems nixFmtTreeForSystem;
in
nixfmt-tree
