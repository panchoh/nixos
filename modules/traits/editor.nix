{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.editor;
in {
  options.traits.editor.enable = lib.mkEnableOption "editor";

  config = lib.mkIf cfg.enable {
    programs.nano.enable = false;

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
      configure = {
        customRC = ''
          set mouse=
        '';
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [vim-nix];
        };
      };
    };

    environment.variables.EDITOR = "nvim";
  };
}
