inputs:
builtins.foldl' (
  acc: box: let
    inherit (inputs.nixpkgs.legacyPackages.${box.system}) pkgs;
    inherit (box) system;

    devShell = pkgs.mkShellNoCC {
      name = "My-Flaky-NixOS-Config";
      packages = with pkgs; [
        cacert
        nix
        git
        gnumake
        toilet
      ];
      shellHook = ''
        echo
        toilet --font smbraille --gay "My Flaky NixOS Config"
        echo
        make help
      '';
    };
  in
    acc // {${system} = (acc.${system} or {}) // {default = devShell;};}
) {}
inputs.self.lib.boxen