-- See https://neovim.io/doc/user/options.html or use ":help <command>" for more
-- information of all available options.

-- Year of God 2025 and we still default to indenting with tabs...
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Use the system clipboard.
vim.opt.clipboard = "unnamedplus"

-- Show a confirmation dialog instead of failing when exiting when unsaved changes.
vim.opt.confirm = true

-- Highlight the line where the cursor is and the column at "colorcolumn" characters of
-- length, with the latter being a tuple of integers without spaces, like "X,Y,Z".
vim.opt.cursorline = true
vim.opt.colorcolumn = "88"

-- Enable case-insensitive searching unless explicitly stated by using "\C" or one
-- (or more) capital letters in the search term.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Live preview substitutions in a split screen.
vim.opt.inccommand = "split"

-- Display whitespace characters.
vim.opt.list = true
vim.opt.listchars = {
    tab = "» ",
    trail = "·",
    nbsp = "␣",
}

-- Enable mouse where "a" means "all modes".
vim.opt.mouse = "a"

-- Enable relative line numbers.
vim.opt.number = true
vim.opt.relativenumber = true

-- Minimal number of lines to keep above and below the cursor when scrolling.
vim.opt.scrolloff = 10

-- Save undo history after exiting.
vim.opt.undofile = true

-- Disable text wrapping.
vim.opt.wrap = false
