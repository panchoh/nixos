# WIP: finished, but still unused; might be useful with a flake_parts-driven organization.
flake:
let
  listTraitsRecursive =
    dir:
    let
      entries = builtins.readDir dir;
      names = builtins.attrNames entries;
      hasDefault = builtins.elem "default.nix" names && entries."default.nix" == "regular";
      inherit (flake.inputs.nixpkgs.lib.strings) hasPrefix hasSuffix;
    in
    if hasDefault then
      [ "${dir}/default.nix" ]
    else
      names
      |> builtins.concatMap (
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
      );
in
{
  imports = listTraitsRecursive ./traits;
}
