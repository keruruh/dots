-- All the settings, keybinds, autocmds and such defined in this file are for Vim"s
-- internal actions only. Per-plugin configurations are defined in each plugin"s Lua
-- file.

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

-- Disable "~" characters at the end of the buffer.
vim.opt.fillchars = { eob = " " }

-- Enable case-insensitive searching unless explicitly stated by using "\C" or one
-- (or more) capital letters in the search term.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Live preview substitutions in a split screen.
vim.opt.inccommand = "split"

-- Display whitespace characters.
vim.opt.list = true
vim.opt.listchars = {
    nbsp = "␣",
    tab = "» ",
    trail = "·",
}

-- Enable mouse where "a" means "all modes".
vim.opt.mouse = "a"

-- Disable swap file creation.
vim.opt.swapfile = false

-- Enable relative line numbers.
vim.opt.number = true
vim.opt.relativenumber = true

-- Minimal number of lines to keep above and below the cursor when scrolling.
vim.opt.scrolloff = 10

-- Save undo history after exiting.
vim.opt.undofile = true

-- Disable text wrapping.
vim.opt.wrap = false

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    desc = "Remove Trailing Whitespace on Save",
    pattern = { "*" },

    callback = function()
        local saved_cursor = vim.fn.getpos(".")

        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", saved_cursor)
    end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    desc = "Highlight Text after Yank",

    callback = function()
        vim.hl.on_yank()
    end,
})

vim.api.nvim_create_autocmd({ "InsertEnter" }, {
    desc = "Disable Relative Numbers on Insert",

    callback = function()
        if vim.o.number then
            vim.opt.relativenumber = false
        end
    end,
})

vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    desc = "Enable Relative Numbers Outside of Insert",

    callback = function()
        if vim.o.number then
            vim.opt.relativenumber = true
        end
    end,
})

vim.keymap.set("n", "<Left>", '<Cmd>echo "Use h to move!"<CR>')
vim.keymap.set("n", "<Right>", '<Cmd>echo "Use l to move!"<CR>')
vim.keymap.set("n", "<Up>", '<Cmd>echo "Use k to move!"<CR>')
vim.keymap.set("n", "<Down>", '<Cmd>echo "Use j to move!"<CR>')

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit Terminal Mode" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move Focus to the Left Window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move Focus to the Right Window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move Focus to the Lower Window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move Focus to the Upper Window" })

vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move Window to the Left" })
vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move Window to the Right" })
vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move Window to the Lower" })
vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move Window to the Upper" })
