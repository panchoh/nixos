-- ~/.config/nvim/lua/disable_keys.lua
local M = {}

function M.setup(opts)
  opts = opts or {}

  -- Configuration options
  local config = {
    show_hints = opts.show_hints ~= false,  -- Show helpful hints (default: true)
  }

  local bad_keys = {
    "<Up>", "<Down>", "<Left>", "<Right>",
    "<Insert>", "<Del>", "<Home>", "<End>", "<PageUp>", "<PageDown>",
  }

  local modes = { "n", "i", "v" }

  -- Contextual hints for specific forbidden keys
  local key_hints = {
    ["<Up>"] = {
      "💡 Try: k to go up one line",
    },
    ["<Down>"] = {
      "💡 Try: j go go down one line",
    },
    ["<Left>"] = {
      "💡 Try: h to go left one character",
    },
    ["<Right>"] = {
      "💡 Try: l to go right one character",
    },
    ["<Home>"] = {
      "💡 Try: 0 to go to start of line",
      "💡 Try: ^ to go to first non-blank char",
      "💡 Try: I to insert at line start",
      "💡 Try: gg to go to first line",
    },
    ["<End>"] = {
      "💡 Try: $ to go to end of line",
      "💡 Try: A to append at line end",
      "💡 Try: G to go to last line",
      "💡 Try: g_ to go to last non-blank char",
    },
    ["<PageUp>"] = {
      "💡 Try: Ctrl+u to scroll up half screen",
      "💡 Try: Ctrl+b to scroll up full screen",
      "💡 Try: H to go to top of screen",
      "💡 Try: gg to go to top of file",
    },
    ["<PageDown>"] = {
      "💡 Try: Ctrl+d to scroll down half screen",
      "💡 Try: Ctrl+f to scroll down full screen",
      "💡 Try: L to go to bottom of screen",
      "💡 Try: G to go to bottom of file",
    },
    ["<Insert>"] = {
      "💡 Try: i to insert before cursor",
      "💡 Try: I to insert at line start",
      "💡 Try: a to append after cursor",
      "💡 Try: A to append at line end",
      "💡 Try: o to open new line below",
    },
    ["<Del>"] = {
      "💡 Try: x to delete character under cursor",
      "💡 Try: X to delete character before cursor",
      "💡 Try: dw to delete word",
      "💡 Try: dd to delete entire line",
      "💡 Try: D to delete to end of line",
    }
  }

  -- Track the current warning window
  local current_warning_win = nil
  local warning_timer = nil

  local function get_contextual_hint(pressed_key)
    if not config.show_hints then return nil end

    local hints_for_key = key_hints[pressed_key]
    if hints_for_key and #hints_for_key > 0 then
      return hints_for_key[math.random(#hints_for_key)]
    end

    -- Fallback to general hint if specific key not found
    return "💡 Try: hjkl for navigation"
  end

  local function show_nav_warning(pressed_key)
    -- Clean up existing warning
    if warning_timer then
      warning_timer:stop()
      warning_timer:close()
      warning_timer = nil
    end

    if current_warning_win and vim.api.nvim_win_is_valid(current_warning_win) then
      vim.api.nvim_win_close(current_warning_win, true)
      current_warning_win = nil
    end

    -- Create message lines with contextual hint
    local main_message = "⛔ Use hjkl or Vim-style navigation!"
    local lines = {main_message}
    local hint = get_contextual_hint(pressed_key)
    if hint then
      table.insert(lines, hint)
    end

    -- Create popup
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local width = 0
    for _, line in ipairs(lines) do
      width = math.max(width, string.len(line))
    end
    width = width + 4

    local height = #lines + 2

    local ui = vim.api.nvim_list_uis()[1]
    local row = math.floor((ui.height - height) / 2)
    local col = math.floor((ui.width - width) / 2)

    local win = vim.api.nvim_open_win(buf, false, {
      relative = 'editor',
      width = width,
      height = height,
      row = row,
      col = col,
      style = 'minimal',
      border = 'rounded',
      focusable = false,
    })

    current_warning_win = win
    vim.api.nvim_win_set_option(win, 'winhl', 'Normal:WarningMsg')

    -- Auto-close timing - longer if there's a hint
    local close_delay = #lines > 1 and 1500 or 1000
    warning_timer = vim.defer_fn(function()
      if current_warning_win and vim.api.nvim_win_is_valid(current_warning_win) then
        vim.api.nvim_win_close(current_warning_win, true)
        current_warning_win = nil
      end
      warning_timer = nil
    end, close_delay)
  end

  -- Set up the key mappings
  for _, key in ipairs(bad_keys) do
    for _, mode in ipairs(modes) do
      vim.keymap.set(mode, key, function()
        show_nav_warning(key)
      end, { noremap = true, silent = true })
    end
  end

  -- Welcome message
  vim.defer_fn(function()
    print("🎯 Vim Training Mode activated!")
  end, 100)
end

return M
