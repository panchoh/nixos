{
  config,
  lib,
  nixvim,
  ...
}: let
  cfg = config.traits.hm.neovim;
in {
  imports = [
    nixvim.homeModules.nixvim
    ./disable_keys.nix
  ];

  options.traits.hm.neovim = {
    enable = lib.mkEnableOption "neovim" // {default = true;};
  };

  # TODO: Import config from https://github.com/GaetanLepage/nix-config/blob/master/home/modules/tui/neovim/options.nix
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      nixpkgs.useGlobalPackages = true;

      viAlias = true;
      vimAlias = true;

      plugins.lualine.enable = true;

      performance.byteCompileLua.enable = true;

      luaLoader.enable = true;

      opts = {
        updatetime = 100; # Faster completion
        spell = false;
      };

      plugins = {
        cmp.enable = true;

        nix.enable = true;

        lsp = {
          enable = true;
          inlayHints = true;
        };

        efmls-configs = {
          enable = true;
          setup = {
            bash = {
              formatter = "shfmt";
              linter = "shellcheck";
            };
          };
        };

        treesitter = {
          enable = true;

          nixvimInjections = true;

          settings = {
            highlight.enable = true;
            indent.enable = true;
          };
        };

        treesitter-refactor = {
          enable = true;
          highlightDefinitions = {
            enable = true;
            # Set to false if you have an `updatetime` of ~100.
            clearOnCursorMove = false;
          };
        };

        hmts.enable = true;
      };

      extraConfigLua = ''
        if vim.g.neovide then
          -- Put anything you want to happen only in Neovide here
          -- https://neovide.dev/configuration.html#cursor-particles
          vim.g.neovide_cursor_vfx_mode = "pixiedust"
        end
      '';
    };

    xdg.configFile."nvim/lua/disable_keys.lua".source = ./disable_keys.lua;

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
  };
}
