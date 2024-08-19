{
  config,
  lib,
  flakeInputsClosure,
  ...
}: let
  cfg = config.traits.os.flake-sources;
in {
  options.traits.os.flake-sources = {
    enable = lib.mkEnableOption "flake inputs as GC roots (recursively)" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    system.extraDependencies = flakeInputsClosure;
  };
}
