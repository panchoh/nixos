inputs:
let
  inherit (inputs.self.lib) boxen;
  inherit (builtins) catAttrs;
  inherit (inputs.nixpkgs.lib.lists) unique;
  inherit (inputs.nixpkgs.lib.trivial) flip;
  inherit (inputs.nixpkgs.lib.attrsets) genAttrs;
  inherit (inputs.nixpkgs) legacyPackages;
in
boxen |> catAttrs "system" |> unique |> flip genAttrs (system: legacyPackages.${system}.nixfmt-tree)
