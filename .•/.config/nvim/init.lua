local opt = vim.opt

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.wrap = false

-- Remove split borders
opt.fillchars:append({
  vert = ' ',
})

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- cursor line
opt.cursorline = true

-- termguicolors
opt.termguicolors = true
opt.background = "light"
opt.signcolumn = "yes"

-- line numbers
opt.number = true
opt.relativenumber = true
opt.fillchars:append({ eob = ' ' })  -- Replace ~ with space in the number column

-- tabs
opt.cmdheight = 1
opt.pumheight = 10
opt.winbar = " "
opt.showtabline = 2  -- Always show tabs

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true
-- opt.laststatus = 3

-- KEYMAP
vim.g.mapleader = " "
local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment /decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })                   --split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })                 -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equal split sizes" })                         -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })               -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })                     -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })              -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Next tab" })                           -- go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Previous tab" })                       -- go to previous tab

keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) -- open current buffer in new tab

keymap.set("n", "<leader>nt", "<cmd>NvimTreeToggle<CR>", { desc = "Nvim Tree Toggle" })     



















-- HELPER FUNCTIONS
local function fixed(str, width)
    local padding = width - vim.fn.strwidth(str)
    if padding > 0 then
        return str .. string.rep(" ", padding)
    else
        return str
    end
end

-- Global timing functions
_G.time = {}

-- Create a new timer with specified interval (in ms)
function _G.create_timer(interval, callback)
    local timer_id = #_G.time + 1
    local timer = vim.loop.new_timer()
    
    _G.time[timer_id] = {
        timer = timer,
        active = true
    }
    
    timer:start(0, interval, vim.schedule_wrap(function()
        if _G.time[timer_id].active then
            callback()
        end
    end))
    
    return timer_id
end

-- Stop a timer by ID
function _G.stop_timer(timer_id)
    if _G.time[timer_id] then
        _G.time[timer_id].timer:stop()
        _G.time[timer_id].active = false
    end
end

-- Pause a timer by ID
function _G.pause_timer(timer_id)
    if _G.time[timer_id] then
        _G.time[timer_id].active = false
    end
end

-- Resume a timer by ID
function _G.resume_timer(timer_id)
    if _G.time[timer_id] then
        _G.time[timer_id].active = true
    end
end



-- STATUS BAR
-- +–––+–––+–––+–––––––––––––––––––––––––+–––+–––+–––+
-- | 1 | 2 | 3 |           4             | 5 | 6 | 7 |
-- +–––+–––+–––+–––––––––––––––––––––––––+–––+–––+–––+

vim.opt.statusline = table.concat({
    -- S1 - Mode - remove space after mode
    "%#BoldMode#%{v:lua.get_mode()}%*",
    -- S3 Leading position because it jumps around alot
    "%{v:lua.get_position()}",
     -- S2 
     "%{v:lua.get_percent()}",
    -- S4
    "%{v:lua.get_buffer_info()}",
    -- S5
    "%=%{v:lua.pomodoro()}%=",
    -- S6 
    "%{v:lua.get_diagnostics()}",
    -- S7 - Remove trailing space
    "%{v:lua.get_colorscheme_no_padding()}"
})

-- 1 = MODE ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
vim.cmd([[hi BoldMode gui=bold]])

local mode_map = {
    n = "N  ",
    no = "N  ",
    nov = "N  ",
    noV = "N  ",
    ["no\22"] = "N  ",
    niI = "N  ",
    niR = "N  ",
    niV ="N  ",
    i = "I  ",
    ic = "I  ",
    ix = "I  ",
    R = "R  ",
    Rc = "R  ",
    Rx = "R  ",
    Rv = "R  ",
    Rvc = "R  ",
    Rvx = "R  ",
    s ="S  ",
    S = "S  ",
    ["\19"] = "S  ",
    v = "V  ",
    V = "V  ",
    ["\22"] = "V  ",
    c = "C  ",
    cv = "C  ",
    ce = "C  ",
    t = "T  ",
    r ="R  ",
    rm = "M  ",
    ["r?"] = "C  ",
    ["!"] = "!  ",
    [" "] = "   "
}
_G.get_mode = function()
    return mode_map[vim.fn.mode()] or "?"
end

-- 2 = ERRORS & WARNINGS –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
_G.get_diagnostics = function()
    local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    -- Format with leading zeros
    local error_part = "" .. fixed(" ✖ " .. string.format("%03d", errors), 6) .. ""
    local warning_part = "" .. fixed(" ! " .. string.format("%03d", warnings), 8) .. ""
    return error_part .. warning_part
end

-- 3 = BUFFER ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
_G.get_buffer_info = function()
    local current = vim.fn.bufnr('%')
    local total = #vim.fn.getbufinfo({ buflisted = 1 })
    return fixed(" " .. current .. "/" .. total, 0)
end

