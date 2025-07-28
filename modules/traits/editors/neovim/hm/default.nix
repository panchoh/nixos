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
  imports = [
    nixvim.homeModules.nixvim
    ./disable_keys.nix
    ./neovide.nix
  ];

  options.traits.hm.neovim = {
    enable = lib.mkEnableOption "neovim" // {
      default = true;
    };
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
    };

    xdg.configFile."nvim/lua/disable_keys.lua".source = ./disable_keys.lua;
  };
}
