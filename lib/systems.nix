flake:
let
  inherit (flake.inputs.nixpkgs.lib.lists) unique;

  systems = flake.lib.boxen |> builtins.catAttrs "system" |> unique;
in
systems
