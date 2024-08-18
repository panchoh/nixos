{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.neovim;
in {
  options.traits.neovim = {
    enable = lib.mkEnableOption "neovim" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs = {
      nano.enable = false;
      neovim = {
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
    };

    environment.variables.EDITOR = "nvim";
  };
}
