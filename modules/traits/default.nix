{lib, ...}: {
  imports = builtins.filter (path: builtins.pathExists path) (
    map (name: ./. + "/${name}/default.nix")
    (
      lib.attrNames (
        lib.filterAttrs (name: type: type == "directory")
        (builtins.readDir ./.)
      )
    )
  );
}
