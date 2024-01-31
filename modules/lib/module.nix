inputs: subDir: let
  inherit (builtins) filter pathExists readDir;
  inherit (inputs.nixpkgs.lib) attrNames filterAttrs;
  baseDir = ../traits;
  segmentPath =
    if subDir != null
    then "/${subDir}"
    else "";
in {
  imports = filter (path: pathExists path) (
    map (name: "${baseDir}/${name}${segmentPath}/default.nix")
    (
      attrNames (
        filterAttrs (_name: type: type == "directory")
        (readDir baseDir)
      )
    )
  );
}
