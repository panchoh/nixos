{
  config,
  lib,
  ...
}: let
  cfg = config.traits.autoupgrade;
in {
  options.traits.autoupgrade.enable = lib.mkEnableOption "autoUpgrade";

  config.system.autoUpgrade = lib.mkIf cfg.enable {
    enable = true;
    allowReboot = true;
    flake = "github:panchoh/nixos";
    flags = ["--update-input" "nixpkgs" "--commit-lock-file"];
  };
}
