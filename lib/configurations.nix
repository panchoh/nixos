inputs:
builtins.listToAttrs (
  map (box: {
    name = box.hostName;
    value = inputs.nixpkgs.lib.nixosSystem {
      inherit (box) system;
      modules = [
        box.hostType
        box.extraModule
        inputs.self.lib.nixosModule
      ];
      specialArgs =
        inputs
        // {
          inherit (inputs.self.lib) hmModule;
          inherit box;
        };
    };
  })
  inputs.self.lib.boxen
)
