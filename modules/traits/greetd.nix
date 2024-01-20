{
  config,
  lib,
  attrs ? null,
  ...
}: let
  cfg = config.traits.greetd;
in {
  options.traits.greetd.enable = lib.mkEnableOption "greetd";

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      restart = true;
      settings = rec {
        default_session = initial_session;
        initial_session = {
          command = "${lib.getExe config.programs.hyprland.finalPackage} &>~/.Wsession.errors";
          user = attrs.userName or "alice";
        };
      };
    };
  };
}
