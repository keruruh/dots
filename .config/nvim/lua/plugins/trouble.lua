return {
    "folke/trouble.nvim",

    cmd = { "Trouble" },

    keys = {
        {
            desc = "Open Diagnostics (Trouble)",

            "<Leader>xx",
            "<Cmd>Trouble diagnostics toggle<CR>",
        },
    },

    opts = {
        modes = {
            current_buffer = {
                mode = "diagnostics",

                filter = {
                    any = {
                        buf = 0,

                        {
                            severity = vim.diagnostic.severity.ERROR,

                            function(item)
                                return item.filename:find(
                                    (vim.loop or vim.uv).cwd(),
                                    1,
                                    true
                                )
                            end,
                        },
                    },
                },
            },
        },
    },
}
