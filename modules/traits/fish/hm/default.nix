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
          blocks = [
            "permission"
            "links"
            # "inode"
            "user"
            "group"
            "context"
            "size"
            "date"
            "name"
            # "git"
          ];
          ignore-globs = [
            ".git"
            ".hg"
          ];
        };
      };

      eza = {
        enable = false;
        enableAliases = true;
        extraOptions = [
          "--group-directories-first"
          "--group"
          "--header"
        ];
        icons = true;
      };

      bat.enable = true;

      fzf = {
        enable = true;
        tmux = {
          enableShellIntegration = true;
          shellIntegrationOptions = ["-d 40%"];
        };
      };

      zoxide.enable = true;

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
