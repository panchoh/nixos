inputs:
builtins.listToAttrs (
  map (box: {
    name = box.hostName;
    value = inputs.nixpkgs.lib.nixosSystem {
      inherit (box) system;
      modules =
        [
          {
            nixpkgs.overlays = [
              inputs.emacs-overlay.overlays.default
            ];
          }
          inputs.self.nixosModules.default
        ]
        ++ box.extraModules;
      specialArgs =
        inputs
        // {
          inherit (inputs.self.lib) extraSpecialArgs hmModule;
          inherit box;
        };
    };
  })
  inputs.self.lib.boxen
)
