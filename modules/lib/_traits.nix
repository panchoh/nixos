# WIP: finished, but still unused; might be useful with a flake_parts-driven organization.
inputs:
let
  inherit (builtins)
    attrNames
    concatMap
    elem
    readDir
    ;
  inherit (inputs.nixpkgs.lib.strings) hasPrefix hasSuffix;

  listTraitsRecursive =
    dir:
    let
      entries = readDir dir;
      names = attrNames entries;
      hasDefault = elem "default.nix" names && entries."default.nix" == "regular";
    in
    if hasDefault then
      [ "${dir}/default.nix" ]
    else
      concatMap (
        name:
        let
          path = "${dir}/${name}";
          type = entries.${name};
        in
        if hasPrefix "_" name then
          [ ]
        else if type == "regular" && hasSuffix ".nix" name then
          [ path ]
        else if type == "directory" then
          listTraitsRecursive path
        else
          [ ]
      ) names;

in
listTraitsRecursive ../traits
