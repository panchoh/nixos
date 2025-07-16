inputs:
builtins.listToAttrs (
  map (box: {
    name = box.hostName;
    value = inputs.nixpkgs.lib.nixosSystem {
      inherit (box) system;
      modules = [ inputs.self.nixosModules.default ] ++ box.extraModules;
      specialArgs = inputs // {
        extraSpecialArgs = inputs // {
          inherit box;
        };
        home = {
          imports = [ inputs.self.homeModules.default ] ++ box.extraHomeModules;
        };
        inherit box;
      };
    };
  }) inputs.self.lib.boxen
)
