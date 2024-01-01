{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hm.gopass;
in {
  options = {
    hm.gopass.enable = lib.mkEnableOption "gopass";
  };

  config = lib.mkIf cfg.enable {
    home = {
      activation = {
        configEditor = lib.hm.dag.entryAfter ["writeBoundary"] ''
          [[ ! -z "$VERBOSE_ARG" ]] && echo Configuring gopass editor
          $DRY_RUN_CMD ${lib.getExe pkgs.gopass} config edit.editor ${lib.getExe pkgs.openvi}
        '';
      };
    };

    programs.password-store = {
      enable = true;
      package = pkgs.gopass;
      settings = {PASSWORD_STORE_DIR = "${config.xdg.dataHome}/gopass/stores/root";};
    };
  };
}
