inputs:
let
  inherit (inputs.self.lib) boxen;
  inherit (builtins) catAttrs;
  inherit (inputs.nixpkgs.lib.lists) unique;

  systems = boxen |> catAttrs "system" |> unique;
in
systems
