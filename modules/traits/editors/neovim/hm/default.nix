{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.traits.hm.neovim;
  size = osConfig.stylix.fonts.sizes.terminal * 1.0;
  font = osConfig.stylix.fonts.sansSerif.name;
in {
  options.traits.hm.neovim = {
    enable = lib.mkEnableOption "neovim" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      extraPackages = [
        pkgs.shfmt
        pkgs.vimPlugins.vim-nix
      ];
      extraLuaConfig = ''
        if vim.g.neovide then
          -- Put anything you want to happen only in Neovide here
          -- https://neovide.dev/configuration.html#cursor-particles
          vim.g.neovide_cursor_vfx_mode = "pixiedust"
        end
      '';
    };

    programs.neovide = {
      enable = true;
      settings = {
        fork = false;
        frame = "full";
        idle = true;
        maximized = false;
        neovim-bin = lib.getExe config.programs.neovim.finalPackage;
        no-multigrid = false;
        srgb = false;
        tabs = false;
        theme = "auto";
        title-hidden = true;
        vsync = true;
        wsl = false;

        font = {
          inherit size;
          normal = [font];
        };
      };
    };
  };
}
