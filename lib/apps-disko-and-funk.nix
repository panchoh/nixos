inputs:
builtins.foldl' (
  acc: box: let
    inherit (box) system hostName;
    entry = {
      type = "app";
      # TODO: run not only disko, but all steps, including blkdiscard -f box.diskDevice, nixos-install --...
      program = "${inputs.self.nixosConfigurations."${hostName}".config.system.build.diskoScript}";
    };
  in
    acc // {${system} = (acc.${system} or {}) // {${hostName} = entry;};}
) {}
inputs.self.lib.boxen
# TODO: apps."x86_64-linux".default = self.apps."x86_64-linux"."nixos";
