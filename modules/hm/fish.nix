{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hm.fish;
in {
  options.hm.fish.enable = lib.mkEnableOption "fish" // {default = true;};

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      shellAliases = {
        e = "${
          lib.getExe' config.programs.emacs.finalPackage "emacsclient"
        } --no-wait --reuse-frame --alternate-editor=${lib.getExe pkgs.neovim}";
      };
    };
    programs.starship = {
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
    programs.lsd = {
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
    programs.eza = {
      enable = false;
      enableAliases = true;
      extraOptions = [
        "--group-directories-first"
        "--group"
        "--header"
      ];
      icons = true;
    };
    programs.bat.enable = true;
    programs.fzf = {
      enable = true;
      tmux = {
        enableShellIntegration = true;
        shellIntegrationOptions = ["-d 40%"];
      };
    };
    programs.zoxide.enable = true;
    programs.thefuck.enable = true;
    programs.jq.enable = true;
    programs.tealdeer.enable = true;

    programs.lf = {
      enable = true;
      settings = {
        icons = true;
        sixel = true;
      };
    };

    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
