local auto = vim.api.nvim_create_autocmd

auto({ "BufWritePre" }, {
    desc = "Remove Trailing Whitespace on Save",
    pattern = { "*" },

    callback = function()
        local saved_cursor = vim.fn.getpos(".")

        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", saved_cursor)
    end,
})

auto({ "TextYankPost" }, {
    desc = "Highlight Text after Yank",

    callback = function()
        vim.hl.on_yank()
    end,
})

auto({ "InsertEnter" }, {
    desc = "Disable Relative Numbers on Insert",

    callback = function()
        if vim.o.number then
            vim.opt.relativenumber = false
        end
    end,
})

auto({ "InsertLeave" }, {
    desc = "Enable Relative Numbers Outside of Insert",

    callback = function()
        if vim.o.number then
            vim.opt.relativenumber = true
        end
    end,
})

auto({ "CmdlineEnter" }, {
    group = vim.api.nvim_create_augroup("on_cmdlineenter", { clear = true }),
    desc = "Do Not Hide the Status-Line When Typing a Command",

    callback = function()
        vim.opt.cmdheight = 1
    end,
})

auto({ "CmdlineLeave" }, {
    group = vim.api.nvim_create_augroup("on_cmdlineleave", { clear = true }),
    desc = "Hide the Command-Line When Not Typing a Command",

    callback = function()
        vim.opt.cmdheight = 0
    end,
})