-- 4 = POMODORO –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
-- Initialize timer variables
_G.pomodoro_state = {
    active = false,
    end_time = 0,
    work_duration = 25 * 60, -- 25 minutes in seconds
    break_duration = 5 * 60, -- 5 minutes in seconds
    remaining = 25 * 60, -- Store remaining time when paused
    is_break = false, -- Track if we're in a break or work period
    timer_id = nil,
    last_second = nil -- Track the last second for sound alert
}

-- Function to set custom durations
function _G.set_pomodoro_durations(work_minutes, break_minutes)
    local state = _G.pomodoro_state
    
    -- Convert minutes to seconds
    state.work_duration = work_minutes * 60
    state.break_duration = break_minutes * 60
    
    -- If timer is not active, update the remaining time based on current mode
    if not state.active then
        state.remaining = state.is_break and state.break_duration or state.work_duration
    end
    
    -- Notify user of the change
    vim.notify(string.format("  -> Pomodoro set: %d min work / %d min break", work_minutes, break_minutes), vim.log.levels.INFO)
    
    -- Force immediate redraw
    vim.cmd('redrawstatus!')
end

-- Function to start/stop the timer
function _G.toggle_timer(work_minutes, break_minutes)
    local state = _G.pomodoro_state
    
    -- If parameters are provided, update durations
    if work_minutes and break_minutes then
        _G.set_pomodoro_durations(work_minutes, break_minutes)
    end
    
    if state.active then
        -- Pause: store remaining time
        state.active = false
        state.remaining = math.max(0, state.end_time - os.time())
        vim.notify("🍅", vim.log.levels.INFO)
    else
        -- Resume: use stored remaining time
        state.active = true
        state.end_time = os.time() + state.remaining
        
        -- Immediate visual feedback
        local minutes = math.floor(state.remaining / 60)
        local seconds = state.remaining % 60
        local mode = state.is_break and "🍵" or "🍅"
        vim.notify(string.format("%s %02d:%02d", mode, minutes, seconds), vim.log.levels.INFO)
        
        -- Create timer if it doesn't exist
        if not state.timer_id then
            state.timer_id = _G.create_timer(500, function()
                vim.cmd('redrawstatus!')
            end)
        else
            _G.resume_timer(state.timer_id)
        end
    end
    
    -- Force immediate redraw
    vim.cmd('redrawstatus!')
end

-- Function to get timer display
_G.pomodoro = function()
    local state = _G.pomodoro_state
    
    if not state.active then
        -- When paused, show the stored remaining time
        local minutes = math.floor(state.remaining / 60)
        local seconds = state.remaining % 60
        return fixed(string.format("⌁ %02d:%02d ⌁", minutes, seconds), 12)
    end
    
    local remaining = math.max(0, state.end_time - os.time())
        
    if remaining == 0 and state.active then
        -- Timer finished, switch modes
        state.is_break = not state.is_break
        state.remaining = state.is_break and state.break_duration or state.work_duration
        state.end_time = os.time() + state.remaining
        
        -- Notify user of the switch with emoji
        local message = state.is_break and 
            string.format("🍵", state.break_duration / 60) or 
            string.format("🍅", state.work_duration / 60)
        vim.notify(message, vim.log.levels.INFO)
        
        -- Only play sound when timer ends, not when it starts
        -- Play completion sound
        vim.fn.jobstart('afplay /System/Library/Sounds/Glass.aiff')
    end
    
    local minutes = math.floor(remaining / 60)
    local seconds = remaining % 60
    return fixed(string.format("⌁ %02d:%02d ⌁", minutes, seconds), 12)
end

-- Basic pomodoro toggle


-- Custom duration pomodoro examples
-- vim.keymap.set("n", "<leader>tp", function() _G.toggle_timer(25, 5)  end, { desc = "pomodoro 25/5" })
-- vim.keymap.set("n", "<leader>tl", function() _G.toggle_timer(50, 10) end, { desc = "long pomodoro 50/10" })
vim.keymap.set("n", "<leader>t", function() _G.toggle_timer(25, 5)  end, { desc = "test" })


-- 5 = POSITION ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
_G.get_position = function()
    local line = vim.fn.line(".")
    local col = vim.fn.col(".")
    return fixed(string.format(" %04d:%04d", line, col), 12)
end

-- 6 = PERCENT ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
_G.get_percent = function()
    local p = math.floor((vim.fn.line(".") / vim.fn.line("$")) * 100)
    local formatted_p = p == 100 and "100" or string.format("%03d", p)
    return fixed(" " .. formatted_p .. "%", 7.5)
end

-- 7 = COLORSCHEME without padding
_G.get_colorscheme_no_padding = function()
    local time = os.date("%I:%M %p") -- Added %p for AM/PM indication
    local theme = vim.g.colors_name == "am" and "AM" or "PM"
    -- Remove trailing space
    return " " .. time .. "/" .. theme
end

-- Set up timer for clock updates
_G.create_timer(1000, function()
    vim.cmd('redrawstatus')
end)





-- TAB_BAR PLUGIN ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

