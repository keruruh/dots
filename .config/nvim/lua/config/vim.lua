local g = vim.g
local o = vim.o

-- Set leaders.
g.mapleader = " "
g.maplocalleader = " "

-- Enable relative line numbers.
o.number = true
o.relativenumber = true

-- Enable mouse mode.
o.mouse = "a"

-- Configure indentation.
o.expandtab = true
o.smartindent = true
o.tabstop = 4
o.shiftwidth = 4

-- Sync clipboard between the OS and Neovim.
vim.schedule(function()
    o.clipboard = "unnamedplus"
end)

o.breakindent = true

-- Save undo history
o.undofile = true

-- Enable case-insensitive searching.
o.ignorecase = true
o.smartcase = true

o.signcolumn = "no"

o.updatetime = 250
o.timeoutlen = 300

-- Configure how new splits should be opened.
o.splitright = true
o.splitbelow = true

-- Configure how Neovim will display certain whitespace characters in the editor.
o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live.
o.inccommand = "split"

-- Show which line the cursor is on.
o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
o.scrolloff = 10

-- If performing an operation that would fail due to unsaved changes in the
-- buffer, instead raise a dialog asking if you wish to save the current file.
o.confirm = true
