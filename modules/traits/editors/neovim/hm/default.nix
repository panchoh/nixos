{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.traits.hm.neovim;
  size = toString osConfig.stylix.fonts.sizes.terminal;
in {
  options.traits.hm.neovim = {
    enable = lib.mkEnableOption "neovim" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.neovide];

    programs.neovim = {
      enable = true;
      extraLuaConfig = ''
        if vim.g.neovide then
          -- https://neovide.dev/configuration.html
          -- Put anything you want to happen only in Neovide here
          vim.o.guifont = "Iosevka Comfy:h${size}"
        end
      '';
    };
  };
}
