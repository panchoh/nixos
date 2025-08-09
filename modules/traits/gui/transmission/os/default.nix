{
  config,
  lib,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.transmission;
in
{
  options.traits.os.transmission = {
    enable = lib.mkEnableOption "Transmission" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 51413 ];
  };
}
