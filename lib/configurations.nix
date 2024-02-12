inputs:
builtins.listToAttrs (
  map (box: {
    name = box.hostName;
    value = inputs.nixpkgs.lib.nixosSystem {
      inherit (box) system;
      modules = [inputs.self.lib.nixosModule] ++ box.extraModules;
      specialArgs =
        inputs
        // {
          inherit (inputs.self.lib) flakeInputsClosure hmModule;
          inherit box;
        };
    };
  })
  inputs.self.lib.boxen
)
