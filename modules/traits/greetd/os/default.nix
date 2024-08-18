{
  config,
  lib,
  box ? null,
  ...
}: let
  cfg = config.traits.greetd;
in {
  options.traits.greetd = {
    enable = lib.mkEnableOption "greetd" // {default = box.isStation or false;};
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      restart = true;
      settings = rec {
        default_session = initial_session;
        initial_session = {
          command = "${lib.getExe config.programs.hyprland.package} &>~/.Wsession.errors";
          user = box.userName or "alice";
        };
      };
    };
  };
}
