inputs:
let
  inherit (inputs.self.lib) boxen;
  inherit (builtins) catAttrs;
  inherit (inputs.nixpkgs.lib.lists) unique;
  inherit (inputs.nixpkgs.lib.trivial) flip;
  inherit (inputs.nixpkgs.lib.attrsets) genAttrs;
  inherit (inputs.nixpkgs) legacyPackages;

  systems = boxen |> catAttrs "system" |> unique;
in
systems |> flip genAttrs (system: legacyPackages.${system}.nixfmt-tree)
