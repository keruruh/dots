-- NOTE: Plugin settings are defined in each plugin's Lua file.

-- See https://neovim.io/doc/user/options.html or use ":help <command>" for more
-- information of all available options.

local o = vim.opt

-- Year of God 2025 and we still default to indenting with tabs...
o.breakindent = true
o.expandtab = true
o.smartindent = true
o.shiftwidth = 4
o.tabstop = 4

-- Use the system clipboard.
o.clipboard = "unnamedplus"

-- Show a confirmation dialog instead of failing when exiting when unsaved changes.
o.confirm = true

-- Highlight the line where the cursor is and the column at "colorcolumn" characters of
-- length, with the latter being a tuple of integers without spaces, like "X,Y,Z".
o.cursorline = true
o.colorcolumn = "88"

-- Disable "~" characters at the end of the buffer.
o.fillchars = { eob = " " }

-- Enable case-insensitive searching unless explicitly stated by using "\C" or one
-- (or more) capital letters in the search term.
o.ignorecase = true
o.smartcase = true

-- Live preview substitutions in a split screen.
o.inccommand = "split"

-- Display whitespace characters.
o.list = true
o.listchars = {
    nbsp = "␣",
    tab = "» ",
    trail = "·",
}

-- Enable mouse where "a" means "all modes".
o.mouse = "a"

-- Disable swap file creation.
o.swapfile = false

-- Enable relative line numbers.
o.number = true
o.relativenumber = true

-- Minimal number of lines to keep above and below the cursor when scrolling.
o.scrolloff = 10

-- Save undo history after exiting.
o.undofile = true

-- Disable text wrapping.
o.wrap = false
