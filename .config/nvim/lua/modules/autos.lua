vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    desc = "Remove all trailing whitespace on save.",
    pattern = { "*" },

    callback = function()
        local saved_cursor = vim.fn.getpos(".")

        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", saved_cursor)
    end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    desc = "Highlight when yanking (copying) text.",

    callback = function()
        vim.hl.on_yank()
    end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "<filetype>" },

    callback = function()
        vim.treesitter.start()
    end,
})
