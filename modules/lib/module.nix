flake: moduleFamily:
let
  inherit (builtins) readDir concatMap baseNameOf;
  inherit (flake.inputs.nixpkgs.lib.attrsets) mapAttrsToList;

  nameTypePair = name: type: { inherit name type; };

  traverse =
    family: path:
    readDir path
    |> mapAttrsToList nameTypePair
    |> concatMap (
      entry:
      let
        inherit (entry) name type;
      in
      if type == "directory" then
        traverse family (path + "/${name}")
      else if name == "default.nix" && type == "regular" && (baseNameOf path == family) then
        [ (path + "/${name}") ]
      else
        [ ]
    );
in
{
  imports = traverse moduleFamily ../traits;
}
