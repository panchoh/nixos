flake:
let
  inherit (flake.lib) boxen;
  inherit (builtins) catAttrs;
  inherit (flake.inputs.nixpkgs.lib.lists) unique;

  systems = boxen |> catAttrs "system" |> unique;
in
systems
