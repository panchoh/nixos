{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hm.gopass;
in {
  options.hm.gopass = {
    enable = lib.mkEnableOption "gopass";

    storeDir = lib.mkOption {
      type = lib.types.uniq lib.types.str;
      default = "${config.xdg.dataHome}/gopass/stores/root";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      activation = {
        configEditor = lib.hm.dag.entryAfter ["writeBoundary"] ''
          verboseEcho Configuring gopass editor
          run ${lib.getExe pkgs.gopass} config edit.editor ${lib.getExe pkgs.openvi}
        '';
      };
    };

    programs.password-store = {
      enable = true;
      package = pkgs.gopass;
      settings = {
        PASSWORD_STORE_DIR = "${cfg.storeDir}";
      };
    };
  };
}
