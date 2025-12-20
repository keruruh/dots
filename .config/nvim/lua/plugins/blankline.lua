return {
    "lukas-reineke/indent-blankline.nvim",

    main = "ibl",

    config = function()
        local ibl = require("ibl")
        local ibl_hooks = require("ibl.hooks")

        local highlight = {
            "RainbowRed",
            "RainbowYellow",
            "RainbowBlue",
            "RainbowOrange",
            "RainbowGreen",
            "RainbowViolet",
            "RainbowCyan",
        }

        ibl_hooks.register(ibl_hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#e06c75" })
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#e5c07b" })
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61afef" })
            vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#d19a66" })
            vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98c379" })
            vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#c678dd" })
            vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56b6c2" })
        end)

        vim.g.rainbow_delimiters = { highlight = highlight }

        ibl.setup({ scope = { highlight = highlight } })

        ibl_hooks.register(
            ibl_hooks.type.SCOPE_HIGHLIGHT,
            ibl_hooks.builtin.scope_highlight_from_extmark
        )
    end,
}
