inputs: moduleFamily:
let
  inherit (builtins) readDir concatMap baseNameOf;
  inherit (inputs.nixpkgs.lib) mapAttrsToList;
  baseDir = ../traits;

  traverse =
    family: path:
    readDir path
    |> mapAttrsToList (name: type: { inherit name type; })
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
  imports = traverse moduleFamily baseDir;
}
