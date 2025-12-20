return {
    "nvim-treesitter/nvim-treesitter",

    build = ":TSUpdate",

    config = function()
        local ts = require("nvim-treesitter")

        ts.setup({
            auto_install = true,
            ensure_installed = { "maintained" },

            highlight = {
                enable = true,

                -- Some languages depend on Vim's regex highlighting system (like Ruby)
                -- for indent rules. If you are experiencing weird indenting issues,
                -- add the language to the list of "additional_vim_regex_highlighting"
                -- and disabled languages for indent.
                additional_vim_regex_highlighting = {
                    "ruby",
                },
            },

            indent = {
                enable = true,
                disable = { "ruby" },
            },
        })

        vim.api.nvim_create_autocmd({ "FileType" }, {
            desc = "Start the TreeSitter Plugin",
            pattern = { "<filetype>" },

            callback = function()
                vim.treesitter.start()
            end,
        })
    end
}
