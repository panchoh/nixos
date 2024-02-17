{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.hm.gopass;
  passwordStoreDir = "${config.xdg.dataHome}/gopass/stores/root";
in {
  options.traits.hm.gopass = {
    enable = lib.mkEnableOption "gopass" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    home = {
      activation = {
        configGopassEditor = lib.hm.dag.entryAfter ["writeBoundary"] ''
          verboseEcho Configuring gopass editor
          PATH="${config.home.path}/bin:$PATH" run gopass config edit.editor ${lib.getExe pkgs.openvi}
        '';
        cloneGopassStore = lib.hm.dag.entryAfter ["writeBoundary"] ''
          mkdir --parents "${passwordStoreDir}"
          rmdir --ignore-fail-on-non-empty "${passwordStoreDir}"
          if [[ ! -d "${passwordStoreDir}" ]]; then
            verboseEcho Cloning gopass-store
            PATH="${config.home.path}/bin:$PATH" run gopass clone --check-keys=false git@github.com:panchoh/gopass-store.git
          fi
        '';
      };
    };

    programs.password-store = {
      enable = true;
      package = pkgs.gopass;
      settings = {
        PASSWORD_STORE_DIR = "${passwordStoreDir}";
      };
    };
  };
}
