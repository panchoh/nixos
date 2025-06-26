-- ~/.config/nvim/lua/disable_keys.lua
local M = {}

function M.setup()

  local bad_keys = {
    "<Up>", "<Down>", "<Left>", "<Right>",
    "<Insert>", "<Del>", "<Home>", "<End>", "<PageUp>", "<PageDown>",
  }

  local modes = { "n", "i", "v" }

  -- Set up the key mappings to do nothing
  for _, key in ipairs(bad_keys) do
    for _, mode in ipairs(modes) do
      vim.keymap.set(mode, key, function() end, { noremap = true, silent = true })
    end
  end
end

return M
