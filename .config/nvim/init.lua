vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

-- Bootstrap lazy.nvim plugin manager.
-- For more information visit: https://lazy.folke.io/installation

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazy_path) then
    local lazy_repo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazy_repo,
        lazy_path,
    })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:" .. "\n", "ErrorMsg" },
            { out .. "\n", "WarningMsg" },
            { "Press any key to exit..." },
        }, true, {})

        vim.fn.getchar()

        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazy_path)

local lazy = require("lazy")

lazy.setup({
    spec = {
        { import = "plugins" },
    },

    checker = {
        enabled = true,
        notify = false,
    },
})

require("vim.autos")
require("vim.keys")
require("vim.settings")
require("vim.welcome")

vim.cmd([[colorscheme gruvbox]])
