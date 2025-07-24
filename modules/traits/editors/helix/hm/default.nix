{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.helix;
in
{
  options.traits.hm.helix = {
    enable = lib.mkEnableOption "Helix" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;
      settings = {
        editor.cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };
      languages.language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = lib.getExe pkgs.nixfmt;
        }
        {
          name = "go";
          auto-format = true;
          formatter.command = lib.getExe pkgs.gofumpt;
        }
      ];
      settings = {
        editor = {
          line-number = "relative";
          lsp.display-messages = true;
        };
      };
    };
  };
}
