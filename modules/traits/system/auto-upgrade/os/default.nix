{
  config,
  lib,
  ...
}:
let
  cfg = config.traits.os.auto-upgrade;
in
{
  # TODO: this is a WIP
  options.traits.os.auto-upgrade = {
    enable = lib.mkEnableOption "auto upgrade" // {
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      allowReboot = true;
      flake = "github:panchoh/nixos";
      flags = [
        "--update-input"
        "nixpkgs"
        "--commit-lock-file"
      ];
    };
  };
}
