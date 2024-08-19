{
  config,
  lib,
  ...
}: let
  cfg = config.traits.os.allow-unfree;
in {
  options.traits.os.allow-unfree = {
    enable = lib.mkEnableOption "allow unfree" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;
  };
}
