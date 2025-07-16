inputs: moduleFamily:
let
  inherit (builtins) readDir baseNameOf;
  inherit (inputs.nixpkgs.lib) concatMap concatStringsSep mapAttrsToList;
  baseDir = ../traits;

  traverse =
    family: path:
    concatMap
      (
        entry:
        let
          inherit (entry) name type;
        in
        if type == "directory" then
          traverse family (
            concatStringsSep "/" [
              path
              name
            ]
          )
        else if name == "default.nix" && type == "regular" && (baseNameOf path == family) then
          [
            (concatStringsSep "/" [
              path
              name
            ])
          ]
        else
          [ ]
      )
      (
        mapAttrsToList (name: type: {
          inherit name type;
        }) (readDir path)
      );
in
{
  imports = traverse moduleFamily baseDir;
}
