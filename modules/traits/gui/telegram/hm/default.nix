{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.telegram;
in
{
  options.traits.hm.telegram = {
    enable = lib.mkEnableOption "Telegram Desktop" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {

    xdg.mimeApps.defaultApplications =
      [
        "x-scheme-handler/tg"
        "x-scheme-handler/tonsite"
      ]
      |> map (lib.flip lib.nameValuePair "telegram.desktop.desktop")
      |> lib.listToAttrs;

    home.packages = [ pkgs.telegram-desktop ];
  };
}
