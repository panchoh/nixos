inputs: subDir: let
  inherit (builtins) filter pathExists readDir;
  inherit (inputs.nixpkgs.lib) attrNames filterAttrs concatStringsSep optionalString;
  baseDir = ../traits;
in {
  imports = filter (path: pathExists path) (
    map (
      name:
        concatStringsSep "/" [
          baseDir
          name
          (optionalString (subDir != null) subDir)
          "default.nix"
        ]
    )
    (
      attrNames (
        filterAttrs (_name: type: type == "directory")
        (readDir baseDir)
      )
    )
  );
}
