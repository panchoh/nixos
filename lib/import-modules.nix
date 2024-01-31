{
  lib,
  baseDir,
  subDir ? null,
}: let
  inherit (builtins) filter pathExists readDir;
  inherit (lib) attrNames filterAttrs;
  segmentPath =
    if subDir != null
    then "/${subDir}"
    else "";
in {
  imports = filter (path: pathExists path) (
    map (name: "${baseDir}/${name}${segmentPath}/default.nix")
    (
      attrNames (
        filterAttrs (name: type: type == "directory")
        (readDir baseDir)
      )
    )
  );
}
