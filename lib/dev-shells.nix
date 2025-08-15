flake:
let
  inherit (flake.inputs.nixpkgs.lib.attrsets) genAttrs;

  mkDevShell =
    system:
    let
      inherit (flake.inputs.nixpkgs.legacyPackages.${system}) pkgs;
    in
    pkgs.mkShellNoCC {
      name = "My-Flaky-NixOS-Config";
      packages = with pkgs; [
        cacert
        nix
        nixfmt-tree
        nixfmt
        git
        go-task
        toilet
      ];
      shellHook = ''
        echo
        toilet --font smbraille --gay "My Flaky NixOS Config"
        echo
        task
      '';
    };

  mkDefaultDevShellForSystem = system: {
    default = mkDevShell system;
  };

  dev-shells = genAttrs flake.lib.systems mkDefaultDevShellForSystem;
in
dev-shells
