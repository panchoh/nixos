{
  config,
  lib,
  pkgs,
  nvf,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.neovim;
in
{
  imports = [
    nvf.homeManagerModules.default
    ./neovide.nix
  ];

  options.traits.hm.neovim = {
    enable = lib.mkEnableOption "Neovim" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {

    stylix.targets.nvf.enable = false;

    home.packages = [
      (pkgs.writeShellApplication {
        name = "nvf-pristine";
        runtimeInputs = [ pkgs.coreutils ];
        text = ''
          echo 'Cleaning NVF Neovim state…'
          rm -rfv ~/.cache/{nvf,nvim} ~/.local/state/{nvf,nvim} ~/.local/share/{nvf,nvim}
        '';
      })
    ];

    programs.nvf = {
      enable = true;

      settings = {
        vim = {
          autocomplete.blink-cmp.enable = true;

          binds = {
            whichKey.enable = true;
            hardtime-nvim = {
              enable = true;
              setupOpts.disabled_keys =
                [
                  "<Insert>"
                  "<Del>"
                  "<Home>"
                  "<End>"
                  "<PageUp>"
                  "<PageDown>"
                ]
                |> lib.flip lib.attrsets.genAttrs (_key: [
                  ""
                  "i"
                ]);
            };
          };

          # enableLuaLoader = true;

          bell = "visual";

          clipboard = {
            enable = true;
            providers.wl-copy.enable = true;
          };

          comments.comment-nvim.enable = true;

          extraPackages = [ pkgs.ripgrep ];

          filetree.neo-tree = {
            enable = true;
            setupOpts = {
              enable_cursor_hijack = true;
              follow_current_file.enabled = true;
              use_libuv_file_watcher = true;
            };
          };

          globals = {
            mapleader = " ";
            maplocalleader = " ";
            termguicolors = true;
          };

          keymaps = [
            {
              action = "<Nop>";
              desc = "Leader";
              key = "<Space>";
              mode = "n";
            }
            {
              action = "<Cmd>nohlsearch<Enter>";
              desc = "Clear search results";
              key = "<Esc>";
              mode = "n";
            }
            {
              action = "<Cmd>Pick help<Enter>";
              desc = "Search help";
              key = "<Leader>hh";
              mode = "n";
            }
            {
              action = "<Cmd>Pick files<Enter>";
              desc = "Search files";
              key = "<Leader><Leader>";
              mode = "n";
            }
            {
              action = "<Cmd>Pick grep_live<Enter>";
              desc = "Search file contents";
              key = "<Leader>/";
              mode = "n";
            }
            {
              action = "<Cmd>Neotree<Enter>";
              desc = "Neo-tree";
              key = "<Leader>op";
              mode = "n";
            }
            {
              action = "vim.lsp.buf.rename";
              desc = "LSP rename";
              key = "<Leader>cr";
              lua = true;
              mode = "n";
            }
          ];

          languages = {
            bash.enable = true;
            clang.enable = true;
            go.enable = true;
            go.dap.enable = true;
            go.format.type = "gofumpt";
            lua.enable = true;
            nix.enable = true;
            typst.enable = true;
          };

          lsp = {
            enable = true;
            formatOnSave = true;
            inlayHints.enable = true;
            lightbulb.enable = true;
          };

          mini.pick.enable = true;

          options = {
            # Tab handling and autoindenting
            autoindent = true;
            tabstop = 4;
            shiftwidth = 4;
            expandtab = true;

            # Search
            incsearch = true;
            ignorecase = true;
            smartcase = true;

            # Line numbering
            number = true;
            relativenumber = true;

            autoread = true;
            updatetime = 100;
            spell = false;
            wrap = false;
            signcolumn = "yes";
            swapfile = false;
            winborder = "rounded";
          };

          statusline.lualine.enable = true;

          theme = {
            enable = true;
            name = "dracula";
            style = "dark";
          };

          treesitter = {
            enable = true;
            fold = true;
          };

          ui = {
            borders.enable = true;
            breadcrumbs.enable = true;
            noice.enable = true;
          };

          utility = {
            direnv.enable = true;
            preview.glow.enable = true;
          };

          viAlias = true;
          vimAlias = true;
        };
      };
    };
  };
}
