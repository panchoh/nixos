{
  config,
  lib,
  ...
}: let
  cfg = config.traits.allow-unfree;
in {
  options.traits.allow-unfree = {
    enable = lib.mkEnableOption "allow unfree" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;
  };
}
