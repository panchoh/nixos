{
  config,
  lib,
  pkgs,
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
        autoread = true;
        updatetime = 100; # Faster completion
        spell = false;
        number = true;
        relativenumber = true;
        wrap = false;
        tabstop = 4;
        shiftwidth = 4;
        expandtab = true;
        signcolumn = "yes";
        swapfile = false;
        winborder = "rounded";
      };

      globals = {
        mapleader = " ";
        maplocalleader = " ";
        termguicolors = true;
      };

      filetype.extension.typ = "typst";

      plugins = {
        cmp.enable = true;

        nix.enable = true;

        lsp = {
          enable = true;
          inlayHints = true;
          servers.gopls.enable = true;
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

      keymaps = [
        {
          action = "<CMD>Pick help<Enter>";
          key = "<leader>h";
        }
        {
          action = "<CMD>Pick files<Enter>";
          key = "<leader>f";
        }
        {
          action = "<CMD>Pick grep_live<Enter>";
          key = "<leader>/";
        }
      ];

      lsp.keymaps = [
        {
          key = "gd";
          lspBufAction = "definition";
        }
        {
          key = "gD";
          lspBufAction = "references";
        }
        {
          key = "gt";
          lspBufAction = "type_definition";
        }
        {
          key = "gi";
          lspBufAction = "implementation";
        }
        {
          key = "K";
          lspBufAction = "hover";
        }
        # {
        #   action = lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count=-1, float=true }) end";
        #   key = "<leader>k";
        # }
        # {
        #   action = lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count=1, float=true }) end";
        #   key = "<leader>j";
        # }
        {
          action = "<CMD>LspStop<Enter>";
          key = "<leader>lx";
        }
        {
          action = "<CMD>LspStart<Enter>";
          key = "<leader>ls";
        }
        {
          action = "<CMD>LspRestart<Enter>";
          key = "<leader>lr";
        }
        # {
        #   action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_definitions";
        #   key = "gd";
        # }
        {
          action = "<CMD>Lspsaga hover_doc<Enter>";
          key = "K";
        }
      ];

      extraConfigLua = ''
        require('mini.pick').setup()
      '';

      extraPlugins = [
        pkgs.vimPlugins.mini-pick
      ];

      extraPackages = [
        pkgs.ripgrep
      ];
    };
  };
}
