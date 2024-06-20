{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}: let
  cfg = config.traits.hm.mdb;
in {
  options.traits.hm.mdb = {
    enable = lib.mkEnableOption "m" // {default = box.isStation or false;};
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

        (pkgs.writeShellApplication {
          name = "normalize";
          runtimeInputs = with pkgs; [
            coreutils
            findutils
          ];
          text = ''
            chown --recursive ${config.home.username}:users .
            find . -type d -exec chmod 2755 {} +
            find . -type f -exec chmod 644 {} +
          '';
        })
      ];
    };
  };
}
