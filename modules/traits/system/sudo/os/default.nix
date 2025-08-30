{
  config,
  lib,
  ...
}:
let
  cfg = config.traits.os.sudo;
in
{
  options.traits.os.sudo = {
    enable = lib.mkEnableOption "sudo" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: { sudo = prev.sudo.override { withInsults = true; }; })
    ];
  };
}
