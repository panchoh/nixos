flake:
let
  inherit (flake.inputs.nixpkgs.lib.attrsets) genAttrs;

  mkDevShell =
    system:
    let
      inherit (flake.inputs.nixpkgs.legacyPackages.${system}) pkgs;
    in
    pkgs.mkShellNoCC {
      name = "copito--my-flaky-nixos-config";
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
        toilet --font smbraille --gay "copito-my flaky NixOS config"
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
