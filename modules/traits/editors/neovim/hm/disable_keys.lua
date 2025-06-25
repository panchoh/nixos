-- ~/.config/nvim/lua/disable_keys.lua
local M = {}

function M.setup()
  local bad_keys = {
    "<Up>", "<Down>", "<Left>", "<Right>",
    "<Insert>", "<Del>", "<Home>", "<End>", "<PageUp>", "<PageDown>",
  }

  local modes = { "n", "i", "v" }

  local function show_nav_warning()
    -- Show the message
    vim.api.nvim_echo({{"⛔ Use hjkl or Vim-style navigation!", "WarningMsg"}}, false, {})

    -- Clear it automatically after 500ms
    vim.defer_fn(function()
      vim.cmd("echo ''")
    end, 1000)
  end

  for _, key in ipairs(bad_keys) do
    for _, mode in ipairs(modes) do
      vim.keymap.set(mode, key, show_nav_warning, { noremap = true, silent = true })
    end
  end
end

return M
