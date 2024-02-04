{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hm.fish;
in {
  options.hm.fish = {
    enable = lib.mkEnableOption "fish" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs = {
      fish = {
        enable = true;
        shellAliases = {
          e = "${
            lib.getExe' config.programs.emacs.finalPackage "emacsclient"
          } --no-wait --reuse-frame --alternate-editor=${lib.getExe pkgs.neovim}";
        };
      };

      starship = {
        enable = true;
        settings = {
          hostname = {
            ssh_only = false;
          };
          golang = {
            symbol = " ";
          };
        };
      };

      lsd = {
        enable = true;
        enableAliases = true;
        settings = {
          date = "relative";
          header = true;
          indicators = true;
          sorting.dir-grouping = "first";
          # TODO: check when the new release hits the store
          # literal = true;
          total-size = false;
          ignore-globs = [
            ".git"
            ".hg"
          ];
          blocks = [
            "permission"
            "links"
            # "inode"
            "user"
            "group"
            # "context"
            "size"
            "date"
            "git"
            "name"
          ];
        };
      };

      eza = {
        enable = false;
        enableAliases = true;
        git = true;
        icons = true;
        extraOptions = [
          "--binary"
          # "--context"
          "--git-repos-no-status"
          "--group-directories-first"
          "--group"
          "--extended"
          "--header"
          # "--inode"
          "--links"
          "--mounts"
          "--time-style=relative"
        ];
      };

      bat.enable = true;

      fzf = {
        enable = true;
        tmux = {
          enableShellIntegration = true;
          shellIntegrationOptions = ["-d 40%"];
        };
      };

      thefuck.enable = true;

      jq.enable = true;

      tealdeer.enable = true;

      # https://dystroy.org/broot/
      # TODO: explore the tool and configure verbs et al.
      broot = {
        enable = true;
        settings = {
          modal = true;
        };
      };

      lf = {
        enable = true;
        settings = {
          icons = true;
          sixel = true;
        };
      };

      yazi = {
        enable = true;
        enableFishIntegration = true;
      };
    };
  };
}
