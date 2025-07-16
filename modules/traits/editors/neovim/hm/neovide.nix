{
  config,
  lib,
  nixvim,
  ...
}:
let
  cfg = config.traits.hm.neovim;
in
{
  config = lib.mkIf cfg.enable {
    programs.neovide = {
      enable = true;
      settings = {
        fork = false;
        frame = "full";
        idle = true;
        maximized = false;
        no-multigrid = false;
        srgb = false;
        tabs = false;
        theme = "auto";
        title-hidden = true;
        vsync = true;
        wsl = false;
      };
    };

    programs.nixvim = {
      extraConfigLua = ''
        if vim.g.neovide then
          -- Put anything you want to happen only in Neovide here
          -- https://neovide.dev/configuration.html#cursor-particles
          vim.g.neovide_cursor_vfx_mode = "pixiedust"
        end
      '';
    };
  };
}
