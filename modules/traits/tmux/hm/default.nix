{
  config,
  lib,
  ...
}: let
  cfg = config.hm.tmux;
in {
  options.hm.tmux = {
    enable = lib.mkEnableOption "tmux" // {default = true;};
  };

  config.programs.tmux = lib.mkIf cfg.enable {
    enable = true;
    aggressiveResize = true;
    clock24 = true;
    mouse = true;
    terminal = "tmux-256color";
    sensibleOnTop = false;
    escapeTime = 0;
    extraConfig = ''
      set -g focus-events on
      set -g status-interval 5
    '';
  };
}
