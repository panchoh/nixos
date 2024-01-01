{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hm.mdb;
in {
  options = {
    hm.mdb.enable = lib.mkEnableOption "m";
  };

  config = lib.mkIf cfg.enable {
    home = {
      sessionVariables = {
        MDB_DIR = config.xdg.dataHome + "/mdb";
      };

      packages = [
        (pkgs.writeShellApplication {
          name = "m";
          runtimeInputs = with pkgs; [
            ripgrep
          ];
          text = ''
            cd "$MDB_DIR"
            rg -S "$1" .
          '';
        })

        (pkgs.writeShellApplication {
          name = "mindex";
          runtimeInputs = with pkgs; [
            coreutils
            findutils
            util-linux
          ];
          text = ''
            for dir in /media/*
            do
              findmnt "$dir" >/dev/null 2>&1 || continue
              vol=$(basename "$dir")
              findmnt "$dir" --df > "$MDB_DIR/media/$vol.df"
              find "$dir" | sort > "$MDB_DIR/media/$vol"
            done
          '';
        })
      ];
    };
  };
}