-- pm.vim theme tabs
-- tabs should only present over their target buffer
-- the nvim-tree tab should have a bg #151414 and fg #151414
-- active tabs should have a #efece9 bg and #151414 fg normal text
-- inactive tabs should have a #151414 bg and #151414 fg normal text
-- tabs should have a border-radius if possible
-- tabs should have a transprent space between them that exposes the background
-- the tab close button should be 🅧 and color #ff4f00

-- am.vim theme tabs
-- tabs for am should be the exact oppposite of the pm.vim theme
-- tabs should automatically change based on the current theme




















-- COLORSCHEME ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
local function ampm(x, y)
    local hour = tonumber(os.date("%H"))
    return (hour >= x and hour < y) and "am" or "pm"
end

-- Initialize custom tabline
require("custom.tabline").setup()

-- Set initial theme based on time at startup
vim.cmd.colorscheme(ampm(5, 22))

-- Define the Ghostty config path
local ghostty_config_path = os.getenv("HOME") .. "/Library/Application Support/com.mitchellh.ghostty/config"

local function toggle_theme()
    -- Step 1: Call your /usr/local/bin/ampm script to change terminal theme
    local run_result = vim.fn.system({ "/usr/local/bin/ampm" })

    -- Optional debug
    -- print("ampm output: " .. run_result)

    -- Step 2: Read Ghostty's config and extract current theme
    local file = io.open(ghostty_config_path, "r")
    if not file then
        print("⚠ Could not open Ghostty config file.")
        return
    end

    local content = file:read("*a")
    file:close()

    -- Step 3: Add a small delay before changing Neovim theme
    -- This allows terminal theme change to complete first
    vim.defer_fn(function()
        local theme = content:match("theme%s*=%s*(%w+)")
        if theme == "am" or theme == "pm" then
            vim.cmd.colorscheme(theme)
            vim.g.current_theme = theme
        else
            print("⚠ Theme not found in Ghostty config.")
        end
    end, 0) -- 100ms delay, adjust as needed
end

vim.keymap.set("n", "<leader>m", toggle_theme, { desc = "Toggle light/dark theme" })

-- Theme watcher functionality
local config_watcher = nil

local function apply_theme_from_ghostty_config()
    local file = io.open(ghostty_config_path, "r")
    if not file then return end

    local content = file:read("*a")
    file:close()

    local theme = content:match("theme%s*=%s*(%w+)")
    if theme and (theme == "am" or theme == "pm") then
        if vim.g.colors_name ~= theme then
            vim.cmd.colorscheme(theme)
            vim.g.current_theme = theme
            -- Print message removed
        end
    end
end

local function start_theme_watcher()
    if config_watcher then return end
    config_watcher = vim.loop.new_fs_event()
    config_watcher:start(ghostty_config_path, {}, vim.schedule_wrap(function()
        apply_theme_from_ghostty_config()
    end))
end

start_theme_watcher()

-- Optional: sync on focus
vim.api.nvim_create_autocmd("FocusGained", {
    callback = apply_theme_from_ghostty_config,
})

-- LAZY NEOVIM 
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

    "nvim-lua/plenary.nvim",

    {"nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = { 
          width = 30,
          float = {
            enable = false,
          },
          preserve_window_proportions = true,
          adaptive_size = true,
        },
        renderer = { 
          group_empty = true,
          full_name = true,
        },
        filters = { dotfiles = true },
        actions = {
          open_file = {
            resize_window = true,
          },
        },
      })
      
      -- Subscribe to TreeOpen event to hide statusline
      require('nvim-tree.api').events.subscribe("TreeOpen", function()
        vim.wo.statusline = ' '
      end)

      -- Auto open nvim-tree when Neovim starts
      vim.api.nvim_create_autocmd({ "VimEnter" }, {
        callback = function()
          require("nvim-tree.api").tree.open()
        end
      })
    end,
  },
{
    -- git config --global --add safe.directory /Users/io/.local/share/nvim/lazy/noice.nvim
    -- git config --global --add safe.directory /Users/io/.local/share/nvim/lazy/nui.nvim
    -- sudo chown -R $(whoami) /Users/io/.local/share/nvim/lazy/noice.nvim
    -- sudo chown -R $(whoami) /Users/io/.local/share/nvim/lazy/nui.nvim
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
      }
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      animate = { enabled = true },
      dim = { enabled = true },
      image = { enabled = true },
      indent = { enabled = true },
      scroll = { enabled = true },
      zen = { enabled = true },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn' },
          change       = { hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
          delete       = { hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
          topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn' },
          changedelete = { hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn' },
        },
        signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          interval = 1000,
          follow_files = true
        },
        attach_to_untracked = true,
        current_line_blame = false,
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000,
        preview_config = {
          border = "rounded",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1
        },
        yadm = { enable = false },
      })
    end,
  },
  

  -- RENDER-MARKDOWN
  {"MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.nvim",
    },
  },
  -- RENDER-MARKDOWN [https://github.com/MeanderingProgrammer/render-markdown.nvim.git]
  

})


