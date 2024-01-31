{
  nixpkgs,
  lib,
  boxen,
}: let
  inherit (lib) listToAttrs unique catAttrs;
in (
  listToAttrs (map (system: {
      name = system;
      value = nixpkgs.legacyPackages.${system}.alejandra;
    })
    (unique (catAttrs "system" boxen)))
)
