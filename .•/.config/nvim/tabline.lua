local M = {}

-- Color definitions
local colors = {
  pm = {
    active_bg = "#efece9",
    active_fg = "#151414",
    inactive_bg = "#efece9",
    inactive_fg = "#151414",
    tree_bg = "NONE",
    tree_fg = "NONE",
    close_btn = "NONE",
  },
  am = {
    active_bg = "#ff9f00",
    active_fg = "#484848",
    inactive_bg = "#ff9f00",
    inactive_fg = "#484848",
    tree_bg = "NONE",
    tree_fg = "NONE",
    close_btn = "NONE",
  }
}

-- Get current theme colors
local function get_colors()
  local theme = vim.g.colors_name or "pm"
  if theme == "am" then
    return colors.am
  else
    return colors.pm
  end
end

-- Check if a buffer is nvim-tree
local function is_tree(buf)
  local ft = vim.api.nvim_buf_get_option(buf, "filetype")
  return ft == "NvimTree"
end

-- Format a single tab
local function format_tab(buf, is_current, colors)
  local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
  if name == "" then name = "[No Name]" end
  
  -- Special handling for nvim-tree
  if is_tree(buf) then
    -- Get nvim-tree width
    local tree_width = 0
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_buf(win) == buf then
        tree_width = vim.api.nvim_win_get_width(win)
        break
      end
    end
    -- Create padding to match tree width
    local padding = string.rep(" ", tree_width - #name - 2)
    return string.format("%%#TabTree# %s%s%%#TabLine# ", name, padding)
  end
  
  -- Normal tabs
  local hl = is_current and "TabLineSel" or "TabLine"
  local close_btn = ""
  
  return string.format("%%#%s# %s %%#TabClose#%s%%#TabLine# ", hl, name, close_btn)
end

-- Generate the entire tabline
function M.get_tabline()
  local line = ""
  local current = vim.api.nvim_get_current_buf()
  local theme_colors = get_colors()
  
  -- Set highlight groups based on current theme
  vim.cmd(string.format([[
    hi TabLine guifg=%s guibg=%s gui=none
    hi TabLineSel guifg=%s guibg=%s gui=bold
    hi TabClose guifg=%s guibg=NONE gui=none
    hi TabTree guifg=%s guibg=%s gui=none
    hi TabLineFill guibg=NONE
  ]], 
    theme_colors.inactive_fg, theme_colors.inactive_bg,
    theme_colors.active_fg, theme_colors.active_bg,
    theme_colors.close_btn,
    theme_colors.tree_fg, theme_colors.tree_bg
  ))
  
  -- Get list of buffers in current tab
  local buffers = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_get_option(buf, "buflisted") or is_tree(buf) then
      table.insert(buffers, buf)
    end
  end
  
  -- Format each buffer as a tab
  for _, buf in ipairs(buffers) do
    line = line .. format_tab(buf, buf == current, theme_colors)
  end
  
  -- Fill the rest of the line
  line = line .. "%#TabLineFill#%T"
  
  return line
end

-- Setup function
function M.setup()
  -- Set the tabline
  vim.opt.tabline = "%!v:lua.require'custom.tabline'.get_tabline()"
  
  -- Create autocmd to update tabline when colorscheme changes
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      vim.cmd("redrawtabline")
    end,
    group = vim.api.nvim_create_augroup("CustomTabline", { clear = true })
  })
end

return M