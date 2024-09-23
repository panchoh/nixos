{
  config,
  lib,
  pkgs,
  emacs-overlay,
  box ? null,
  ...
}: let
  cfg = config.traits.os.emacs;
in {
  options.traits.os.emacs = {
    enable = lib.mkEnableOption "emacs" // {default = box.isStation;};
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      emacs-overlay.overlays.default
    ];
  };
}
