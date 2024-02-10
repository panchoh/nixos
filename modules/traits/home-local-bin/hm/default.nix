{
  config,
  lib,
  ...
}: let
  cfg = config.hm.home-local-bin;
in {
  options.hm.home-local-bin = {
    enable = lib.mkEnableOption "~/.local/bin on the search PATH" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    home.sessionPath = [
      "$HOME/.local/bin"
    ];
  };
}
